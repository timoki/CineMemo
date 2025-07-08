import 'package:cloud_firestore/cloud_firestore.dart';

abstract class UserDataRepository {
  // 찜하기
  Stream<DocumentSnapshot> getLikedMoviesStream(String uid);
  Future<void> likeMovie(String uid, int movieId);
  Future<void> unlikeMovie(String uid, int movieId);

  // 메모
  Stream<QuerySnapshot> getMemoStream({
    required String uid,
    required int movieId,
  });

  Future<void> saveMemo({
    required String uid,
    required int movieId,
    required String text,
    DocumentReference? docRef,
  });

  // 찜한 영화 목록
  Future<List<int>> getLikedMovieIds({required String uid});

  // 찜한 영화 순서 저장
  Future<void> updateLikedMoviesOrder({
    required String uid,
    required List<int> movieIds,
  });

  // 모든 영화의 메모 가져오기
  Future<List<QueryDocumentSnapshot>> getAllMemos({required String uid});
}
