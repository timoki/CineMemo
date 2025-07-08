import 'package:flutter/material.dart';

import '../../core/res/strings.dart';

class LogoWidget extends StatelessWidget {
  const LogoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      AppStrings.appName,
      style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
    );
  }
}
