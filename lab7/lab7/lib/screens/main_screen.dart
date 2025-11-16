import 'package:flutter/material.dart';
import '../models/note.dart'; 
import '../services/StorageService.dart';
import 'note_editor_screen.dart';

class MainScreen extends StatefulWidget {
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<Note> _notes = [];

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    final loadedNotes = await StorageService.getNotes();
    setState(() {
      _notes = loadedNotes;
    });
  }

  
  Future<void> _openEditor({Note? noteToEdit}) async {
    
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NoteEditorScreen(note: noteToEdit),
      ),
    );

  
    if (result != null && result is Note) {
     
      final existingNoteIndex = _notes.indexWhere((note) => note.id == result.id);

      if (existingNoteIndex != -1) {
        await StorageService.updateNote(result);
      } else {
        await StorageService.addNote(result);
      }
      
      _loadNotes();
    }
  }

  Future<void> _deleteNote(int id) async {
    await StorageService.deleteNote(id);
    _loadNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Journal'),
      ),
      body: _notes.isEmpty
          ? const Center(child: Text('No notes yet. Tap + to add one!'))
          : ListView.builder(
              itemCount: _notes.length, 
              itemBuilder: (context, index) {
                final note = _notes[index];
                return ListTile(
                  title: Text(note.title), 
                  subtitle: Text(
                    note.body.length > 50 ? note.body.substring(0, 50) + '...' : note.body,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  onTap: () => _openEditor(noteToEdit: note),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                    onPressed: () => _deleteNote(note.id), 
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openEditor(), 
        tooltip: 'Add New Note', 
        child: const Icon(Icons.add),
      ),
    );
  }
}