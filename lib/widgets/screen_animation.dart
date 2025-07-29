import 'package:flutter/material.dart';

// Updated SymbolModel with static helper
class SymbolModel {
  final String imagePath;

  SymbolModel({required this.imagePath});

  static List<SymbolModel> fromPaths(List<String> paths) {
    return paths.map((path) => SymbolModel(imagePath: path)).toList();
  }
}

class AnimatedSymbolsWidget extends StatefulWidget {
  final List<SymbolModel> symbols;

  const AnimatedSymbolsWidget({Key? key, required this.symbols}) : super(key: key);

  @override
  _AnimatedSymbolsWidgetState createState() => _AnimatedSymbolsWidgetState();
}

class _AnimatedSymbolsWidgetState extends State<AnimatedSymbolsWidget>
    with TickerProviderStateMixin {
  late AnimationController _labelController;
  late Animation<double> _labelScale;

  late List<AnimationController> _symbolControllers;
  late List<Animation<Offset>> _symbolAnimations;

  @override
  void initState() {
    super.initState();

    _labelController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _labelScale = TweenSequence([
      TweenSequenceItem(
        tween: Tween(begin: 1.0, end: 1.2).chain(CurveTween(curve: Curves.easeOut)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 1.2, end: 1.0).chain(CurveTween(curve: Curves.easeIn)),
        weight: 50,
      ),
    ]).animate(_labelController);

    _labelController.forward();

    _symbolControllers = [];
    _symbolAnimations = [];

    for (int i = 0; i < widget.symbols.length; i++) {
      final controller = AnimationController(
        duration: const Duration(milliseconds: 800),
        vsync: this,
      );
      final animation = Tween<Offset>(
        begin: const Offset(0, -2),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeOutBack),
      );

      _symbolControllers.add(controller);
      _symbolAnimations.add(animation);
    }

    _playSymbolAnimations();
  }

  Future<void> _playSymbolAnimations() async {
    for (int i = 0; i < _symbolControllers.length; i++) {
      await Future.delayed(const Duration(milliseconds: 150));
      _symbolControllers[i].forward();
    }
  }

  @override
  void dispose() {
    _labelController.dispose();
    for (final controller in _symbolControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Center(
            child: ScaleTransition(
              scale: _labelScale,
              child: SizedBox(
                width: screenWidth,
                child: Image.asset(
                  'assets/images/game_label.webp',
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: Center(
            child: Wrap(
              spacing: 16,
              runSpacing: 16,
              alignment: WrapAlignment.center,
              children: List.generate(widget.symbols.length, (index) {
                return SlideTransition(
                  position: _symbolAnimations[index],
                  child: Image.asset(
                    widget.symbols[index].imagePath,
                    width: 60,
                    height: 60,
                  ),
                );
              }),
            ),
          ),
        ),
      ],
    );
  }
}
