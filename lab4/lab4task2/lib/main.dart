import 'package:flutter/material.dart';

void main() {
  runApp(const NotesApp());
}

class Note {
  final String text;
  bool isFavorite;

  Note({
    required this.text,
    this.isFavorite = false,
  });
}

class NotesApp extends StatelessWidget {
  const NotesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Notes App',
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  final List<Note> _notes = [];

  @override
  Widget build(BuildContext context) {
    final pages = [
      NotesPage(
        notes: _notes,
        onChanged: () => setState(() {}), 
      ),
      FavoritesPage(notes: _notes),
      const SettingsPage(),
    ];

    return Scaffold(
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.note), label: 'Notes'),
          BottomNavigationBarItem(icon: Icon(Icons.star), label: 'Favorites'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}


class NotesPage extends StatefulWidget {
  final List<Note> notes;
  final VoidCallback onChanged;

  const NotesPage({
    super.key,
    required this.notes,
    required this.onChanged,
  });

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  final TextEditingController _controller = TextEditingController();

  void _addNote() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    setState(() {
      widget.notes.insert(0, Note(text: text));
    });
    _controller.clear();
    widget.onChanged();
  }

  void _deleteNote(int index) {
    setState(() {
      widget.notes.removeAt(index);
    });
    widget.onChanged();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notes')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Write a note...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _addNote,
                  child: const Text('Add'),
                ),
              ],
            ),
          ),
          Expanded(
            child: widget.notes.isEmpty
                ? const Center(child: Text('No notes yet.'))
                : ListView.builder(
                    itemCount: widget.notes.length,
                    itemBuilder: (context, index) {
                      final note = widget.notes[index];
                      return ListTile(
                        title: Text(note.text),
                        leading: IconButton(
                          icon: Icon(
                            note.isFavorite
                                ? Icons.star
                                : Icons.star_border,
                            color: note.isFavorite ? Colors.amber : null,
                          ),
                          onPressed: () {
                            setState(() {
                              note.isFavorite = !note.isFavorite;
                            });
                            widget.onChanged();
                          },
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => _deleteNote(index),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class FavoritesPage extends StatelessWidget {
  final List<Note> notes;
  const FavoritesPage({super.key, required this.notes});

  @override
  Widget build(BuildContext context) {
    final favs = notes.where((n) => n.isFavorite).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Favorites')),
      body: favs.isEmpty
          ? const Center(child: Text('No favorites yet.'))
          : ListView.builder(
              itemCount: favs.length,
              itemBuilder: (context, i) {
                final note = favs[i];
                return ListTile(
                  title: Text(note.text),
                  leading: const Icon(Icons.star, color: Colors.amber),
                );
              },
            ),
    );
  }
}

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(title: Text('Settings')),
      body: Center(child: Text('⚙️ Settings Page')),
    );
  }
}
