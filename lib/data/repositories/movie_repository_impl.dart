import 'package:cine_memo/data/dio_client.dart';
import 'package:cine_memo/data/models/movie_model.dart';
import 'package:cine_memo/domain/entities/movie_entity.dart';
import 'package:cine_memo/domain/repositories/movie_repository.dart';

class MovieRepositoryImpl implements MovieRepository {
  static const String apiRoute = "movie/";
  static const String popular = "popular";

  final DioClient dioClient;

  MovieRepositoryImpl(this.dioClient);

  @override
  Future<List<MovieEntity>> getPopularMovies() async {
    try {
      final response = await dioClient.get("$apiRoute$popular");
      final results = (response.data['results'] as List)
          .map((json) => MovieModel.fromJson(json).toEntity())
          .toList();
      return results;
    } catch (e) {
      print("Error fetching popular movies: $e");
      // 실제 앱에서는 로깅 또는 사용자에게 보여줄 에러 처리
      rethrow;
    }
  }

  @override
  Future<MovieEntity> getMovieDetailById(int movieId) async {
    try {
      final response = await dioClient.get("$apiRoute$movieId");
      return MovieModel.fromJson(response.data).toEntity();
    } catch (e) {
      print("Error fetching movie detail: $e");
      rethrow;
    }
  }
}
