import 'package:cine_memo/core/res/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../view_models/auth_view_model.dart';
import '../widgets/logo_widget.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. AuthViewModel의 상태를 감시(watch)합니다.
    final authState = ref.watch(authViewModelProvider);

    // 2. 로그인 실패 시 에러 메시지를 보여주기 위한 리스너
    ref.listen(authViewModelProvider, (_, state) {
      if (state.hasError && !state.isLoading) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(state.error.toString())));
      }
    });

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LogoWidget(),
            const SizedBox(height: 50),
            ElevatedButton.icon(
              icon: authState.isLoading
                  ? Container(
                      width: 24,
                      height: 24,
                      padding: const EdgeInsets.all(2.0),
                      child: const CircularProgressIndicator(strokeWidth: 3),
                    )
                  : const Icon(Icons.login),
              label: const Text(AppStrings.googleLogin),
              onPressed: authState.isLoading
                  ? null
                  : () {
                      // 4. 버튼을 누르면 AuthViewModel의 메소드를 호출
                      ref
                          .read(authViewModelProvider.notifier)
                          .signInWithGoogle();
                    },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 15,
                ),
                textStyle: const TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
