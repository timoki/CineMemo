import 'package:cine_memo/domain/repositories/user_data_repository.dart';

class LikeMovieUseCase {
  final UserDataRepository _repository;

  LikeMovieUseCase(this._repository);

  Future<void> call({required String uid, required int movieId}) async {
    return _repository.likeMovie(uid, movieId);
  }
}
