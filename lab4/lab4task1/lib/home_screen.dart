import 'package:flutter/material.dart';
import 'details_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  final List<Map<String, String>> newsList = const [
    {
      'title': 'Flutter 4.0 Released!',
      'content': 'Flutter 4 brings improved performance and new features...'
    },
    {
      'title': 'AI in Mobile Apps',
      'content': 'AI integration in mobile apps is shaping future trends...'
    },
    {
      'title': 'Dark Mode Everywhere',
      'content': 'Developers are embracing dark mode for better UX...'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('News Reader')),
      body: ListView.builder(
        itemCount: newsList.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(newsList[index]['title']!),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailsScreen(
                    title: newsList[index]['title']!,
                    content: newsList[index]['content']!,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
