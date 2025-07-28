import 'package:flutter/material.dart';

class GameControlButton extends StatelessWidget {
  final String? label;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final IconData? icon;
  final Color? iconColor;
  final String? assetPath;

  const GameControlButton({
    super.key,
    this.label,
    required this.onPressed,
    this.backgroundColor,
    this.icon,
    this.iconColor,
    this.assetPath,
  });

  @override
  Widget build(BuildContext context) {
    if (assetPath != null) {
      return GestureDetector(
        onTap: onPressed,
        child: Image.asset(
          assetPath!,
          width: 64,
          height: 64,
          fit: BoxFit.contain,
        ),
      );
    }

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor ?? Colors.orange,
        shape: const CircleBorder(),
        padding: const EdgeInsets.all(24),
      ),
      onPressed: onPressed,
      child: icon != null
          ? Icon(icon, color: iconColor ?? Colors.white, size: 32)
          : Text(
        label ?? '',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}


