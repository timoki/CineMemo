import 'package:cine_memo/core/extensions/async_value_ui.dart';
import 'package:cine_memo/core/res/strings.dart';
import 'package:cine_memo/presentation/screens/detail_screen.dart';
import 'package:cine_memo/presentation/view_models/liked_movies_view_model.dart'; // 곧 만들 파일
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/router/app_router.dart';
import '../../domain/entities/movie_entity.dart';
import '../view_models/auth_view_model.dart';
import '../view_models/user_data_provider.dart';

class LikedMoviesScreen extends ConsumerStatefulWidget {
  const LikedMoviesScreen({super.key});

  @override
  ConsumerState<LikedMoviesScreen> createState() => _LikedMoviesScreenState();
}

class _LikedMoviesScreenState extends ConsumerState<LikedMoviesScreen> {
  @override
  Widget build(BuildContext context) {
    final likedMoviesState = ref.watch(likedMoviesViewModelProvider);

    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.likedMoviesTitle)),
      body: likedMoviesState.toWidget((movies) {
        if (movies.isEmpty) {
          return const Center(child: Text(AppStrings.noResultLikedMovies));
        }
        return ReorderableListView.builder(
          itemCount: movies.length,
          itemBuilder: (context, index) {
            final movie = movies[index];
            return ListTile(
              key: ValueKey(movie.id),
              leading: Image.network(
                movie.posterPath,
                width: 50,
                fit: BoxFit.cover,
              ),
              title: Text(movie.title),
              subtitle: Text(
                movie.overview,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: const Icon(Icons.drag_handle),
              onTap: () {
                Navigator.push(
                  context,
                  AppRouter.createSharedAxisRoute(
                    page: DetailScreen(movie: movie),
                  ),
                );
              },
            );
          },
          onReorder: (oldIndex, newIndex) {
            // 사용자가 드래그를 놓았을 때의 처리
            if (oldIndex < newIndex) {
              newIndex--;
            }
            // 1. UI 즉각 반응을 위해 로컬 리스트 순서 변경
            final List<MovieEntity> reorderedMovies = List.from(movies);
            final movie = reorderedMovies.removeAt(oldIndex);
            reorderedMovies.insert(newIndex, movie);

            // 2. 변경된 리스트로 UI 상태를 즉시 업데이트
            ref
                .read(likedMoviesViewModelProvider.notifier)
                .reorderMovies(reorderedMovies);

            // 3. 변경된 ID 리스트 추출
            final reorderedIds = reorderedMovies.map((m) => m.id).toList();
            final user = ref.read(authStateProvider).value;
            if (user == null) return;

            // 4. Firestore에 변경된 순서 저장
            ref.read(updateLikedMoviesOrderUseCaseProvider)(
              uid: user.uid,
              movieIds: reorderedIds,
            );
          },
        );
      }),
    );
  }
}
