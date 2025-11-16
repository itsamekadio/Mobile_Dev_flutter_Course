// --- File: lib/screens/note_editor_screen.dart ---
import 'package:flutter/material.dart';
import '../models/note.dart'; // Import the Note model
// Note: StorageService is NOT directly used here. Saving is handled by MainScreen.

class NoteEditorScreen extends StatefulWidget {
  // The 'note' parameter is optional. If provided, we are editing an existing note.
  // If null, we are creating a new note.
  final Note? note;

  const NoteEditorScreen({Key? key, this.note}) : super(key: key);

  @override
  State<NoteEditorScreen> createState() => _NoteEditorScreenState();
}

class _NoteEditorScreenState extends State<NoteEditorScreen> {
  late TextEditingController _titleController;
  late TextEditingController _bodyController;

  @override
  void initState() {
    super.initState();
    
    _titleController = TextEditingController(text: widget.note?.title ?? '');
    _bodyController = TextEditingController(text: widget.note?.body ?? '');
  }


  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  void _saveNote() {
    final title = _titleController.text.trim();
    final body = _bodyController.text.trim();

    if (title.isEmpty && body.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Note is empty!')),
      );
      return;
    }

    Note noteToReturn;
    if (widget.note != null) {
      
      noteToReturn = Note(
        id: widget.note!.id, 
        title: title,
        body: body,
        createdAt: widget.note!.createdAt, 
      );
    } else {
     
      final now = DateTime.now().millisecondsSinceEpoch;
      noteToReturn = Note(
        id: now, 
        title: title,
        body: body,
        createdAt: now, 
      );
    }

    Navigator.pop(context, noteToReturn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.note == null ? 'New Note' : 'Edit Note'), 
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveNote, 
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                hintText: 'Title', 
                border: InputBorder.none, 
              ),
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              autofocus: true, 
            ),
            const Divider(height: 1.0),
            const SizedBox(height: 8),
            Expanded( 
              child: TextField(
                controller: _bodyController,
                decoration: const InputDecoration(
                  hintText: 'Enter your note here...',
                  border: InputBorder.none, 
                ),
                maxLines: null, 
                keyboardType: TextInputType.multiline, 
              ),
            ),
          ],
        ),
      ),
    );
  }
}