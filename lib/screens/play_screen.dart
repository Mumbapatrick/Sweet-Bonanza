// lib/screens/play_screen.dart

import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sweet_bonanza/screens/settings_screen.dart';
import '../model/game_model.dart';
import '../widgets/bet_setting.dart';
import '../widgets/game_control_button.dart';
import '../widgets/game_symbol_tile.dart';
import 'game_rules_screen.dart';

class PlayScreen extends StatefulWidget {
  const PlayScreen({super.key});

  @override
  State<PlayScreen> createState() => _PlayScreenState();
}

class _PlayScreenState extends State<PlayScreen> {
  late List<String> _currentGridSymbols;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _currentGridSymbols = _generateRandomGrid(
      Provider.of<ShopData>(context, listen: false).gameSymbols,
      30,
    );
  }

  List<String> _generateRandomGrid(List<String> symbols, int count) {
    return List.generate(count, (_) => symbols[_random.nextInt(symbols.length)]);
  }

  void _onSpin() {
    Provider.of<ShopData>(context, listen: false).spinGame();
    setState(() {
      _currentGridSymbols = _generateRandomGrid(
        Provider.of<ShopData>(context, listen: false).gameSymbols,
        30,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
      child: Image.asset(
        'assets/images/backgrounds/steam.webp',
        fit: BoxFit.cover,
             ),
          ),
          Positioned.fill(
            child: Container(
              decoration: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.blue.shade300.withOpacity(0.2),
                  Colors.blue.shade800.withOpacity(0.5),
                  Colors.deepPurple.shade900.withOpacity(0.7),
                ],
              ).toBoxDecoration(),
            ),
          ),
          Column(
            children: [
              SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.only(right: 16.0, top: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.white, size: 30),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Image.asset('assets/images/game_label.webp',
                ),
              ),
              Expanded(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          color: Colors.white.withOpacity(0.1),
                          child: GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: _currentGridSymbols.length,
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 6,
                              mainAxisSpacing: 4,
                              crossAxisSpacing: 4,
                              childAspectRatio: 0.9,
                            ),
                            itemBuilder: (context, index) {
                              return GameSymbolTile(fruitName: _currentGridSymbols[index], imagePath: '', label: '',);
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Consumer<ShopData>(
                builder: (context, shopData, child) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16.0, top: 20.0),
                    child: Column(
                      children: [
                        const Text(
                          "PLACE YOUR BETS!",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(offset: Offset(1.0, 1.0), blurRadius: 2.0, color: Colors.black54),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GameControlButton(
                              assetPath: 'assets/images/button_spin.webp',
                              onPressed: _onSpin, backgroundColor: null,
                            ),
                            const SizedBox(width: 20),
                                GameControlButton(
                                  assetPath: 'assets/images/button_bet.webp',
                                  onPressed: (){
                                    showDialog(
                                      context: context,
                                       builder: (_) => const BetSettingsDialog(),
                                            );
                                    },
                                ),
                              ],
                            ),

                            const SizedBox(height: 30),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.4),
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(color: Colors.white24, width: 1),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              IconButton(
                               icon: const Icon(Icons.settings, color: Colors.white, size: 28),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (ctx) => const SettingsDialog(),
                                  );
                                },
                              ),
                              Text(
                                "CREDIT: ${shopData.credits}",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "BET: ${shopData.bet}",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.info_outline, color: Colors.white, size: 28),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const GameRulesScreen(),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
extension on LinearGradient {
  BoxDecoration toBoxDecoration({BorderRadiusGeometry? borderRadius}) {
    return BoxDecoration(gradient: this, borderRadius: borderRadius);
  }
}
