import 'package:cine_memo/domain/repositories/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuth _firebaseAuth;

  AuthRepositoryImpl(this._firebaseAuth);

  @override
  Future<void> signInWithGoogle() async {
    try {
      // GoogleAuthProvider 객체 생성
      final googleProvider = GoogleAuthProvider();

      // 이 공급자를 사용하여 로그인 팝업 띄우기
      await _firebaseAuth.signInWithProvider(googleProvider);
    } catch (e) {
      print("Google 로그인 오류: $e");
      rethrow;
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      print("로그아웃 오류: $e");
      rethrow;
    }
  }
}
