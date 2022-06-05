import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_application_1/database/notes_db.dart';
import 'package:flutter_application_1/models/note.dart';
import 'package:flutter_application_1/widgets/note_card_widget.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'AddEditNotesPage.dart';
import 'NotesDetailsPage.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({Key? key}) : super(key: key);

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  late List<Note> notes;
  // cause fetching data may take some time
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
// everytime screen is loading its calling this fn
    refreshNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Notes',
          style: TextStyle(fontSize: 24),
        ),
      ),

      body: Center(
        child: isLoading ? const CircularProgressIndicator() : notes.isEmpty ? const Text('No Notes Added Yet', style: TextStyle(color: Colors.white, fontSize: 24),
        ) : buildNotes(),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed:  () async {
          await Navigator.of(context).push(MaterialPageRoute(builder: ((context) => const AddEditNotePage()
          ),)
          );
          refreshNotes();
        } ,
        child: const Icon(Icons.add),
        ),
    );
  }

  Future refreshNotes() async {
    setState(() {
      isLoading = true;
    });
    notes = await NotesDatabase.instance.readAllNotes();
    setState(() {
      isLoading = false;
    });
  }

  @override
  void dispose() {
    NotesDatabase.instance.close();
    super.dispose();
  }
  
  Widget buildNotes() => MasonryGridView.count(
    itemCount: notes.length,
    crossAxisCount: 2, 
    itemBuilder: (context, index){
      final note =notes[index];
      return GestureDetector(
        onTap: () async {
          await Navigator.of(context).push(MaterialPageRoute(builder: ((context) => NotesDetailsPage(noteId:note.id!)
          )
          )
          );
          refreshNotes();
        },
        child: NoteCardWidget(index: index, note: note),
      );
    },
    );
}
