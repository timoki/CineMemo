import 'package:cine_memo/core/extensions/async_value_ui.dart';
import 'package:cine_memo/core/res/app_values.dart';
import 'package:cine_memo/core/res/strings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/router/app_router.dart';
import '../../domain/entities/movie_entity.dart';
import '../view_models/liked_movies_view_model.dart';
import '../view_models/user_data_provider.dart';
import 'edit_memo_screen.dart';

class DetailScreen extends ConsumerWidget {
  final MovieEntity movie;

  const DetailScreen({super.key, required this.movie});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 현재 로그인한 사용자 정보 가져오기
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      // 로그인하지 않은 사용자는 찜하기 기능을 사용할 수 없으므로 바로 리턴
      return const Scaffold(
        body: Center(child: Text(AppStrings.loginRequiredMessage)),
      );
    }

    final userData = ref.watch(userDataStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(movie.title),
        actions: [
          userData.toWidget((snapshot) {
            var likedMovies = [];
            if (snapshot.exists) {
              final data = snapshot.data() as Map<String, dynamic>;
              likedMovies = data['liked_movies'] as List? ?? [];
            }
            final isLiked = likedMovies.contains(movie.id);

            return IconButton(
              icon: Icon(
                isLiked ? Icons.favorite : Icons.favorite_border,
                color: AppColors.favoriteRed,
              ),
              onPressed: () async {
                if (isLiked) {
                  // UnlikeMovieUseCase 호출
                  await ref.read(unlikeMovieUseCaseProvider)(
                    uid: user.uid,
                    movieId: movie.id,
                  );
                } else {
                  // LikeMovieUseCase 호출
                  await ref.read(likeMovieUseCaseProvider)(
                    uid: user.uid,
                    movieId: movie.id,
                  );
                }
                // 작업이 끝난 후, 찜 목록 Provider를 초기화하여 다시 불러오게 함
                ref.invalidate(likedMoviesViewModelProvider);
              },
            );
          }),
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
                padding: const EdgeInsets.all(AppDimens.defaultPadding),
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
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimens.defaultPadding,
                ),
                child: Text(
                  movie.overview,
                  style: const TextStyle(fontSize: AppDimens.defaultTextSize),
                ),
              ),
              // 구분선
              const Divider(
                height: 30,
                thickness: 1,
                indent: AppDimens.defaultPadding,
                endIndent: AppDimens.defaultPadding,
              ),
              // 메모 영역
              _buildMemoSection(context, user, movie, ref),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildMemoSection(
  BuildContext context,
  User user,
  MovieEntity movie,
  WidgetRef ref,
) {
  // 현재 사용자와 현재 영화에 해당하는 메모를 찾는 쿼리
  final memoData = ref.watch(memoStreamProvider(movie.id));

  return memoData.toWidget((snapshot) {
    // 아직 작성된 메모가 없는 경우
    if (snapshot.docs.isEmpty) {
      return Center(
        child: ElevatedButton.icon(
          icon: const Icon(Icons.edit),
          label: const Text(AppStrings.writeMemoButton),
          onPressed: () {
            Navigator.push(
              context,
              AppRouter.createSharedAxisRoute(
                page: EditMemoScreen(movieId: movie.id),
              ),
            );
          },
        ),
      );
    }

    // 작성된 메모가 있는 경우
    final memoDoc = snapshot.docs.first;
    final memoText = memoDoc['text'];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimens.defaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                AppStrings.myMemoTitle,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              TextButton(
                child: const Text(AppStrings.editMemoButton),
                onPressed: () {
                  Navigator.push(
                    context,
                    AppRouter.createSharedAxisRoute(
                      page: EditMemoScreen(movieId: movie.id, memoDoc: memoDoc),
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            memoText,
            style: const TextStyle(fontSize: AppDimens.defaultTextSize),
          ),
        ],
      ),
    );
  });
}
