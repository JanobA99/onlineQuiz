import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:image_picker/image_picker.dart';
import 'package:online/services/database.dart';
import 'package:online/views/add_question.dart';
import 'package:online/widgets/widgets.dart';
import 'package:random_string/random_string.dart';

class CreateQuiz extends StatefulWidget {
  @override
  _CreateQuizState createState() => _CreateQuizState();
}

class _CreateQuizState extends State<CreateQuiz> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  String quizTitle, quizDescription, quizId;
  DatabaseService databaseService = new DatabaseService();
  bool _isLoading = false;

  File selectedImage;

  Future getImage() async {
    // ignore: deprecated_member_use
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      selectedImage = image;
    });
  }

  createQuizOnline() async {
    if (selectedImage == null) {
      snack(_scaffoldKey, "Please select Image", Icon(Icons.error_outline));
    }
    if (_formKey.currentState.validate() && selectedImage != null) {
      setState(() {
        _isLoading = true;
      });

      /// uploading image to firebase storage
      StorageReference firebaseStorageRef = FirebaseStorage.instance
          .ref()
          .child("blogImages")
          .child("${randomAlphaNumeric(9)}.jpg");

      final StorageUploadTask task = firebaseStorageRef.putFile(selectedImage);

      var downloadUrl = await (await task.onComplete).ref.getDownloadURL();
      print("this is url $downloadUrl");

      quizId = randomAlphaNumeric(16);

      Map<String, String> quizMap = {
        "quizId": quizId,
        "quizImgUrl": downloadUrl,
        "quizTitle": quizTitle,
        "quizDescription": quizDescription
      };

      await databaseService.addQuizData(quizMap, quizId).then((value) {
        setState(() {
          _isLoading = false;
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => AddQuestion(quizId),
              ));
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: _isLoading
          ? Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : Stack(children: <Widget>[
              ClipPath(
                clipper: WaveClipperTwo(),
                child: Container(
                  decoration:
                      BoxDecoration(color: Theme.of(context).primaryColor),
                  height: 250,
                ),
              ),
              Form(
                key: _formKey,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        GestureDetector(
                            onTap: () {
                              getImage();
                            },
                            child: selectedImage != null
                                ? Container(
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 16),
                                    height: 170,
                                    width: MediaQuery.of(context).size.width,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(6),
                                      child: Image.file(
                                        selectedImage,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  )
                                : Container(
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 16),
                                    height: 170,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(6)),
                                    width: MediaQuery.of(context).size.width,
                                    child: Icon(
                                      Icons.add_a_photo,
                                      color: Colors.black45,
                                    ),
                                  )),
                        SizedBox(
                          height: 6,
                        ),
                        TextFormField(
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.w500),
                          validator: (val) =>
                              val.isEmpty ? "Enter Quiz Title" : null,
                          decoration: InputDecoration(
                              hoverColor: Colors.white,
                              hintText: "Quiz Title",
                              hintStyle: TextStyle(color: Colors.black38)),
                          onChanged: (val) {
                            quizTitle = val;
                          },
                        ),
                        SizedBox(
                          height: 6,
                        ),
                        TextFormField(
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.w500),
                          validator: (val) =>
                              val.isEmpty ? "Enter Image Description" : null,
                          decoration: InputDecoration(
                              hintText: "Quiz Image Description",
                              hintStyle: TextStyle(
                                  color: Colors.black38,
                                  fontWeight: FontWeight.w500)),
                          onChanged: (val) {
                            quizDescription = val;
                          },
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height / 5,
                        ),
                        GestureDetector(
                            onTap: () {
                              if (selectedImage == null) {
                                Clipboard.setData(new ClipboardData(
                                    text: "Please select Image"));
                              }
                              createQuizOnline();
                            },
                            child: blueButton(
                                context: context, label: "Create Quiz")),
                      ],
                    ),
                  ),
                ),
              ),
            ]),
    );
  }
}
