import 'package:cine_memo/data/repositories/user_data_repository_impl.dart';
import 'package:cine_memo/domain/repositories/user_data_repository.dart';
import 'package:cine_memo/domain/usecases/get_user_data_stream_usecase.dart';
import 'package:cine_memo/domain/usecases/like_movie_usecase.dart';
import 'package:cine_memo/domain/usecases/unlike_movie_usecase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/usecases/get_memo_stream_usecase.dart';
import '../../domain/usecases/save_memo_usecase.dart';
import '../../domain/usecases/update_liked_movies_order_usecase.dart';
import 'auth_view_model.dart';

// Firestore Repository Provider
final userDataRepositoryProvider = Provider<UserDataRepository>((ref) {
  return UserDataRepositoryImpl(FirebaseFirestore.instance);
});

// UseCase Providers
final getUserDataStreamUseCaseProvider = Provider<GetUserDataStreamUseCase>((
  ref,
) {
  return GetUserDataStreamUseCase(ref.watch(userDataRepositoryProvider));
});
final likeMovieUseCaseProvider = Provider<LikeMovieUseCase>((ref) {
  return LikeMovieUseCase(ref.watch(userDataRepositoryProvider));
});
final unlikeMovieUseCaseProvider = Provider<UnlikeMovieUseCase>((ref) {
  return UnlikeMovieUseCase(ref.watch(userDataRepositoryProvider));
});

// 최종 데이터 스트림 Provider
final userDataStreamProvider = StreamProvider<DocumentSnapshot>((ref) {
  final user = ref.watch(authStateProvider).value;
  if (user == null) {
    throw Exception('User is not logged in');
  }
  return ref.watch(getUserDataStreamUseCaseProvider)(uid: user.uid);
});

final getMemoStreamUseCaseProvider = Provider<GetMemoStreamUseCase>((ref) {
  return GetMemoStreamUseCase(ref.watch(userDataRepositoryProvider));
});
final saveMemoUseCaseProvider = Provider<SaveMemoUseCase>((ref) {
  return SaveMemoUseCase(ref.watch(userDataRepositoryProvider));
});

// --- 메모 데이터 스트림 Provider 추가 ---
// .family를 사용하여 movieId를 파라미터로 받을 수 있게 합니다.
final memoStreamProvider = StreamProvider.family<QuerySnapshot, int>((
  ref,
  movieId,
) {
  final user = ref.watch(authStateProvider).value;
  if (user == null) {
    throw Exception('User is not logged in');
  }
  return ref.watch(getMemoStreamUseCaseProvider)(
    uid: user.uid,
    movieId: movieId,
  );
});

final updateLikedMoviesOrderUseCaseProvider =
    Provider<UpdateLikedMoviesOrderUseCase>((ref) {
      return UpdateLikedMoviesOrderUseCase(
        ref.watch(userDataRepositoryProvider),
      );
    });
