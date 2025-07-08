import 'package:cine_memo/core/res/strings.dart';
import 'package:cine_memo/presentation/view_models/memos_view_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/res/app_values.dart';
import '../view_models/user_data_provider.dart';

class EditMemoScreen extends ConsumerStatefulWidget {
  final int movieId;
  final DocumentSnapshot? memoDoc; // 수정할 메모 문서 (없으면 새 메모)

  const EditMemoScreen({super.key, required this.movieId, this.memoDoc});

  @override
  ConsumerState<EditMemoScreen> createState() => _EditMemoScreenState();
}

class _EditMemoScreenState extends ConsumerState<EditMemoScreen> {
  late final TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    // 기존 메모가 있으면 그 내용으로, 없으면 빈 칸으로 컨트롤러 초기화
    _textController = TextEditingController(
      text: widget.memoDoc?['text'] ?? '',
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Future<void> _saveMemo() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return;
    }

    final memoText = _textController.text;
    if (memoText.isEmpty) {
      return;
    }

    await ref.read(saveMemoUseCaseProvider)(
      uid: user.uid,
      movieId: widget.movieId,
      text: _textController.text,
      docRef: widget.memoDoc?.reference,
    );

    if (mounted) {
      ref.invalidate(memosViewModelProvider);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.memoDoc == null ? AppStrings.writeMemo : AppStrings.editMemo,
        ),
        actions: [
          IconButton(icon: const Icon(Icons.save), onPressed: _saveMemo),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppDimens.defaultPadding),
        child: TextField(
          controller: _textController,
          maxLines: null, // 여러 줄 입력 가능
          expands: true, // 화면 전체 사용
          decoration: const InputDecoration(
            hintText: AppStrings.writeMemoHint,
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }
}
