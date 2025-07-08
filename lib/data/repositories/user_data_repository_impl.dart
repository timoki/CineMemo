import 'package:cine_memo/domain/repositories/user_data_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserDataRepositoryImpl implements UserDataRepository {
  final FirebaseFirestore _fireStore;

  UserDataRepositoryImpl(this._fireStore);

  @override
  Stream<DocumentSnapshot> getLikedMoviesStream(String uid) {
    return _fireStore.collection('users').doc(uid).snapshots();
  }

  @override
  Future<void> likeMovie(String uid, int movieId) {
    return _fireStore.collection('users').doc(uid).set({
      'liked_movies': FieldValue.arrayUnion([movieId]),
    }, SetOptions(merge: true));
  }

  @override
  Future<void> unlikeMovie(String uid, int movieId) {
    return _fireStore.collection('users').doc(uid).set({
      'liked_movies': FieldValue.arrayRemove([movieId]),
    }, SetOptions(merge: true));
  }

  @override
  Stream<QuerySnapshot> getMemoStream({
    required String uid,
    required int movieId,
  }) {
    return _fireStore
        .collection('memos')
        .where('uid', isEqualTo: uid)
        .where('movieId', isEqualTo: movieId)
        .limit(1)
        .snapshots();
  }

  @override
  Future<void> saveMemo({
    required String uid,
    required int movieId,
    required String text,
    DocumentReference? docRef,
  }) {
    final memoData = {
      'uid': uid,
      'movieId': movieId,
      'text': text,
      'timestamp': FieldValue.serverTimestamp(),
    };

    if (docRef != null) {
      // 수정
      return docRef.update(memoData);
    } else {
      // 생성
      return _fireStore.collection('memos').add(memoData);
    }
  }

  @override
  Future<List<int>> getLikedMovieIds({required String uid}) async {
    final snapshot = await _fireStore.collection('users').doc(uid).get();
    final data = snapshot.data() as Map<String, dynamic>;
    final likedMovies = data['liked_movies'] as List? ?? [];
    return likedMovies.cast<int>();
  }

  @override
  Future<void> updateLikedMoviesOrder({
    required String uid,
    required List<int> movieIds,
  }) {
    return _fireStore.collection('users').doc(uid).set({
      'liked_movies': movieIds,
    }, SetOptions(merge: true));
  }

  @override
  Future<List<QueryDocumentSnapshot>> getAllMemos({required String uid}) async {
    final snapshot = await _fireStore
        .collection('memos')
        .where('uid', isEqualTo: uid)
        .orderBy('timestamp', descending: true)
        .get();
    return snapshot.docs;
  }
}
