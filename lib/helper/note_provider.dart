import 'package:awesome_note/utils/constants.dart';
import 'package:flutter/material.dart';
import '../models/note.dart';
import 'database_helper.dart';

class NoteProvider with ChangeNotifier {
  List _notesList = [];

  List get notesList {
    return _notesList;
  }

  Note getNote(int id) {
    return _notesList.firstWhere((note) => note.id == id, orElse: () => null);
  }

  Future getNotes() async {
    final notesList = await DatabaseHelper.getNotesFromDB();
    // final _notesList = await
    _notesList = notesList
        .map(
          (item) => Note(
              item['id'], item['title'], item['content'], item['imagePath']),
        )
        .toList();

    notifyListeners();
  }

  Future addOrUpdateNote(int id, String title, String content, String imagePath,
      EditMode editMode) async {
    final note = Note(id, title, content, imagePath);

    // create
    if (EditMode.ADD == editMode) {
      _notesList.insert(0, note);
    }
    // update
    else {
      _notesList[_notesList.indexWhere((note) => note.id == id)] = note;
    }

    notifyListeners();

    DatabaseHelper.insert({
      'id': note.id,
      'title': note.title,
      'content': note.content,
      'imagePath': note.imagePath,
    });
  }

  Future deleteNote(int id) {
    _notesList.removeWhere((element) => element.id == id);
    notifyListeners();
    return DatabaseHelper.delete(id);
  }
}
