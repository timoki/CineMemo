import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/movie_entity.dart';

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
            ],
          ),
        ),
      ),
    );
  }
}
