import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      // 앱의 기본 색상 구성표 정의
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.deepPurple,
        brightness: Brightness.light,
      ),
      // 앱의 기본 텍스트 테마 정의 (타이포그래피)
      textTheme: GoogleFonts.notoSansKrTextTheme(ThemeData.light().textTheme),
      appBarTheme: const AppBarTheme(elevation: 2, centerTitle: false),
    );
  }

  // TODO: 추후 다크 모드 테마도 이곳에 추가할 수 있습니다.
  // static ThemeData get darkTheme { ... }
}
