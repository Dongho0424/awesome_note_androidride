import 'dart:io';
import 'package:awesome_note/helper/note_provider.dart';
import 'package:awesome_note/screens/note_edit_screen.dart';
import 'package:awesome_note/screens/note_list_screen.dart';
import 'package:awesome_note/screens/note_view_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';
import 'helper/database_helper.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print("## main.build()");

    return ChangeNotifierProvider.value(
      value: NoteProvider(),
      child: MaterialApp(
        title: "Awesome Flutter Note",
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/' : (context) => NoteListScreen(),
          NoteViewScreen.route: (context) => NoteViewScreen(),
          NoteEditScreen.route: (context) => NoteEditScreen(),
        },
      )
    );
  }
}
