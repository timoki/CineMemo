import 'package:cine_memo/domain/entities/movie_entity.dart';

abstract class MovieRepository {
  Future<List<MovieEntity>> getPopularMovies();
  Future<MovieEntity> getMovieDetailById(int movieId);
}
