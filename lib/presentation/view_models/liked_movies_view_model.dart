import 'package:cine_memo/domain/entities/movie_entity.dart';
import 'package:cine_memo/domain/usecases/get_liked_movies_usecase.dart'; // 직접 만드셔야 합니다.
import 'package:cine_memo/presentation/view_models/user_data_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'movie_provider.dart';

final getLikedMoviesUseCaseProvider = Provider<GetLikedMoviesUseCase>((ref) {
  return GetLikedMoviesUseCase(
    ref.watch(movieRepositoryProvider),
    ref.watch(userDataRepositoryProvider),
  );
});

final likedMoviesViewModelProvider =
    AsyncNotifierProvider<LikedMoviesViewModel, List<MovieEntity>>(
      LikedMoviesViewModel.new,
    );

class LikedMoviesViewModel extends AsyncNotifier<List<MovieEntity>> {
  late GetLikedMoviesUseCase _getLikedMoviesUseCase;

  @override
  Future<List<MovieEntity>> build() async {
    _getLikedMoviesUseCase = ref.watch(getLikedMoviesUseCaseProvider);
    return _getLikedMoviesUseCase();
  }

  // 찜 상태가 변경되었을 때 목록을 새로고침하는 메소드
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _getLikedMoviesUseCase());
  }

  void reorderMovies(List<MovieEntity> reorderedMovies) {
    // 현재 상태를 새로운 리스트로 즉시 교체
    state = AsyncValue.data(reorderedMovies);
  }
}
