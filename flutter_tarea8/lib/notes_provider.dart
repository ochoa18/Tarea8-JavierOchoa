import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'note.dart';

class NotesProvider with ChangeNotifier {
  final CollectionReference _notesCollection =
      FirebaseFirestore.instance.collection('notes');

  List<Note> _notes = [];

  List<Note> get notes => _notes;

  Future<void> fetchNotes() async {
    try {
      QuerySnapshot querySnapshot = await _notesCollection.get();
      _notes = querySnapshot.docs
          .map(
              (doc) => Note.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<void> addNote(Note note) async {
    try {
      await _notesCollection.add(note.toMap());
      await fetchNotes();
    } catch (e) {
      print(e);
    }
  }

  Future<void> updateNote(Note note) async {
    try {
      await _notesCollection.doc(note.id).update(note.toMap());
      await fetchNotes();
    } catch (e) {
      print(e);
    }
  }

  Future<void> deleteNote(String id) async {
    try {
      await _notesCollection.doc(id).delete();
      await fetchNotes();
    } catch (e) {
      print(e);
    }
  }
}
