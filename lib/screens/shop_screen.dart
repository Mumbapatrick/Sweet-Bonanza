// lib/screens/shop_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/game_model.dart';

class ShopScreen extends StatelessWidget {
  const ShopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // ✅ Background image
          Positioned.fill(
            child: Image.asset(
              'assets/images/backgrounds/steam.webp',
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: Container(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.8),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Consumer<ShopData>(
                builder: (context, shopData, child) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
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
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 12,
                            crossAxisSpacing: 12,
                            childAspectRatio: 0.75,
                          ),
                          itemBuilder: (context, index) {
                            final item = shopData.items[index];
                            final bool owned = item['owned'] as bool;
                            final bool selected = (item['selected'] as bool?) ?? false;

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
                                children: [
                                  Expanded(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.network(
                                        item['image'],
                                        fit: BoxFit.cover,
                                        color: owned ? null : Colors.black.withOpacity(0.5),
                                        colorBlendMode:
                                        owned ? null : BlendMode.darken,
                                        errorBuilder: (context, error, stackTrace) => const Center(
                                          child: Icon(
                                            Icons.broken_image,
                                            color: Colors.grey,
                                            size: 48,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                                    child: Text(
                                      item['name'],
                                      style: const TextStyle(color: Colors.white),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 8.0),
                                    child: owned
                                        ? ElevatedButton(
                                      onPressed: () => shopData.selectItem(index),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                        selected ? Colors.black54 : Colors.green,
                                      ),
                                      child: Text(
                                        selected ? 'SELECTED' : 'SELECT',
                                        style: const TextStyle(color: Colors.white),
                                      ),
                                    )
                                        : ElevatedButton(
                                      onPressed: () => shopData.buyItem(index),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.amber[800],
                                      ),
                                      child: Text(
                                        'BUY: ${item['price']}',
                                        style: const TextStyle(color: Colors.white),
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
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }
}
