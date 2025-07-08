import 'package:cloud_firestore/cloud_firestore.dart';

import '../repositories/user_data_repository.dart';

class GetUserDataStreamUseCase {
  final UserDataRepository _repository;

  GetUserDataStreamUseCase(this._repository);

  Stream<DocumentSnapshot> call({required String uid}) {
    return _repository.getLikedMoviesStream(uid);
  }
}
