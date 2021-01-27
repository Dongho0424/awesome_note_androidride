import 'package:awesome_note/helper/database_helper.dart';
import 'package:flutter/material.dart';
import '../helper/note_provider.dart';
import '../models/note.dart';
import 'package:provider/provider.dart';

class DeletePopUp extends StatelessWidget {

  final Note selectedNote;

  DeletePopUp({Key key, @required this.selectedNote}) : super(key: key);

  @override
  Widget build(BuildContext inContext) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      title: Text('Delete?'),
      content: Text('Do you want to delete the note?'),
      actions: [
        FlatButton(
          child: Text('Yes'),
          onPressed: () {
            Provider.of<NoteProvider>(inContext, listen: false)
                .deleteNote(selectedNote.id);
            Navigator.popUntil(inContext, ModalRoute.withName('/'));

            Scaffold.of(inContext).showSnackBar(
              SnackBar(
                backgroundColor: Colors.redAccent,
                duration: Duration(seconds: 2),
                content: Text("Note deleted!"),
              ),
            );
          },
        ),
        FlatButton(
          child: Text('No'),
          onPressed: () {
            Navigator.pop(inContext);
          },
        )
      ],
    );
  }
}
