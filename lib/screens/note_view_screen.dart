import 'dart:io';
import 'package:awesome_note/helper/note_provider.dart';
import 'package:awesome_note/models/note.dart';
import 'package:awesome_note/utils/constants.dart';
import 'package:awesome_note/widgets/delete_popup.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'note_edit_screen.dart';

class NoteViewScreen extends StatefulWidget {
  static const route = '/view-note';

  @override
  _NoteViewScreenState createState() => _NoteViewScreenState();
}

class _NoteViewScreenState extends State<NoteViewScreen> {

  @override
  initState(){
    super.initState();
    print("## NoteViewScreen.initState()");
  }

  @override
  didChangeDependencies(){
    super.didChangeDependencies();
    print("## NoteViewScreen.didChangeDependencies()");
  }


  Note noteBeingEdited;

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //
  //   final int id = ModalRoute.of(context).settings.arguments;
  //
  //   if (Provider.of<NoteProvider>(context).getNote(id) != null){
  //     noteBeingEdited = Provider.of<NoteProvider>(context).getNote(id);
  //   }
  // }

  @override
  Widget build(BuildContext inContext) {
    print("## NoteViewScreen.build()");
    final int id = ModalRoute.of(inContext).settings.arguments;
    print("## current note's id: $id");

    if (Provider.of<NoteProvider>(inContext).getNote(id) != null){
      noteBeingEdited = Provider.of<NoteProvider>(inContext, listen: false).getNote(id);
    }
    // this.context == inContext?
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.7,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(inContext);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.delete,
              color: Colors.black,
            ),
            onPressed: () => _showDialog(inContext),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                noteBeingEdited?.title,
                style: viewTitleStyle,
              ),
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.access_time,
                    size: 18,
                  ),
                ),
                Text('${noteBeingEdited?.date}')
              ],
            ),
            if (noteBeingEdited?.imagePath != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child:
                    Image.file(File(noteBeingEdited.imagePath)),
              ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                noteBeingEdited?.content,
                style: viewContentStyle,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(inContext, NoteEditScreen.route,
              arguments: noteBeingEdited?.id);
        },
        child: Icon(Icons.edit),
      ),
    );
  }

  void _showDialog(BuildContext inContext) {
    // NoteProvider noteProvider =
    //     Provider.of<NoteProvider>(inContext, listen: false);

    showDialog(
      context: inContext,
      builder: (context) {
        return DeletePopUp(selectedNote: noteBeingEdited,);
      },
    );
  }
}
