import 'package:cine_memo/domain/repositories/user_data_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../entities/memo_with_movie_entity.dart';
import '../repositories/movie_repository.dart';

class GetAllMemosUseCase {
  final UserDataRepository _userDataRepository;
  final MovieRepository _movieRepository;

  GetAllMemosUseCase(this._userDataRepository, this._movieRepository);

  Future<List<MemoWithMovieEntity>> call() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return [];

    final memoDocs = await _userDataRepository.getAllMemos(uid: user.uid);

    final memoFutures = memoDocs.map((doc) async {
      final data = doc.data() as Map<String, dynamic>;
      final movieId = data['movieId'] as int;
      final memoText = data['text'] as String;
      final timeStamp = (data['timestamp'] as Timestamp).toDate();

      final movie = await _movieRepository.getMovieDetailById(movieId);

      return MemoWithMovieEntity(
        movie: movie,
        memoText: memoText,
        timestamp: timeStamp,
      );
    }).toList();

    return Future.wait(memoFutures);
  }
}
