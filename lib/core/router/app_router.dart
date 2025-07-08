import 'package:animations/animations.dart';
import 'package:flutter/material.dart';

class AppRouter {
  // PageRouteBuilder를 사용하여 커스텀 페이지 전환 효과를 만듭니다.
  static Route createSharedAxisRoute({required Widget page}) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        // SharedAxisTransition을 사용하여 수평(horizontal) 전환 효과를 적용합니다.
        return SharedAxisTransition(
          animation: animation,
          secondaryAnimation: secondaryAnimation,
          transitionType: SharedAxisTransitionType.horizontal,
          child: child,
        );
      },
    );
  }
}