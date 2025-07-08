import '../entities/movie_entity.dart';
import '../repositories/movie_repository.dart';

class GetPopularMoviesUseCase {
  final MovieRepository _repository;

  GetPopularMoviesUseCase(this._repository);

  Future<List<MovieEntity>> call() async {
    return _repository.getPopularMovies();
  }
}
