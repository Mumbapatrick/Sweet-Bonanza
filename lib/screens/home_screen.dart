// lib/screens/main_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sweet_bonanza/screens/settings_screen.dart';
import '../model/game_model.dart';
import '../widgets/home_action_button.dart';
import 'play_screen.dart';
import 'shop_screen.dart';
import 'fortune_wheel_screen.dart';

class MainAppScreen extends StatefulWidget {
  const MainAppScreen({super.key});

  @override
  State<MainAppScreen> createState() => _MainAppScreenState();
}

class _MainAppScreenState extends State<MainAppScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  get label => null;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )
      ..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
    // Music play logic
    Future.microtask(() async {
      final shopData = Provider.of<ShopData>(context, listen: false);
      await shopData.loadAudioSettings();
      if (shopData.ambientMusicOn) {
        shopData.playBackgroundMusic('assets/sound/game_music.mp3');
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children:[
      Positioned.fill(
        child: Image.asset(
        'assets/images/backgrounds/steam.webp',
              fit: BoxFit.cover,
            ),
      ),
      Positioned.fill(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withOpacity(0.1),
                Colors.black.withOpacity(0.5),
                Colors.black.withOpacity(0.7),
              ],
              stops: [0.0, 0.5, 1.0],
            ),
        ),
      ),
    ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedBuilder(
                  animation: _scaleAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _scaleAnimation.value,
                      child: Image.asset('assets/images/game_name.webp',
                        width:250,
                          fit:BoxFit.contain,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 50),
                HomeActionButton(
                  text: "PLAY",
                  onPressed: () {
                    final shopData = Provider.of<ShopData>(context, listen: false);
                    shopData.playTapSound();
                    var push = Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PlayScreen(),
                      ),
                    );
                  }, icon:Icons.play_arrow , label: ''
                ),
                const SizedBox(height: 20),
                HomeActionButton(
                  text: "FORTUNE WHEEL",
                  onPressed: () {
                    final shopData = Provider.of<ShopData>(context, listen: false);
                    shopData.playTapSound();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const FortuneWheelScreen(),
                      ),
                    );
                  }, icon:Icons.casino  , label: ''
                ),
                const SizedBox(height: 20),
                HomeActionButton(
                  text: "SHOP",
                  onPressed: () {
                    final shopData = Provider.of<ShopData>(context, listen: false);
                    shopData.playTapSound();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ShopScreen(),
                      ),
                    );
                  }, icon: Icons.store, label: '' ,
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 30,
            left: 30,
            child: IconButton(
              icon: const Icon(Icons.settings, color: Colors.white, size: 30),
              onPressed: () {
                final shopData = Provider.of<ShopData>(context, listen: false);
                shopData.playTapSound();
                showDialog(
                  context: context,
                  builder: (context) => const SettingsDialog(),
                );
              },
            ),
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