import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'note.dart';
import 'notes_provider.dart';

class NoteForm extends StatefulWidget {
  final Note? note;

  NoteForm({this.note});

  @override
  _NoteFormState createState() => _NoteFormState();
}

class _NoteFormState extends State<NoteForm> {
  final _formKey = GlobalKey<FormState>();
  late String _description;
  late DateTime _date;
  late String _status;
  late bool _important;

  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      _description = widget.note!.description;
      _date = widget.note!.date;
      _status = widget.note!.status;
      _important = widget.note!.important;
    } else {
      _description = '';
      _date = DateTime.now();
      _status = 'creado';
      _important = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final notesProvider = Provider.of<NotesProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.note == null ? 'Add Note' : 'Edit Note'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                initialValue: _description,
                decoration: InputDecoration(labelText: 'Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
                onSaved: (value) {
                  _description = value!;
                },
              ),
              DropdownButtonFormField(
                value: _status,
                items: ['creado', 'por hacer', 'trabajando', 'finalizado']
                    .map((label) => DropdownMenuItem(
                          child: Text(label),
                          value: label,
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _status = value as String;
                  });
                },
              ),
              SwitchListTile(
                title: Text('Important'),
                value: _important,
                onChanged: (value) {
                  setState(() {
                    _important = value;
                  });
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                child: Text(widget.note == null ? 'Add' : 'Update'),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    Note newNote = Note(
                      id: widget.note?.id ?? '',
                      description: _description,
                      date: _date,
                      status: _status,
                      important: _important,
                    );

                    if (widget.note == null) {
                      notesProvider.addNote(newNote);
                    } else {
                      notesProvider.updateNote(newNote);
                    }
                    Navigator.of(context).pop();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
