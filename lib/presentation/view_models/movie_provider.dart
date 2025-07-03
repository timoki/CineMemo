import 'package:cine_memo/data/dio_client.dart';
import 'package:cine_memo/data/repositories/movie_repository_impl.dart';
import 'package:cine_memo/domain/repositories/movie_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

// 4. FutureProvider: getPopularMovies 함수를 비동기적으로 호출하고 그 결과를 제공
final popularMoviesProvider = FutureProvider((ref) {
  // movieRepositoryProvider를 읽어서(watch) getPopularMovies 함수 호출
  return ref.watch(movieRepositoryProvider).getPopularMovies();
});
