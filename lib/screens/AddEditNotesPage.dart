import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/note.dart';
import 'package:flutter_application_1/widgets/note_form_widget.dart';

import '../database/notes_db.dart';

class AddEditNotePage extends StatefulWidget {
  final Note? note;
  const AddEditNotePage({Key? key, this.note}) : super(key: key);

  @override
  State<AddEditNotePage> createState() => _AddEditNotePageState();
}

class _AddEditNotePageState extends State<AddEditNotePage> {
  final _formKey = GlobalKey<FormState>();

  late String title;
  late String description;
  late bool isImportant;
  late int priorityLevel;

// if data is not there in db, then shows the default value
  @override
  void initState() {
    super.initState();
    title = widget.note?.title ?? '';
    description = widget.note?.description ?? '';
    isImportant = widget.note?.isImportant ?? false;
    priorityLevel = widget.note?.priorityLevel ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [saveButton()],
      ),
      body: Form(
        key: _formKey,
        child: NoteFormWidget(
          title: title,
          description: description,
          priorityLevel: priorityLevel,
          isImportant: isImportant,
          onChangeIsImportant: (isImportant) => setState(
            (() => this.isImportant = isImportant),
          ),
          onChangeDescription: (description) => setState(
            (() => this.description = description),
          ),
          onChangeTitle: (title) => setState(
            (() => this.title = title),
          ),
          onChangePriorityLevel: (priorityLevel) => setState(
            (() => this.priorityLevel = priorityLevel),
          ),
        ),
      ),
    );
  }

  Widget saveButton() {
    final isFormValid = title.isNotEmpty && description.isNotEmpty;
    return ElevatedButton(
        onPressed: () => AddOrUpdateNotes(),
        child: Icon(
          Icons.save,
          color: isFormValid ? Colors.white : Colors.grey.shade900,
        ));
  }

  // ignore: non_constant_identifier_names
  void AddOrUpdateNotes() async {
    final isValid = _formKey.currentState!.validate();
    if (isValid) {
      final isUpdating = widget.note != null;
      if (isUpdating) {
        await updateNote();
      } else {
        await addNote();
      }
    }
    Navigator.of(context).pop();
  }

  Future updateNote() async {
    final note = widget.note!.copy(
        title: title,
        description: description,
        isImportant: isImportant,
        priorityLevel: priorityLevel);
    await NotesDatabase.instance.update(note);
  }

  Future addNote() async {
    final note = Note(
        title: title,
        description: description,
        isImportant: isImportant,
        priorityLevel: priorityLevel,
        createdTime: DateTime.now());
    await NotesDatabase.instance.create(note);
  }
}
