import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/note.dart'; 

class StorageService {
  static const String _notesDataKey = 'my_journal_notes_list';

  static Map<String, dynamic> _noteToMap(Note note) {
    return {
      'id': note.id,
      'title': note.title,
      'body': note.body,
      'createdAt': note.createdAt,
    };
  }

  static Note _noteFromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'] as int,
      title: map['title'] as String,
      body: map['body'] as String,
      createdAt: map['createdAt'] as int,
    );
  }

  static Future<void> _saveAllNotes(List<Note> notesToSave) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(notesToSave.map((note) => _noteToMap(note)).toList());
    await prefs.setString(_notesDataKey, jsonString);
  }

  static Future<void> addNote(Note noteToAdd) async {
    final currentNotes = await getNotes();
    currentNotes.add(noteToAdd);             
    await _saveAllNotes(currentNotes);      
  }

  static Future<List<Note>> getNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_notesDataKey);

    if (jsonString == null || jsonString.isEmpty) {
      return []; 
    }

    try {
      final List<dynamic> decodedList = jsonDecode(jsonString);
      return decodedList.map((item) => _noteFromMap(item as Map<String, dynamic>)).toList();
    } catch (e) {
      print("Error loading notes: $e");
      return []; 
    }
  }

 
  static Future<void> updateNote(Note updatedNote) async {
    final currentNotes = await getNotes(); 
    
    final noteIndex = currentNotes.indexWhere((note) => note.id == updatedNote.id);

    if (noteIndex != -1) {
      currentNotes[noteIndex] = updatedNote; 
      await _saveAllNotes(currentNotes);     
    } else {
      print("Note with ID ${updatedNote.id} not found for update.");
    }
  }

  static Future<void> deleteNote(int idToDelete) async {
    final currentNotes = await getNotes();
    
    currentNotes.removeWhere((note) => note.id == idToDelete);
    await _saveAllNotes(currentNotes);     
  }
}