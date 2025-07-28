// lib/widgets/game_symbol_tile.dart

import 'package:flutter/material.dart';

class GameSymbolTile extends StatelessWidget {
  final String imagePath;
  final String label;

  const GameSymbolTile({
    super.key,
    required this.imagePath,
    required this.label, required String fruitName,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              image: AssetImage(imagePath),
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(color: Colors.white),
        ),
      ],
    );
  }
}
