import 'package:cine_memo/domain/repositories/user_data_repository.dart';

class UpdateLikedMoviesOrderUseCase {
  final UserDataRepository _repository;

  UpdateLikedMoviesOrderUseCase(this._repository);

  Future<void> call({required String uid, required List<int> movieIds}) {
    return _repository.updateLikedMoviesOrder(uid: uid, movieIds: movieIds);
  }
}
