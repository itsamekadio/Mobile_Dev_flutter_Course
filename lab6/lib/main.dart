import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/cart_provider.dart';
import 'screens/cart_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => CartProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lab 6 Cart',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const CartScreen(),
    );
  }
}
/*CartProvider extends ChangeNotifier - This is the brain that holds the cart data and can announce when things change.


main.dart wraps the app with ChangeNotifierProvider - This makes CartProvider available to the entire app so any widget can access it.


CartScreen uses context.watch() - This tells the screen to listen for announcements from CartProvider and rebuild when it changes.


When CartProvider calls notifyListeners() - All widgets watching it (like CartScreen) automatically rebuild with the new data.*/