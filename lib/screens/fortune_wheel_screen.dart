import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sweet_bonanza/screens/game_rules_screen.dart';
import 'package:sweet_bonanza/screens/settings_screen.dart';
import '../model/game_model.dart';
import '../widgets/bet_setting.dart';
import '../widgets/game_control_button.dart';

class FortuneWheelScreen extends StatefulWidget {
  const FortuneWheelScreen({super.key});

  @override
  State<FortuneWheelScreen> createState() => _FortuneWheelScreenState();
}

class _FortuneWheelScreenState extends State<FortuneWheelScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _wheelRotationAnimation;
  final Random _random = Random();
  double _currentWheelAngle = 0.0;
  bool _isSpinning = false;

  final List<Map<String, dynamic>> _wheelSegments = [
    {'value': 0.5, 'color': const Color(0xFF79CF5E)},
    {'value': 1.5, 'color': const Color(0xFF9F59F5)},
    {'value': 7.0, 'color': const Color(0xFF4AA4EE)},
    {'value': 0.5, 'color': const Color(0xFFF79447)},
    {'value': 1.2, 'color': const Color(0xFF57DFD8)},
    {'value': 1.2, 'color': const Color(0xFF46B368)},
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _wheelRotationAnimation = Tween<double>(
      begin: _currentWheelAngle,
      end: _currentWheelAngle,
    ).animate(_animationController);
  }

  void _onSpin(BuildContext context) async {
    final shopData = Provider.of<ShopData>(context, listen: false);

    if (_isSpinning || shopData.credits < shopData.bet) return;
    setState(() => _isSpinning = true);

    shopData.spinGame();
    if (shopData.ambientMusicOn && shopData.soundFxOn) {
      shopData.playWheelSpinSound();
    }

    final int targetSegment = _random.nextInt(_wheelSegments.length);
    final double multiplier = _wheelSegments[targetSegment]['value'];

    const double baseSpins = 5;
    final double targetAngleDeg = targetSegment * (360.0 / _wheelSegments.length);
    final double totalRotationDeg = (baseSpins + _random.nextDouble() * 5) * 360 + targetAngleDeg;

    _wheelRotationAnimation = Tween<double>(
      begin: _currentWheelAngle,
      end: totalRotationDeg * (pi / 180),
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutQuart,
      ),
    );

    _animationController.reset();
    await _animationController.forward();

    shopData.playWheelStopSound();
    shopData.winCredits((shopData.bet * multiplier).round());

    _currentWheelAngle = _wheelRotationAnimation.value % (2 * pi);
    setState(() => _isSpinning = false);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final shopData = Provider.of<ShopData>(context);
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
                child: Image.asset(
                  'assets/images/game_label.webp',
                  fit: BoxFit.cover,
                ),
              ),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final double size = constraints.maxWidth < constraints.maxHeight
                        ? constraints.maxWidth * 1.0
                        : constraints.maxHeight * 1.0;

                    return Center(
                      child: SizedBox(
                        width: size,
                        height: size,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // 🎡 Rotating Wheel
                            AnimatedBuilder(
                              animation: _wheelRotationAnimation,
                              builder: (context, child) {
                                final double angle = _isSpinning
                                    ? _wheelRotationAnimation.value
                                    : _currentWheelAngle;
                                return Transform.rotate(
                                  angle: angle,
                                  child: Image.asset(
                                    'assets/images/wheel.webp',
                                    width: size,
                                    height: size,
                                    fit: BoxFit.contain,
                                  ),
                                );
                              },
                            ),

                            // 📍 Pointer (fixed at top center)
                            Positioned(
                              top: 0,
                              child: Image.asset(
                                'assets/images/pointer.webp',
                                width: size * 0.15, // ~15% of wheel size
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              Text(
                shopData.credits < shopData.bet ? "NOT ENOUGH CREDITS" : "SPIN THE WHEEL!",
                        style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                         shadows: [
                            Shadow(
                             offset: Offset(1.0, 1.0),
                              blurRadius: 2.0,
                                color: Colors.black54,
                            ),
                         ],
                      ),
                    ),
              const SizedBox(height: 20),
              Consumer<ShopData>(
                builder: (context, shopData, child) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16.0, top: 20.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GameControlButton(
                              assetPath: 'assets/images/button_spin.webp',
                              onPressed: () => _onSpin(context),
                            ),
                            const SizedBox(width: 20),
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
                        const SizedBox(height: 30),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.settings, color: Colors.white, size: 28),
                                onPressed: () {
                                  final shopData = Provider.of<ShopData>(context, listen: false);
                                  shopData.playTapSound();
                                  showDialog(
                                    context: context,
                                    builder: (_) => const SettingsDialog(),
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
                                  final shopData = Provider.of<ShopData>(context, listen: false);
                                  shopData.playTapSound();
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

// Utility Extension
extension on LinearGradient {
  BoxDecoration toBoxDecoration({BorderRadiusGeometry? borderRadius}) {
    return BoxDecoration(gradient: this, borderRadius: borderRadius);
  }
}
