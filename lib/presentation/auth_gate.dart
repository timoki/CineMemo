import 'package:cine_memo/presentation/screens/home_screen.dart';
import 'package:cine_memo/presentation/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// FirebaseAuth의 인증 상태 변경을 스트림으로 제공하는 Provider
final authStateProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});

class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // authStateProvider를 감시
    final authState = ref.watch(authStateProvider);

    return authState.when(
      data: (user) {
        // user 객체가 있으면 (로그인 상태) HomeScreen을 보여줌
        if (user != null) {
          return const HomeScreen();
        }
        // user 객체가 없으면 (로그아웃 상태) LoginScreen을 보여줌
        else {
          return const LoginScreen();
        }
      },
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (err, stack) => Scaffold(body: Center(child: Text('에러 발생: $err'))),
    );
  }
}
