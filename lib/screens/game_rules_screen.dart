// lib/screens/game_rules_screen.dart

import 'package:flutter/material.dart';

class GameRulesScreen extends StatelessWidget {
  const GameRulesScreen({super.key});

    static const List<SymbolData> symbols = [
    SymbolData('assets/images/symbols/symbol1', '7: x0.5\n8-10: x1.2\n11+: x1.4'),
    SymbolData('assets/images/symbols/symbol2', '7: x0.5\n8-10: x1.2\n11+: x1.4'),
    SymbolData( 'assets/images/symbols/symbol3','7: x0.5\n8-10: x1.2\n11+: x1.4'),
    SymbolData( 'assets/images/symbols/symbol4','7: x0.7\n8-10: x1.3\n11+: x1.5'),
    SymbolData( 'assets/images/symbols/symbol5','7: x0.7\n8-10: x1.3\n11+: x1.5'),
    SymbolData('assets/images/symbols/symbol6', '7: x0.7\n8-10: x1.3\n11+: x1.5'),
    SymbolData('assets/images/symbols/symbol7', '7: x1.0\n8-10: x1.4\n11+: x1.8'),
    SymbolData('assets/images/symbols/symbol8','7: x1.0\n8-10: x1.4\n11+: x1.8'),
    SymbolData('assets/images/symbols/symbol9','7: x1.2\n8-10: x1.6\n11+: x2.2'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: Color(0xFF111D3C),
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: const Color(0xFF202F54),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  const Spacer(),
                  const Text(
                    "GAME RULES",
                    style: TextStyle(
                      color: Colors.cyanAccent,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.cyanAccent),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                child: GridView.builder(
                  itemCount: symbols.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 16,
                    childAspectRatio: 3 / 2.5,
                  ),
                  itemBuilder: (context, index) {
                    final symbol = symbols[index];
                    return Column(
                      children: [
                        Image.asset('${symbol.imagePath}.png', height: 60),
                        const SizedBox(height: 8),
                        Text(
                          symbol.text,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              const Text(
                "Symbols pay anywhere on the screen. The total number of the same symbol on the screen at the end of a spin determines the value of the win.",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SymbolData {
  final String imagePath;
  final String text;

  const SymbolData(this.imagePath, this.text);
}
