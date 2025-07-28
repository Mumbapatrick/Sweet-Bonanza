// ignore_for_file: deprecated_member_use, duplicate_ignore

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:ui'; // For ImageFilter.blur
import 'dart:math'; // For Random class
// For Future and Timer

// Data Model
class ShopData extends ChangeNotifier {
  int _credits;
  int _bet; // Added for play screen
  final List<Map<String, dynamic>> _items;
  // Modified: _gameSymbols now stores fruit names instead of image URLs.
  final List<String> _gameSymbols;

  // New fields for settings
  bool _ambientMusicOn;
  bool _soundFxOn;
  String _selectedLanguage;
  final List<String> _availableLanguages;

  ShopData()
      : _credits = 842,
        _bet = 100, // Initial bet value for the game screen
        _items = <Map<String, dynamic>>[
          <String, dynamic>{
            'name': 'Candy Land',
            'image':
            'https://www.gstatic.com/flutter-onestack-prototype/genui/example_1.jpg',
            'owned': true,
            'selected': false,
            'price': null,
          },
          <String, dynamic>{
            'name': 'Enchanted Confection',
            'image':
            'https://www.gstatic.com/flutter-onestack-prototype/genui/example_1.jpg',
            'owned': true,
            'selected': true,
            'price': null,
          },
          <String, dynamic>{
            'name': 'Sugarpunk Forge',
            'image':
            'https://www.gstatic.com/flutter-onestack-prototype/genui/example_1.jpg',
            'owned': false,
            'price': 1200,
          },
          <String, dynamic>{
            'name': 'Candy Cybercore',
            'image':
            'https://www.gstatic.com/flutter-onestack-prototype/genui/example_1.jpg',
            'owned': false,
            'price': 1600,
          },
          <String, dynamic>{
            'name': 'Wasteland Sweets',
            'image':
            'https://www.gstatic.com/flutter-onestack-prototype/genui/example_1.jpg',
            'owned': false,
            'price': 2000,
          },
          <String, dynamic>{
            'name': 'Dark Candy Alley',
            'image':
            'https://www.gstatic.com/flutter-onestack-prototype/genui/example_1.jpg',
            'owned': false,
            'price': 2400,
          },
        ],
  // Changed _gameSymbols to be a list of fruit names
        _gameSymbols = <String>[
          'Apple',
          'Banana',
          'Cherry',
          'Grape',
          'Lemon',
          'Orange',
          'Strawberry',
          'Watermelon',
        ],
  // Initialize new settings fields
        _ambientMusicOn = true,
        _soundFxOn = true,
        _selectedLanguage = 'ENGLISH',
        _availableLanguages = <String>['ENGLISH', 'DEUTSCH', 'ESPANOL', 'FRANCAIS','ITALIANO','POLSKI','PORTUGUES'];

  int get credits => _credits;
  int get bet => _bet;
  List<Map<String, dynamic>> get items => _items;
  List<String> get gameSymbols => _gameSymbols;

  // Getters for settings
  bool get ambientMusicOn => _ambientMusicOn;
  bool get soundFxOn => _soundFxOn;
  String get selectedLanguage => _selectedLanguage;
  List<String> get availableLanguages => _availableLanguages;

  void buyItem(int index) {
    if (index >= 0 && index < _items.length) {
      final Map<String, dynamic> item = _items[index];
      final int? price = item['price'] as int?;
      if (price != null && !(item['owned'] as bool) && _credits >= price) {
        _credits -= price;
        item['owned'] = true;
        item['price'] = null; // No longer has a price once owned.
        notifyListeners();
      }
    }
  }

  void selectItem(int index) {
    if (index >= 0 && index < _items.length) {
      final Map<String, dynamic> item = _items[index];
      if (item['owned'] as bool) {
        // Deselect all others, then select this one
        for (final Map<String, dynamic> i in _items) {
          i['selected'] = false;
        }
        item['selected'] = true;
        notifyListeners();
      }
    }
  }

  // New methods for Play screen
  void increaseBet() {
    // Example: cycle through a few bet values
    if (_bet == 1) {
      _bet = 5;
    } else if (_bet == 10) {
      _bet = 25;
    } else if (_bet == 50) {
      _bet = 100;
    } else {
      _bet = 100; // Reset or default
    }
    notifyListeners();
  }

  void spinGame() {
    if (_credits >= _bet) {
      _credits -= _bet;
      // In a real game, this would trigger actual slot logic
      // and potentially add credits for wins. For this exercise,
      // it just deducts the bet.
      notifyListeners();
    } else {
      // Not enough credits, perhaps show a message
      // print("Not enough credits to spin!");
    }
  }

