import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'model/game_model.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ShopData(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Sweet Billions',
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: Colors.transparent,
          textTheme: const TextTheme(
            bodyMedium: TextStyle(color: Colors.white),
          ),
        ),
        home: const SplashScreen(), // Start with splash
      ),
    );
  }
}

