// lib/widgets/gradient_extension.dart

import 'package:flutter/material.dart';

extension GradientBackground on BoxDecoration {
  static BoxDecoration candyBackground() {
    return const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFFff9a9e),
          Color(0xFFfad0c4),
          Color(0xFFfad0c4),
        ],
      ),
    );
  }
}
