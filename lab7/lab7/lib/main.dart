import 'package:flutter/material.dart';
import 'screens/main_screen.dart'; // We will create this screen next.

void main() {
  // Ensure Flutter bindings are initialized before running the app.
  // This is often needed if you're using plugins that require native code.
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Journal App',
      theme: ThemeData(
        primarySwatch: Colors.blue, // Basic theming.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // The home property defines the first screen shown when the app starts.
      home: MainScreen(), // This will be our main screen for displaying notes.
    );
  }
}