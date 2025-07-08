import '../repositories/user_data_repository.dart';

class UnlikeMovieUseCase {
  final UserDataRepository _repository;

  UnlikeMovieUseCase(this._repository);

  Future<void> call({required String uid, required int movieId}) async {
    return _repository.unlikeMovie(uid, movieId);
  }
}
