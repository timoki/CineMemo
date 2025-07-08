import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cine_memo/domain/repositories/user_data_repository.dart';

class SaveMemoUseCase {
  final UserDataRepository _repository;

  SaveMemoUseCase(this._repository);

  Future<void> call({
    required String uid,
    required int movieId,
    required String text,
    DocumentReference? docRef,
  }) {
    return _repository.saveMemo(
      uid: uid,
      movieId: movieId,
      text: text,
      docRef: docRef,
    );
  }
}
