import 'package:cine_memo/data/dio_client.dart';
import 'package:cine_memo/data/repositories/movie_repository_impl.dart';
import 'package:cine_memo/domain/repositories/movie_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/movie_entity.dart';
import '../../domain/usecases/get_popular_movies_usecase.dart';

// 1. Dio Provider: Dio 인스턴스를 제공
final dioProvider = Provider<Dio>((ref) => Dio());

// 2. DioClient Provider: DioClient 인스턴스를 제공
final dioClientProvider = Provider<DioClient>(
  (ref) => DioClient(ref.watch(dioProvider)),
);

// 3. MovieRepository Provider: MovieRepository 구현체를 제공
final movieRepositoryProvider = Provider<MovieRepository>(
  (ref) => MovieRepositoryImpl(ref.watch(dioClientProvider)),
);

final getPopularMoviesUseCaseProvider = Provider<GetPopularMoviesUseCase>((
  ref,
) {
  // movieRepositoryProvider에 의존
  final repository = ref.watch(movieRepositoryProvider);
  return GetPopularMoviesUseCase(repository);
});

final popularMoviesProvider = FutureProvider<List<MovieEntity>>((ref) {
  return ref.watch(getPopularMoviesUseCaseProvider)(); // .call()은 생략 가능
});
