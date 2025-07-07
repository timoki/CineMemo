import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/movie_entity.dart';
import 'edit_memo_screen.dart';

class DetailScreen extends StatelessWidget {
  final MovieEntity movie;

  const DetailScreen({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    // 현재 로그인한 사용자 정보 가져오기
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      // 로그인하지 않은 사용자는 찜하기 기능을 사용할 수 없으므로 바로 리턴
      return const Scaffold(body: Center(child: Text('로그인이 필요합니다.')));
    }

    // 사용자의 '찜' 목록을 실시간으로 감시할 Stream
    final likedMoviesStream = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .snapshots();

    return Scaffold(
      appBar: AppBar(
        title: Text(movie.title),
        actions: [
          // StreamBuilder를 사용해 찜 상태에 따라 다른 아이콘 표시
          StreamBuilder<DocumentSnapshot>(
            stream: likedMoviesStream,
            builder: (context, snapshot) {
              // 로딩 중일 때는 비활성화된 아이콘 표시
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const IconButton(
                  onPressed: null,
                  icon: Icon(Icons.favorite_border),
                );
              }

              // 문서가 존재하고 데이터가 있을 경우에만 likedMovies 리스트를 가져옴
              var likedMovies = []; // 기본값은 빈 리스트
              if (snapshot.hasData && snapshot.data!.exists) {
                final data = snapshot.data!.data() as Map<String, dynamic>;
                // 'liked_movies' 필드가 존재하면 해당 리스트를, 없으면 빈 리스트를 사용
                likedMovies = data['liked_movies'] as List? ?? [];
              }

              final isLiked = likedMovies.contains(movie.id);

              return IconButton(
                icon: Icon(
                  isLiked ? Icons.favorite : Icons.favorite_border,
                  color: Colors.redAccent,
                ),
                onPressed: () async {
                  final userDoc = FirebaseFirestore.instance
                      .collection('users')
                      .doc(user.uid);

                  if (isLiked) {
                    // 이미 찜한 경우: 배열에서 영화 ID 제거
                    await userDoc.set({
                      'liked_movies': FieldValue.arrayRemove([movie.id]),
                    }, SetOptions(merge: true));
                  } else {
                    // 찜하지 않은 경우: 배열에 영화 ID 추가
                    await userDoc.set({
                      'liked_movies': FieldValue.arrayUnion([movie.id]),
                    }, SetOptions(merge: true));
                  }
                },
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 영화 포스터
              Hero(
                tag: movie.id,
                child: Image.network(
                  movie.posterPath,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              // 영화 제목
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  movie.title,
                  style: const TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              // 영화 줄거리
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  movie.overview,
                  style: const TextStyle(fontSize: 16.0),
                ),
              ),
              // 구분선
              const Divider(
                height: 30,
                thickness: 1,
                indent: 16,
                endIndent: 16,
              ),
              // 메모 영역
              _buildMemoSection(context, user, movie),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildMemoSection(BuildContext context, User user, MovieEntity movie) {
  // 현재 사용자와 현재 영화에 해당하는 메모를 찾는 쿼리
  final memoStream = FirebaseFirestore.instance
      .collection('memos')
      .where('uid', isEqualTo: user.uid)
      .where('movieId', isEqualTo: movie.id)
      .limit(1)
      .snapshots();

  return StreamBuilder<QuerySnapshot>(
    stream: memoStream,
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      }
      // 아직 작성된 메모가 없는 경우
      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
        return Center(
          child: ElevatedButton.icon(
            icon: const Icon(Icons.edit),
            label: const Text('나만의 메모 작성하기'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => EditMemoScreen(movieId: movie.id),
                ),
              );
            },
          ),
        );
      }

      // 작성된 메모가 있는 경우
      final memoDoc = snapshot.data!.docs.first;
      final memoText = memoDoc['text'];

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '나의 메모',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  child: const Text('수정하기'),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            EditMemoScreen(movieId: movie.id, memoDoc: memoDoc),
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(memoText, style: const TextStyle(fontSize: 16)),
          ],
        ),
      );
    },
  );
}
