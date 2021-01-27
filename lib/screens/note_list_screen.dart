import 'package:awesome_note/helper/database_helper.dart';
import 'package:awesome_note/helper/note_provider.dart';
import 'package:awesome_note/models/note.dart';
import 'package:awesome_note/screens/note_edit_screen.dart';
import 'package:awesome_note/widgets/list_item.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../utils/constants.dart';

// 총 edit 으로 넘어가는 것 2개
// 총 view 으로 넘어가는 것 1개

class NoteListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext inContext) {
    return FutureBuilder(
      future: Provider.of<NoteProvider>(inContext, listen: false).getNotes(),
      builder: (inFutureContext, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (snapshot.connectionState == ConnectionState.done) {
          return Scaffold(
            body: Consumer<NoteProvider>(
              builder: (inContext, noteProvider, inChild) {
                return noteProvider.notesList.length <= 0
                  ? noNoteList(inFutureContext)
                  : ListView.builder(
                      itemCount: noteProvider.notesList.length + 1,
                      itemBuilder: (inBuilderContext, inIndex) {
                        if (inIndex == 0) {
                          return header();
                        } else {
                          final i = inIndex - 1;
                          Note note = noteProvider.notesList[i];
                          return ListItem(
                            id: note.id,
                            title: note.title,
                            content: note.content,
                            imagePath: note.imagePath,
                            date: note.date,
                          );
                        }
                      },
                    );
              },
            ),
            floatingActionButton: FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () {
                Navigator.of(inContext).pushNamed(NoteEditScreen.route);
              },
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }

  Widget noNoteList(BuildContext inContext) {
    return ListView(
      children: [
        header(),
        Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 50.0),
                child: Image.asset(
                  'assets/crying_emoji.jpg',
                  fit: BoxFit.cover,
                  width: 200,
                  height: 200,
                ),
              ),
              RichText(
                text: TextSpan(
                  style: noNotesStyle,
                  children: [
                    TextSpan(text: ' There is no note available\nTap on "'),
                    TextSpan(
                      text: '+',
                      style: boldPlus,
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          // Navigator.push(
                          //     inContext,
                          //     MaterialPageRoute(
                          //         builder: (inContext) => NoteEditScreen()));
                          ///  *** ///
                          // Provider.of<NoteProvider>(inContext, listen: false)
                          //     .entityBeingEdited = Note();
                          Navigator.of(inContext)
                              .pushNamed(NoteEditScreen.route);
                        },
                    ),
                    TextSpan(text: '" to add new note'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget header() {
    return GestureDetector(
      onTap: _launchUrl,
      child: Container(
        decoration: BoxDecoration(
          color: headerColor,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(75.0),
            bottomRight: Radius.circular(75.0),
          ),
        ),
        height: 150,
        // full width of screen
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Dongho's",
              style: headerRideStyle,
            ),
            Text(
              "Notes",
              style: headerNotesStyle,
            )
          ],
        ),
      ),
    );
  }

  void _launchUrl() async {
    const url = 'http://www.naver.com';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw "Could not launch $url";
    }
  }
}
