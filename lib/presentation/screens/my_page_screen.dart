import 'dart:io';
import 'package:cine_memo/presentation/view_models/auth_view_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class MyPageScreen extends ConsumerWidget {
  const MyPageScreen({super.key});

  static File? _imageFile;

  Future<void> _pickAndUploadImage(WidgetRef ref, User user) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      _imageFile = File(pickedFile.path);
      // TODO: ViewModel을 통해 이미지 업로드 및 프로필 업데이트 로직 호출
      // 예: ref.read(myPageViewModelProvider.notifier).updateProfileImage(imageFile);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 실시간으로 사용자 정보 감시
    final user = ref.watch(authStateProvider).value;

    return Scaffold(
      appBar: AppBar(title: const Text('마이페이지')),
      body: user == null
          ? const Center(child: Text('로그인 정보가 없습니다.'))
          : ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () => _pickAndUploadImage(ref, user),
                        child: CircleAvatar(
                          radius: 50,
                          backgroundImage: _imageFile != null
                              ? NetworkImage(_imageFile!.path)
                              : user.photoURL != null
                              ? NetworkImage(user.photoURL!)
                              : null,
                          child: user.photoURL == null
                              ? const Icon(Icons.person, size: 50)
                              : null,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        user.displayName ?? '이름 없음',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      Text(user.email ?? ''),
                    ],
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.edit),
                  title: const Text('닉네임 변경'),
                  onTap: () {
                    // TODO: 닉네임 변경 다이얼로그 띄우기
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text('로그아웃'),
                  onTap: () {
                    ref.read(authRepositoryProvider).signOut();
                  },
                ),
              ],
            ),
    );
  }
}
