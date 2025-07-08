import 'dart:async';
import 'package:cine_memo/data/repositories/auth_repository_impl.dart';
import 'package:cine_memo/domain/repositories/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// --- 모든 Auth 관련 Provider를 이 파일에서 관리 ---

// 1. 인증 상태 변경 스트림 Provider
final authStateProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});

// 2. AuthRepository 제공 Provider
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(FirebaseAuth.instance);
});

// 3. AuthViewModel 제공 Provider
final authViewModelProvider =
AsyncNotifierProvider<AuthViewModel, void>(AuthViewModel.new);


// --- AuthViewModel Notifier 클래스 ---

class AuthViewModel extends AsyncNotifier<void> {
  late AuthRepository _authRepository;

  @override
  FutureOr<void> build() {
    _authRepository = ref.watch(authRepositoryProvider);
  }

  Future<void> signInWithGoogle() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
          () => _authRepository.signInWithGoogle(),
    );
  }
}