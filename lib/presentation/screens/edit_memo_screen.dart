import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EditMemoScreen extends StatefulWidget {
  final int movieId;
  final DocumentSnapshot? memoDoc; // 수정할 메모 문서 (없으면 새 메모)

  const EditMemoScreen({super.key, required this.movieId, this.memoDoc});

  @override
  State<EditMemoScreen> createState() => _EditMemoScreenState();
}

class _EditMemoScreenState extends State<EditMemoScreen> {
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

    final memoData = {
      'uid': user.uid,
      'movieId': widget.movieId,
      'text': memoText,
      'timestamp': FieldValue.serverTimestamp(),
    };

    if (widget.memoDoc != null) {
      // 수정 모드: 기존 문서 업데이트
      await widget.memoDoc!.reference.update(memoData);
    } else {
      // 작성 모드: 새 문서 추가
      await FirebaseFirestore.instance.collection('memos').add(memoData);
    }

    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.memoDoc == null ? '메모 작성' : '메모 수정'),
        actions: [
          IconButton(icon: const Icon(Icons.save), onPressed: _saveMemo),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TextField(
          controller: _textController,
          maxLines: null, // 여러 줄 입력 가능
          expands: true, // 화면 전체 사용
          decoration: const InputDecoration(
            hintText: '영화에 대한 감상을 자유롭게 남겨보세요...',
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }
}
