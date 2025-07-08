import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cine_memo/domain/repositories/user_data_repository.dart';

class GetMemoStreamUseCase {
  final UserDataRepository _repository;

  GetMemoStreamUseCase(this._repository);

  Stream<QuerySnapshot> call({required String uid, required int movieId}) {
    return _repository.getMemoStream(uid: uid, movieId: movieId);
  }
}
