// lib/widgets/settings_dialog.dart
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sweet_bonanza/screens/privacy_policy.dart';
import 'package:sweet_bonanza/screens/support_screen.dart';
import '../model/game_model.dart';

class SettingsDialog extends StatelessWidget {
  const SettingsDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Stack(
        alignment: Alignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.85),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.white24, width: 1),
                ),
                child: Consumer<ShopData>(
                  builder: (context, shopData, child) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Stack(
                          children: [
                            Center(
                              child: Text(
                                "SETTINGS",
                                style: TextStyle(
                                  fontSize: 26,
                                  color: Colors.cyanAccent,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.topRight,
                              child: IconButton(
                                icon: const Icon(Icons.close, color: Colors.white, size: 28),
                                onPressed: () => Navigator.of(context).pop(),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        /// All options in one vertical line
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Expanded(
                                  child: Text(
                                    "Ambient Music",
                                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Switch(
                                  activeColor: Colors.orange,
                                  value: shopData.ambientMusicOn,
                                  onChanged: (_) => shopData.toggleAmbientMusic(),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                const Expanded(
                                  child: Text(
                                    "Sound FX",
                                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Switch(
                                  activeColor: Colors.orange,
                                  value: shopData.soundFxOn,
                                  onChanged: (_) => shopData.toggleSoundFx(),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                const Expanded(
                                  child: Text(
                                    "Language",
                                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                  ),
                                ),
                                DropdownButton<String>(
                                  value: shopData.selectedLanguage,
                                  dropdownColor: Colors.black,
                                  icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                                  underline: const SizedBox(), // No underline
                                  onChanged: (newValue) => shopData.setLanguage(newValue),
                                  items: shopData.availableLanguages.map((value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value, style: const TextStyle(color: Colors.white)),
                                    );
                                  }).toList(),
                                ),
                              ],
                            ),
                          ],
                        ),

                        const SizedBox(height: 25),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const PrivacyPolicyScreen()),
                            );
                          },
                          child: const Text(
                            "Privacy Policy",
                            style: TextStyle(color: Colors.cyanAccent, fontWeight: FontWeight.bold),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const SupportScreen()),
                            );
                          },
                          child: const Text(
                            "Support",
                            style: TextStyle(color: Colors.cyanAccent, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
