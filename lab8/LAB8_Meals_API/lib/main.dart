import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/meals_provider.dart';
import 'ui/meals_page.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => MealsProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Meals Search App',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        useMaterial3: true,
      ),
      home: MealsPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
