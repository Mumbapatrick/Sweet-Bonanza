import 'package:flutter/material.dart';

class GameSymbolTile extends StatelessWidget {
  final String imagePath;

  const GameSymbolTile({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = constraints.maxWidth;

        return Container(
          margin: const EdgeInsets.all(1),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.white.withOpacity(0.08),
          ),
          child: Padding(
            padding: EdgeInsets.all(size * 0.15),
            child: Image.asset(
              imagePath,
              fit: BoxFit.contain,
            ),
          ),
        );
      },
    );
  }
}