  void winCredits(int amount) {
    _credits += amount;
    notifyListeners();
  }

  // New methods for settings
  void toggleAmbientMusic() {
    _ambientMusicOn = !_ambientMusicOn;
    notifyListeners();
  }

  void toggleSoundFx() {
    _soundFxOn = !_soundFxOn;
    notifyListeners();
  }

  void setLanguage(String? newLanguage) {
    if (newLanguage != null && _availableLanguages.contains(newLanguage)) {
      _selectedLanguage = newLanguage;
      notifyListeners();
    }
  }
}

void main() {
  runApp(
    ChangeNotifierProvider<ShopData>(
      create: (BuildContext context) => ShopData(),
      builder: (BuildContext context, Widget? child) => const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: MainAppScreen(),
      ),
    ),
  );
}

class MainAppScreen extends StatefulWidget {
  const MainAppScreen({super.key});

  @override
  State<MainAppScreen> createState() => _MainAppScreenState();
}

class _MainAppScreenState extends State<MainAppScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(
        seconds: 2,
      ), // Adjust duration for desired swing speed
    )..repeat(reverse: true); // Repeat indefinitely, reversing direction

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut, // Smooth "swinging" effect
      ),
    );
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
        children: <Widget>[
          // Background Image
          Positioned.fill(
            child: Image.network(
              'https://www.gstatic.com/flutter-onestack-prototype/genui/example_1.jpg',
              fit: BoxFit.cover,
            ),
          ),
          // NEW: Gradient Overlay for MainAppScreen to improve contrast
          Positioned.fill(
            child: Container(
              decoration: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: <Color>[
                  Colors.black.withOpacity(0.1), // Very light top
                  Colors.black.withOpacity(0.5), // Medium bottom
                  Colors.black.withOpacity(0.7), // Darker at the very bottom
                ],
                stops: const <double>[0.0, 0.5, 1.0],
              ).toBoxDecoration(),
            ),
          ),
          // Content: Logo and Buttons
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // Sweet Billions Logo with animation
                AnimatedBuilder(
                  animation: _scaleAnimation,
                  builder: (BuildContext context, Widget? child) {
                    return Transform.scale(
                      scale: _scaleAnimation.value,
                      child: const Text(
                        "SWEET BILLIONS",
                        style: TextStyle(
                          fontSize: 48,
                          color: Colors.pink,
                          fontWeight: FontWeight.bold,
                          shadows: <Shadow>[
                            Shadow(
                              offset: Offset(3.0, 3.0),
                              blurRadius: 3.0,
                              color: Color.fromARGB(255, 100, 0, 100),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 50),
                // Play Button
                _HomeActionButton(
                  text: "PLAY",
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) => const PlayScreen(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
                // Fortune Wheel Button
                _HomeActionButton(
                  text: "FORTUNE WHEEL",
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) =>
                        const FortuneWheelScreen(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
                // Shop Button
                _HomeActionButton(
                  text: "SHOP",
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) => const ShopScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          // Settings Icon
          Positioned(
            bottom: 30,
            left: 30,
            child: IconButton(
              icon: const Icon(Icons.settings, color: Colors.white, size: 30),
              onPressed: () {
                showDialog<void>(
                  context: context,
                  builder: (BuildContext dialogContext) {
                    return const SettingsDialog();
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// Custom widget for consistent styling of home screen buttons
class _HomeActionButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const _HomeActionButton({required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor:
        Colors.orange.shade700, // Specific orange color from image
        padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 20,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class ShopScreen extends StatelessWidget {
  const ShopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple.shade900,
      body: Stack(
        children: <Widget>[
          Center(
            child: Container(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.8),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Consumer<ShopData>(
                builder: (BuildContext context, ShopData shopData, Widget? child) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const Text(
                        "SHOP",
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.cyanAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Credits: ${shopData.credits}",
                        style: const TextStyle(color: Colors.white),
                      ),
                      const Divider(color: Colors.white24),
                      Flexible(
                        child: GridView.builder(
                          shrinkWrap: true,
                          itemCount: shopData.items.length,
                          gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 12,
                            crossAxisSpacing: 12,
                            childAspectRatio: 0.75,
                          ),
                          itemBuilder: (BuildContext context, int index) {
                            final Map<String, dynamic> item =
                            shopData.items[index];
                            final bool owned = item['owned'] as bool;
                            // Handle null for items without 'selected' by defaulting to false
                            final bool selected =
                                (item['selected'] as bool?) ?? false;

                            return Container(
                              decoration: BoxDecoration(
                                color: Colors.black87,
                                borderRadius: BorderRadius.circular(12),
                                border: selected
                                    ? Border.all(
                                  color: Colors.cyanAccent,
                                  width: 3,
                                )
                                    : null,
                              ),
                              child: Column(
                                children: <Widget>[
                                  Expanded(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.network(
                                        item['image'] as String,
                                        fit: BoxFit.cover,
                                        // Apply overlay only if not owned
                                        color: owned
                                            ? null
                                            : Colors.black.withOpacity(0.5),
                                        colorBlendMode: owned
                                            ? null
                                            : BlendMode.darken,
                                        errorBuilder:
                                            (
                                            BuildContext context,
                                            Object error,
                                            StackTrace? stackTrace,
                                            ) {
                                          return const Center(
                                            child: Icon(
                                              Icons.broken_image,
                                              color: Colors.grey,
                                              size: 48,
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 4.0,
                                    ),
                                    child: Text(
                                      item['name'] as String,
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 8.0),
                                    child: owned
                                        ? ElevatedButton(
                                      onPressed: () {
                                        shopData.selectItem(index);
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: selected
                                            ? Colors.black54
                                            : Colors.green,
                                      ),
                                      child: Text(
                                        selected ? 'SELECTED' : 'SELECT',
                                        style: const TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    )
                                        : ElevatedButton(
                                      onPressed: () {
                                        shopData.buyItem(index);
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                        Colors.amber[800],
                                      ),
                                      child: Text(
                                        'BUY: ${item['price']}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
          Positioned(
            top: 20,
            right: 20,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white, size: 30),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class PlayScreen extends StatefulWidget {
  const PlayScreen({super.key});

  @override
  State<PlayScreen> createState() => _PlayScreenState();
}

class _PlayScreenState extends State<PlayScreen> {
  // To hold the currently displayed grid symbols (fruit names), potentially changing after a spin
  late List<String> _currentGridSymbols;
  final Random _random = Random(); // Initialize Random for use in generation

  @override
  void initState() {
    super.initState();
    // Initialize the grid with random fruit names.
    _currentGridSymbols = _generateRandomGrid(
      Provider.of<ShopData>(context, listen: false).gameSymbols,
      6 * 5,
    ); // 6 columns, 5 rows
  }

  // Generates a list of random symbols (fruit names) for the grid
  List<String> _generateRandomGrid(List<String> availableSymbols, int count) {
    final List<String> grid = <String>[];
    for (int i = 0; i < count; i++) {
      grid.add(
        availableSymbols[_random.nextInt(availableSymbols.length)],
      ); // Use random index
    }
    return grid;
  }

  void _onSpin() {
    // In a real game, this would trigger actual slot machine spin logic,
    // deducting bet, calculating win, and updating _currentGridSymbols.
    Provider.of<ShopData>(context, listen: false).spinGame();
    setState(() {
      _currentGridSymbols = _generateRandomGrid(
        Provider.of<ShopData>(context, listen: false).gameSymbols,
        6 * 5,
      ); // Re-generate symbols
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          // Background Image
          Positioned.fill(
            child: Image.network(
              'https://www.gstatic.com/flutter-onestack-prototype/genui/example_1.jpg',
              fit: BoxFit.cover,
            ),
          ),
          // Gradient Overlay to blend background with game area
          Positioned.fill(
            child: Container(
              decoration: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: <Color>[
                  Colors.blue.shade300.withOpacity(0.2), // Light blue top
                  Colors.blue.shade800.withOpacity(0.5), // Darker blue mid
                  Colors.deepPurple.shade900.withOpacity(
                    0.7,
                  ), // Deep purple bottom
                ],
                stops: const <double>[0.0, 0.5, 1.0],
              ).toBoxDecoration(),
            ),
          ),
          Column(
            children: <Widget>[
              // Top Bar (Status bar space + Close button)
              SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.only(right: 16.0, top: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      IconButton(
                        icon: const Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 30,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                ),
              ),
              // Sweet Billions Logo
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20.0),
                child: Text(
                  "SWEET BILLIONS",
                  style: TextStyle(
                    fontSize: 40, // Reduced font size to help fit grid
                    color: Color(0xFFF06292), // Pink for SWEET
                    fontWeight: FontWeight.w900,
                    shadows: <Shadow>[
                      Shadow(
                        offset: Offset(4.0, 4.0),
                        blurRadius: 3.0,
                        color: Color(0xFF6A1B9A), // Purple for outline
                      ),
                      Shadow(
                        offset: Offset(-4.0, -4.0),
                        blurRadius: 3.0,
                        color: Color(0xFFFFCC80), // Yellow/orange highlight
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                child: Center(
                  child: Padding(
                    // Added Padding to create horizontal margin for the grid area
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(
                          sigmaX: 5.0,
                          sigmaY: 5.0,
                        ), // Frosted glass effect
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          color: Colors.white.withOpacity(
                            0.1,
                          ), // Semi-transparent background for grid
                          child: GridView.builder(
                            shrinkWrap: true,
                            physics:
                            const NeverScrollableScrollPhysics(), // Prevent scrolling grid
                            itemCount: _currentGridSymbols.length,
                            gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 6,
                              mainAxisSpacing: 4, // Reduced spacing
                              crossAxisSpacing: 4, // Reduced spacing
                              childAspectRatio:
                              0.9, // Adjusted aspect ratio to make tiles appear more compact
                            ),
                            itemBuilder: (BuildContext context, int index) {
                              return _GameSymbolTile(
                                fruitName:
                                _currentGridSymbols[index], // Pass fruit name
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // Bottom UI
              Consumer<ShopData>(
                builder:
                    (BuildContext context, ShopData shopData, Widget? child) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16.0, top: 20.0),
                    child: Column(
                      children: <Widget>[
                        const Text(
                          "PLACE YOUR BETS!",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            shadows: <Shadow>[
                              Shadow(
                                offset: Offset(1.0, 1.0),
                                blurRadius: 2.0,
                                color: Colors.black54,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            _GameControlButton(
                              icon: Icons.refresh, // Spin icon
                              backgroundColor: const Color(
                                0xFF1E88E5,
                              ), // Blue for spin button
                              iconColor: Colors
                                  .amber
                                  .shade300, // Yellowish for icon
                              onPressed: _onSpin,
                            ),
                            const SizedBox(width: 20),
                            _GameControlButton(
                              icon: Icons.monetization_on, // Coins icon
                              backgroundColor: Colors
                                  .green
                                  .shade600, // Green for bet button
                              iconColor: Colors
                                  .amber
                                  .shade300, // Yellowish for coin icon
                              onPressed: shopData.increaseBet,
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),
                        // Bottom Status Bar (Credits, Bet, Settings, Info)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                          margin: const EdgeInsets.symmetric(
                            horizontal: 20,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.4),
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(
                              color: Colors.white24,
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              IconButton(
                                icon: const Icon(
                                  Icons.settings,
                                  color: Colors.white,
                                  size: 28,
                                ),
                                onPressed: () {
                                  showDialog<void>(
                                    context: context,
                                    builder: (BuildContext dialogContext) {
                                      return const SettingsDialog();
                                    },
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
                                icon: const Icon(
                                  Icons.info_outline,
                                  color: Colors.white,
                                  size: 28,
                                ),
                                onPressed: () {
                                  // Info action
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

// Extension to convert LinearGradient to BoxDecoration
extension on LinearGradient {
  BoxDecoration toBoxDecoration({BorderRadiusGeometry? borderRadius}) {
    return BoxDecoration(gradient: this, borderRadius: borderRadius);
  }
}

// Widget for a single game symbol tile, now displaying fruit name
class _GameSymbolTile extends StatelessWidget {
  final String fruitName;
  static const String _placeholderImageUrl =
      'https://www.gstatic.com/flutter-onestack-prototype/genui/example_1.jpg';

  const _GameSymbolTile({required this.fruitName});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(
          0.15,
        ), // Slight background for each tile
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
          width: 1,
        ), // Light border
      ),
      child: Stack(
        // Use Stack to layer image and text
        fit: StackFit.expand, // Make children expand to fill the container
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              _placeholderImageUrl, // Always use the fixed placeholder image
              fit: BoxFit.cover,
              errorBuilder:
                  (BuildContext context, Object error, StackTrace? stackTrace) {
                return const Center(
                  child: Icon(
                    Icons.broken_image,
                    color: Colors.grey,
                    size: 30,
                  ),
                );
              },
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(4.0), // Add some padding
              child: Text(
                fruitName.toUpperCase(), // Display fruit name prominently
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  shadows: <Shadow>[
                    Shadow(
                      offset: Offset(1.0, 1.0),
                      blurRadius: 2.0,
                      color: Colors.black,
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
                maxLines: 2, // Allow text to wrap if it's too long
                overflow:
                TextOverflow.ellipsis, // Add ellipsis if text overflows
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Widget for game control buttons (spin, bet)
class _GameControlButton extends StatelessWidget {
  final IconData icon; // Changed to IconData
  final Color backgroundColor; // Added for button background color
  final Color iconColor; // Added for icon color
  final VoidCallback onPressed;

  const _GameControlButton({
    required this.icon,
    required this.backgroundColor,
    required this.iconColor,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          shape: BoxShape
              .circle, // Sticking to circle shape as per previous implementation
          color: backgroundColor,
          border: Border.all(
            color: Colors.amber.shade200,
            width: 3,
          ), // Example border
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Center(child: Icon(icon, color: iconColor, size: 40)),
      ),
    );
  }
}

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
  double _currentWheelAngle = 0.0; // Current visual angle of the wheel
  bool _isSpinning = false;
  late final List<Map<String, dynamic>> _wheelSegments;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3), // Spin duration
    );

    // Initialize _wheelRotationAnimation to prevent LateInitializationError.
    // It will be re-assigned in _onSpin with the actual animation logic.
    _wheelRotationAnimation = Tween<double>(
      begin: _currentWheelAngle,
      end: _currentWheelAngle,
    ).animate(_animationController);

    _wheelSegments = <Map<String, dynamic>>[
      <String, dynamic>{
        'value': 0.5,
        'color': const Color(0xFF79CF5E),
      }, // Green
      <String, dynamic>{
        'value': 1.5,
        'color': const Color(0xFF9F59F5),
      }, // Purple
      <String, dynamic>{'value': 7.0, 'color': const Color(0xFF4AA4EE)}, // Blue
      <String, dynamic>{
        'value': 0.5,
        'color': const Color(0xFFF79447),
      }, // Orange
      <String, dynamic>{'value': 1.2, 'color': const Color(0xFF57DFD8)}, // Cyan
      <String, dynamic>{
        'value': 1.2,
        'color': const Color(0xFF46B368),
      }, // Dark Green
    ];

    // Initial angle of the wheel to align the purple x1.5 segment under the pointer
    // The painter draws segments starting from top (-90 degrees) clockwise.
    // Segment 0 (green) is -90 to -30 degrees.
    // Segment 1 (purple) is -30 to 30 degrees.
    // Its center is 0 degrees (top). So, initial angle 0 is correct for this setup.
    _currentWheelAngle = 0.0;
  }

  void _onSpin(ShopData shopData) async {
    if (_isSpinning || shopData.credits < shopData.bet) {
      return;
    }

    setState(() {
      _isSpinning = true;
    });

    // Deduct bet immediately
    shopData.spinGame(); // This method already deducts bet

    // Randomly select a target segment
    final int targetSegmentIndex = _random.nextInt(_wheelSegments.length);
    final double targetValue =
    _wheelSegments[targetSegmentIndex]['value'] as double;

    // Calculate the final angle: Spin multiple full rotations + land on target segment.
    // Each segment is 360 / number of segments degrees.
    // We want the *center* of the target segment to align with the pointer (which is at the top, 0 degrees).
    // The segment angles, if segment 0 is centered at 0 degrees, are:
    // Seg 0: -30 to 30 (center 0)
    // Seg 1: 30 to 90 (center 60)
    // Seg 2: 90 to 150 (center 120)
    // Seg 3: 150 to 210 (center 180)
    // Seg 4: 210 to 270 (center 240)
    // Seg 5: 270 to 330 (center 300)
    // So, target center angle for index `i` is `(i * 60)` degrees.
    // To land on this segment, the wheel must rotate such that its previous top-aligned segment
    // moves to `(i * 60)` degrees, meaning rotation of `-(i * 60)` degrees.
    // Add multiple full rotations (e.g., 5-10 full spins).
    const double baseRotations = 5; // Minimum full rotations
    final double targetCenterAngleDegrees =
    (targetSegmentIndex * (360.0 / _wheelSegments.length));
    final double totalRotationDegrees =
        (baseRotations + _random.nextDouble() * 5) * 360 +
            targetCenterAngleDegrees;

    // The animation starts from the current visual angle and goes to the new total angle.
    _wheelRotationAnimation =
        Tween<double>(
          begin: _currentWheelAngle,
          end: totalRotationDegrees * (pi / 180), // Convert to radians
        ).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeOutQuart, // Slow down towards the end
          ),
        );

    // Reset controller and start animation
    _animationController.reset();
    await _animationController.forward();

    // After animation completes, update credits
    shopData.winCredits((shopData.bet * targetValue).round());

    // Update the current visual angle to reflect the new stopped position.
    _currentWheelAngle = _wheelRotationAnimation.value % (2 * pi);

    setState(() {
      _isSpinning = false;
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
        children: <Widget>[
          // Background Image
          Positioned.fill(
            child: Image.network(
              'https://www.gstatic.com/flutter-onestack-prototype/genui/example_1.jpg',
              fit: BoxFit.cover,
            ),
          ),
          // Gradient Overlay to blend background with game area
          Positioned.fill(
            child: Container(
              decoration: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: <Color>[
                  Colors.blue.shade300.withOpacity(0.2), // Light blue top
                  Colors.blue.shade800.withOpacity(0.5), // Darker blue mid
                  Colors.deepPurple.shade900.withOpacity(
                    0.7,
                  ), // Deep purple bottom
                ],
                stops: const <double>[0.0, 0.5, 1.0],
              ).toBoxDecoration(),
            ),
          ),
          Column(
            children: <Widget>[
              // Top Bar (Status bar space + Close button)
              SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.only(right: 16.0, top: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      IconButton(
                        icon: const Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 30,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                ),
              ),
              // Sweet Billions Logo
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20.0),
                child: Text(
                  "SWEET BILLIONS",
                  style: TextStyle(
                    fontSize: 40,
                    color: Color(0xFFF06292), // Pink for SWEET
                    fontWeight: FontWeight.w900,
                    shadows: <Shadow>[
                      Shadow(
                        offset: Offset(4.0, 4.0),
                        blurRadius: 3.0,
                        color: Color(0xFF6A1B9A), // Purple for outline
                      ),
                      Shadow(
                        offset: Offset(-4.0, -4.0),
                        blurRadius: 3.0,
                        color: Color(0xFFFFCC80), // Yellow/orange highlight
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                child: Center(
                  child: AspectRatio(
                    aspectRatio: 1.0, // Make wheel square
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Stack(
                        alignment: Alignment.topCenter, // Align pointer to top
                        children: <Widget>[
                          // Fortune Wheel
                          AnimatedBuilder(
                            animation: _wheelRotationAnimation,
                            builder: (BuildContext context, Widget? child) {
                              // If animation is running, use its value. Otherwise, use current set angle.
                              final double currentRotation = _isSpinning
                                  ? _wheelRotationAnimation.value
                                  : _currentWheelAngle;
                              return Transform.rotate(
                                angle: currentRotation,
                                child: CustomPaint(
                                  painter: _FortuneWheelPainter(
                                    segments: _wheelSegments,
                                  ),
                                  size: Size.infinite,
                                ),
                              );
                            },
                          ),
                          // Pointer
                          Positioned(
                            top: -20, // Adjust position
                            child: Transform.translate(
                              offset: const Offset(
                                0,
                                0,
                              ), // Adjust to hover slightly above wheel
                              child: CustomPaint(
                                painter: _WheelPointerPainter(),
                                size: const Size(60, 60), // Size of the pointer
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              // Spin the Wheel text
              const Text(
                "SPIN THE WHEEL!",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  shadows: <Shadow>[
                    Shadow(
                      offset: Offset(1.0, 1.0),
                      blurRadius: 2.0,
                      color: Colors.black54,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // Bottom UI (Spin Button, Bet Button)
              Consumer<ShopData>(
                builder:
                    (BuildContext context, ShopData shopData, Widget? child) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16.0, top: 20.0),
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            _GameControlButton(
                              icon: Icons.refresh, // Spin icon
                              backgroundColor: const Color(
                                0xFFF79447,
                              ), // Orange for spin button
                              iconColor: Colors.white,
                              onPressed: () => _onSpin(shopData),
                            ),
                            const SizedBox(width: 20),
                            _GameControlButton(
                              icon: Icons.monetization_on, // Coins icon
                              backgroundColor: const Color(
                                0xFF79CF5E,
                              ), // Green for bet button
                              iconColor: Colors.white,
                              onPressed: shopData.increaseBet,
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),
                        // Bottom Status Bar (Credits, Bet, Settings, Info)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                          margin: const EdgeInsets.symmetric(
                            horizontal: 20,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.4),
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(
                              color: Colors.white24,
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              IconButton(
                                icon: const Icon(
                                  Icons.settings,
                                  color: Colors.white,
                                  size: 28,
                                ),
                                onPressed: () {
                                  showDialog<void>(
                                    context: context,
                                    builder: (BuildContext dialogContext) {
                                      return const SettingsDialog();
                                    },
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
                                  icon: const Icon(
                                    Icons.info_outline,
                                    color: Colors.white,
                                    size: 28,
                                  ),
                                  onPressed: () {
                                    // Info action
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const GameRulesScreen(),
                                      ),
                                    );
                                  }
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

class _FortuneWheelPainter extends CustomPainter {
  final List<Map<String, dynamic>> segments;

  _FortuneWheelPainter({required this.segments});

  @override
  void paint(Canvas canvas, Size size) {
    final double radius = min(size.width, size.height) / 2;
    final Offset center = Offset(size.width / 2, size.height / 2);

    // Draw central white circle (hub)
    final Paint hubPaint = Paint()..color = Colors.white;
    canvas.drawCircle(center, radius * 0.15, hubPaint); // Adjust hub size

    // Draw segments
    final double segmentAngleDegrees = 360 / segments.length; // Degrees
    // Start from top, clockwise.
    // So, segment 0 will be centered at 0 degrees (top), spanning from -30 to 30 degrees.
    double currentArcStartRad = (-segmentAngleDegrees / 2) * (pi / 180);
    final double sweepAngleRad = segmentAngleDegrees * (pi / 180);

    for (final Map<String, dynamic> segment in segments) {
      final Paint segmentPaint = Paint()..color = segment['color'] as Color;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        currentArcStartRad,
        sweepAngleRad,
        true, // Use center to fill pie shape
        segmentPaint,
      );

      // Draw text
      final String text = 'x${segment['value']}';
      final TextPainter textPainter = TextPainter(
        text: TextSpan(
          text: text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
            shadows: <Shadow>[
              Shadow(
                offset: Offset(1.0, 1.0),
                blurRadius: 2.0,
                color: Colors.black,
              ),
            ],
          ),
        ),
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();

      final double midAngleForText = currentArcStartRad + sweepAngleRad / 2;
      // Calculate position for the text to be slightly inside the segment.
      // 0.65 is the radial distance.
      final double textX = center.dx + radius * 0.65 * cos(midAngleForText);
      final double textY = center.dy + radius * 0.65 * sin(midAngleForText);

      canvas.save();
      canvas.translate(textX, textY);
      // Rotation angle for text: midAngleForText + pi/2 ensures it's upright and radial
      double rotationForText = midAngleForText + pi / 2;

      // Normalize angle to [0, 2pi) for consistent left/right half check
      double normalizedMidAngle = midAngleForText;
      while (normalizedMidAngle < 0) {
        normalizedMidAngle += 2 * pi;
      }
      normalizedMidAngle = normalizedMidAngle % (2 * pi);

      // If text is on the left half (angles from 90 to 270 degrees), flip it upside down
      if (normalizedMidAngle > pi / 2 && normalizedMidAngle < 3 * pi / 2) {
        rotationForText += pi;
      }

      canvas.rotate(rotationForText);
      textPainter.paint(
        canvas,
        Offset(-textPainter.width / 2, -textPainter.height / 2),
      );
      canvas.restore();

      currentArcStartRad += sweepAngleRad;
    }

    // Draw candy-cane border
    final double borderThickness = 20.0;
    final double candyCaneRadius =
        radius + (borderThickness / 2); // Center of the border stroke

    final Paint borderPaintRed = Paint()
      ..color = Colors.red.shade600
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderThickness;
    final Paint borderPaintWhite = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderThickness;

    const double stripeAngleDegrees = 15.0; // Each stripe is 15 degrees
    final double stripeAngleRadians = stripeAngleDegrees * (pi / 180);

    double currentBorderAngle =
        (-segmentAngleDegrees / 2) * (pi / 180); // Align with segments
    for (int i = 0; i < 360 / stripeAngleDegrees; i++) {
      final Paint currentPaint = (i % 2 == 0)
          ? borderPaintRed
          : borderPaintWhite;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: candyCaneRadius),
        currentBorderAngle,
        stripeAngleRadians,
        false, // Do not use center for stroke
        currentPaint,
      );
      currentBorderAngle += stripeAngleRadians;
    }

    // Draw yellow dots on the border
    final Paint dotPaint = Paint()..color = Colors.amber.shade300;
    const double dotRadius = 5.0;
    final double dotPlacementRadius =
        radius + borderThickness; // Outer edge of the border
    const int totalDots = 24; // Evenly spaced dots around the wheel

    for (int i = 0; i < totalDots; i++) {
      final double dotAngleDegrees =
          (i * (360.0 / totalDots)) - 90.0; // Start at top, clockwise
      final double dotAngleRadians = dotAngleDegrees * (pi / 180);
      final double dotX = center.dx + dotPlacementRadius * cos(dotAngleRadians);
      final double dotY = center.dy + dotPlacementRadius * sin(dotAngleRadians);
      canvas.drawCircle(Offset(dotX, dotY), dotRadius, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _FortuneWheelPainter oldDelegate) {
    return false; // Segments are static, no need to repaint
  }
}

// Custom painter for the diamond-shaped pointer
class _WheelPointerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color =
      const Color(0xFFE91E63) // Pink color
      ..style = PaintingStyle.fill;

    final Path path = Path();
    path.moveTo(size.width / 2, 0); // Top point
    path.lineTo(size.width, size.height / 2); // Right point
    path.lineTo(size.width / 2, size.height); // Bottom point
    path.lineTo(0, size.height / 2); // Left point
    path.close();

    // Add a stroke for the outline
    final Paint strokePaint = Paint()
      ..color = Colors
          .white // White outline
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    canvas.drawPath(path, paint);
    canvas.drawPath(path, strokePaint); // Draw stroke on top
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false; // Painter's drawing is static
  }
}

class SettingsDialog extends StatelessWidget {
  const SettingsDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent, // Important for the blur effect
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          // Blurred background
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.8, // Adjust width
                height: MediaQuery.of(context).size.height * 0.6, // Adjust height
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Consumer<ShopData>(
                  builder: (BuildContext context, ShopData shopData, Widget? child) {
                    return Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          // Header: Settings title and close button
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              const Text(
                                "SETTINGS",
                                style: TextStyle(
                                  fontSize: 24,
                                  color: Colors.cyanAccent,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.close, color: Colors.white, size: 30),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          // Ambient Music toggle
                          _SettingRow(
                            label: "AMBIENT MUSIC",
                            control: Switch(
                              value: shopData.ambientMusicOn,
                              onChanged: (bool value) {
                                shopData.toggleAmbientMusic();
                              },
                              activeColor: Colors.orange.shade700,
                            ),
                          ),
                          const SizedBox(height: 10),
                          // Sound FX toggle
                          _SettingRow(
                            label: "SOUND FX",
                            control: Switch(
                              value: shopData.soundFxOn,
                              onChanged: (bool value) {
                                shopData.toggleSoundFx();
                              },
                              activeColor: Colors.orange.shade700,
                            ),
                          ),
                          const SizedBox(height: 10),
                          // Language dropdown
                          _SettingRow(
                            label: "LANGUAGE",
                            control: DropdownButton<String>(
                              value: shopData.selectedLanguage,
                              dropdownColor: Colors.black.withOpacity(0.8),
                              icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                              underline: Container(
                                height: 1,
                                color: Colors.white,
                              ),
                              onChanged: (String? newValue) {
                                shopData.setLanguage(newValue);
                              },
                              items: shopData.availableLanguages
                                  .map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                          const SizedBox(height: 30),
                          // Privacy Policy
                          _SettingsLink(
                            text: "PRIVACY POLICY",
                            onTap: () {
                              // In a real app, this would navigate to a Privacy Policy page.
                              // For this example, we just close the dialog.
                              Navigator.of(context).pop();
                            },
                          ),
                          const SizedBox(height: 15),
                          // Support
                          _SettingsLink(
                            text: "SUPPORT",
                            onTap: () {
                              // In a real app, this would navigate to a Support page.
                              // For this example, we just close the dialog.
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      ),
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

// Helper widget for setting rows (label + control)
class _SettingRow extends StatelessWidget {
  final String label;
  final Widget control;

  const _SettingRow({required this.label, required this.control});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          label,
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
        control,
      ],
    );
  }
}

// Helper widget for clickable links within settings
class _SettingsLink extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const _SettingsLink({required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.cyanAccent,
          fontSize: 18,
          fontWeight: FontWeight.bold,
          decoration: TextDecoration.underline,
          decorationColor: Colors.cyanAccent,
        ),
      ),
    );
  }
}

class GameRulesScreen extends StatelessWidget {
  const GameRulesScreen({super.key});

  static const String _placeholderImageUrl = 'https://www.gstatic.com/flutter-onestack-prototype/genui/example_1.jpg';

  final List<SymbolData> symbols = const [
    SymbolData(_placeholderImageUrl, '7: x0.5\n8-10: x1.2\n11+: x1.4'),
    SymbolData(_placeholderImageUrl, '7: x0.5\n8-10: x1.2\n11+: x1.4'),
    SymbolData(_placeholderImageUrl, '7: x0.5\n8-10: x1.2\n11+: x1.4'),
    SymbolData(_placeholderImageUrl, '7: x0.7\n8-10: x1.3\n11+: x1.5'),
    SymbolData(_placeholderImageUrl, '7: x0.7\n8-10: x1.3\n11+: x1.5'),
    SymbolData(_placeholderImageUrl, '7: x0.7\n8-10: x1.3\n11+: x1.5'),
    SymbolData(_placeholderImageUrl, '7: x1.0\n8-10: x1.4\n11+: x1.8'),
    SymbolData(_placeholderImageUrl, '7: x1.0\n8-10: x1.4\n11+: x1.8'),
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
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  )
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
                        Image.network(symbol.imagePath, height: 60),
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
              const SizedBox(height: 12),
              Image.network(_placeholderImageUrl, height: 60),
              const SizedBox(height: 12),
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
