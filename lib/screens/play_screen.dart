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
  late List<String> _currentGridSymbols = [];
  final Random _random = Random();
  bool _isSpinning = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_currentGridSymbols.isEmpty) {
      final gameSymbols = Provider.of<ShopData>(context, listen: false).gameSymbols;
      _currentGridSymbols = _generateRandomGrid(gameSymbols, 30);
    }
  }

  List<String> _generateRandomGrid(List<String> symbols, int count) {
    return List.generate(count, (_) => symbols[_random.nextInt(symbols.length)]);
  }

  void _onSpin() async {
    final shopData = Provider.of<ShopData>(context, listen: false);

    if (_isSpinning || shopData.credits < shopData.bet) return;
    setState(() => _isSpinning = true);

    if (shopData.ambientMusicOn && shopData.soundFxOn) {
      shopData.playSymbolSound();
    }
    shopData.spinGame();

    setState(() {
      _currentGridSymbols = _generateRandomGrid(shopData.gameSymbols, 30);
      _isSpinning = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

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
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: Center(
                child: SizedBox(
                width: 300,
                 child: Image.asset(
                    'assets/images/game_label.webp',
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ),
              ),
              SizedBox(
                height: screenHeight * 0.43,
                     child: Center( // Optional: center the grid
                      child: Container(
                     width: screenWidth * 0.25, // ✅ set width here
                      height: (screenWidth * 0.25 / 6) * 5, // ✅ 6x5 grid height logic
                     padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        color: Colors.white.withOpacity(0.05),
                        child: GridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 6,
                            crossAxisSpacing: 1.5,
                            mainAxisSpacing: 1.5,
                            childAspectRatio: 1,
                          ),
                          itemCount: _currentGridSymbols.length,
                          itemBuilder: (context, index) {
                            return GameSymbolTile(imagePath: _currentGridSymbols[index]);
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
                    padding: const EdgeInsets.only(bottom: 12.0, top: 12.0),
                    child: Column(
                      children: [
                        Text(
                    shopData.credits < shopData.bet ? "NOT ENOUGH CREDIT!" : "PLACE YOUR BET!",
                      style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(offset: Offset(1.0, 1.0), blurRadius: 2.0, color: Colors.black54),
                            ],
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GameControlButton(
                              assetPath: 'assets/images/button_spin.webp',
                              onPressed: _onSpin,
                              backgroundColor: null,
                            ),
                            const SizedBox(width: 12),
                            GameControlButton(
                              assetPath: 'assets/images/button_bet.webp',
                              onPressed: () {
                                final shopData = Provider.of<ShopData>(context, listen: false);
                                shopData.playTapSound();
                                showDialog(
                                  context: context,
                                  builder: (_) => const BetSettingsDialog(),
                                );
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                          margin: const EdgeInsets.symmetric(horizontal: 14),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.settings, color: Colors.white, size: 22),
                                onPressed: () {
                                  final shopData = Provider.of<ShopData>(context, listen: false);
                                  shopData.playTapSound();
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
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "BET: ${shopData.bet}",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.info_outline, color: Colors.white, size: 22),
                                onPressed: () {
                                  final shopData = Provider.of<ShopData>(context, listen: false);
                                  shopData.playTapSound();
                                  showDialog(
                                    context:context,
                                      builder: (context) => const GameRulesScreen(),
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
