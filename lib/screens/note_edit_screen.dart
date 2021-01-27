import 'dart:io';
import 'package:awesome_note/helper/database_helper.dart';
import 'package:awesome_note/models/note.dart';
import 'package:awesome_note/widgets/delete_popup.dart';
import 'package:flutter/material.dart';
import '../helper/note_provider.dart';
import 'package:image_picker/image_picker.dart';
import '../utils/constants.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'note_view_screen.dart';

class NoteEditScreen extends StatefulWidget {
  static const route = '/edit-note';

  @override
  _NoteEditScreenState createState() => _NoteEditScreenState();
}

class _NoteEditScreenState extends State<NoteEditScreen> {
  final titleController = TextEditingController();
  final contentController = TextEditingController();
  File _image;
  final picker = ImagePicker();

  bool firstTime;
  Note noteBeingEdited;
  int id;

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //
  //   if (ModalRoute.of(this.context).settings.arguments != null) {
  //     firstTime = false;
  //
  //     if (!firstTime) {
  //       id = ModalRoute.of(this.context).settings.arguments;
  //       noteBeingEdited = Provider.of<NoteProvider>(
  //         this.context,
  //         listen: false,
  //       ).getNote(id);
  //
  //       titleController.text = noteBeingEdited?.title;
  //       contentController.text = noteBeingEdited?.content;
  //
  //       if (noteBeingEdited?.imagePath != null) {
  //         _image = File(noteBeingEdited.imagePath);
  //       }
  //     }
  //   } else {
  //     firstTime = true;
  //   }
  // }


  @override
  initState(){
    super.initState();
    print("## NoteEditScreen.initState()");
  }

  @override
  didChangeDependencies(){
    super.didChangeDependencies();
    print("## NoteEditScreen.didChangeDependencies()");
  }


  @override
  void dispose() {
    print("## dispose()");

    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext inContext) {
    // if (ModalRoute.of(this.context).settings.arguments != null) {
    //   firstTime = false;
    // } else {
    //   firstTime = true;
    // }
    //
    // print("## NoteEditScreen. firstTime: $firstTime");
    //
    // if (!firstTime) {
    //   id = ModalRoute.of(this.context).settings.arguments;
    //   noteBeingEdited = Provider.of<NoteProvider>(
    //     this.context,
    //     listen: false,
    //   ).getNote(id);

    if (ModalRoute.of(inContext).settings.arguments != null) {
      firstTime = false;
    } else {
      firstTime = true;
    }

    print("## NoteEditScreen. firstTime: $firstTime");

    if (!firstTime) {
      id = ModalRoute.of(inContext).settings.arguments;
      print("## current note's id: $id");
      noteBeingEdited = Provider.of<NoteProvider>(inContext, listen: false).getNote(id);


      titleController.text = noteBeingEdited?.title;
      contentController.text = noteBeingEdited?.content;

      if (noteBeingEdited?.imagePath != null) {
        _image = File(noteBeingEdited.imagePath);
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.7,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () => Navigator.of(inContext).pop(),
          icon: Icon(Icons.arrow_back),
          color: Colors.black,
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.photo_camera),
            color: Colors.black,
            onPressed: () {
              getImage(ImageSource.camera);
            },
          ),
          IconButton(
            icon: Icon(Icons.insert_photo),
            color: Colors.black,
            onPressed: () {
              getImage(ImageSource.gallery);
            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            color: Colors.black,
            onPressed: () {
              // Navigator.pop(inContext);
              if (id != null) {
                _showDialog();
              } else {
                Navigator.pop(inContext);
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(
                  left: 10.0, right: 5.0, top: 10.0, bottom: 5.0),
              child: TextField(
                controller: titleController,
                maxLines: null,
                textCapitalization: TextCapitalization.sentences,
                style: createTitle,
                decoration: InputDecoration(
                    hintText: "Enter Note Title", border: InputBorder.none),
              ),
            ),
            if (_image != null)
              Container(
                padding: EdgeInsets.all(10),
                width: MediaQuery.of(inContext).size.width,
                height: 250.0,
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        image: DecorationImage(
                            image: FileImage(_image), fit: BoxFit.cover),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Container(
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle, color: Colors.white),
                          child: InkWell(
                            onTap: () {
                              setState(
                                () {
                                  _image = null;
                                },
                              );
                            },
                            child: Icon(Icons.delete, size: 16),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 10.0, right: 5.0, top: 10.0, bottom: 5.0),
              child: TextField(
                controller: contentController,
                maxLines: null,
                style: createContent,
                decoration: InputDecoration(
                  hintText: 'Enter Something...',
                  border: InputBorder.none,
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print("NoteEditScreen. onPressed");

          if (titleController.text.isEmpty)
            titleController.text = 'Untitled Note';
          _saveNote();
        },
        child: Icon(Icons.save),
      ),
    );
  }

  void getImage(ImageSource imageSource) async {
    print("## getImage()");

    PickedFile imageFile = await picker.getImage(source: imageSource);
    if (imageFile == null) return;

    File tmpFile = File(imageFile.path);
    final appDir = await getApplicationDocumentsDirectory(); // directory
    final fileName = basename(imageFile.path);
    /**
     * Copy this file. Returns a `Future<File>` that completes
     * with a [File] instance for the copied file.
     *
     * If [newPath] identifies an existing file, that file is
     * replaced. If [newPath] identifies an existing directory, the
     * operation fails and the future completes with an exception.
     */
    tmpFile = await tmpFile.copy('${appDir.path}/$fileName');
    setState(() {
      _image = tmpFile;
    });
    // Provider.of<NoteProvider>(this.context).entityBeingEdited.imagePath =
    //     _image != null ? _image.path : null;

    print("## getImage()");
    print("## imageFile.path: ${imageFile.path}");
    // ## imageFile.path: /storage/emulated/0/Android/data/dongho.awesome_note/files/Pictures/3b5ee941-1da3-4fee-8684-3540b8c670861897656602425133724.jpg
    print("## tmpFile: $tmpFile");
    // ## tmpFile: File: '/data/user/0/dongho.awesome_note/app_flutter/3b5ee941-1da3-4fee-8684-3540b8c670861897656602425133724.jpg'
  }

  void _saveNote() {
    String title = titleController.text.trim();
    String content = contentController.text.trim();
    String imagePath = _image != null ? _image.path : null;

    // update
    if (id != null) {
      Provider.of<NoteProvider>(this.context, listen: false)
          .addOrUpdateNote(id, title, content, imagePath, EditMode.UPDATE);
      Navigator.of(this.context).pop();
    }
    // create
    else {
      int id = DateTime.now().millisecondsSinceEpoch;
      Provider.of<NoteProvider>(this.context, listen: false)
          .addOrUpdateNote(id, title, content, imagePath, EditMode.ADD);
      Navigator.of(this.context)
          .pushReplacementNamed(NoteViewScreen.route, arguments: id);
    }
  }

  void _showDialog() {
    showDialog(
      context: this.context,
      builder: (context) {
        return DeletePopUp(
          selectedNote: noteBeingEdited,
        );
      },
    );
  }
}
