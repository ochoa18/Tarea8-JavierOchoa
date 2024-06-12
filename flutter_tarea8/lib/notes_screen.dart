import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'note.dart';
import 'notes_provider.dart';
import 'note_form.dart';

class NotesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final notesProvider = Provider.of<NotesProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Notes App'),
      ),
      body: FutureBuilder(
        future: notesProvider.fetchNotes(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          return ListView.builder(
            itemCount: notesProvider.notes.length,
            itemBuilder: (ctx, i) {
              Note note = notesProvider.notes[i];
              return ListTile(
                title: Text(note.description),
                subtitle: Text(note.date.toString()),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => notesProvider.deleteNote(note.id),
                ),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (ctx) => NoteForm(note: note),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (ctx) => NoteForm(),
            ),
          );
        },
      ),
    );
  }
}
