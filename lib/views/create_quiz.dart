import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:online/services/database.dart';
import 'package:online/views/add_question.dart';
import 'package:online/widgets/widgets.dart';
import 'package:random_string/random_string.dart';

class CreateQuiz extends StatefulWidget {
  @override
  _CreateQuizState createState() => _CreateQuizState();
}

class _CreateQuizState extends State<CreateQuiz> {
  final _formKey = GlobalKey<FormState>();
  String quizImageUrl, quizTitle, quizDescription, quizId;
  DatabaseService databaseService = new DatabaseService();
  bool _isLoading = false;

  createQuizOnline() async {
    if (_formKey.currentState.validate()) {
      setState(() {
        _isLoading = true;
      });
      quizId = randomAlphaNumeric(16);

      Map<String, String> quizMap = {
        "quizId": quizId,
        "quizImgUrl": quizImageUrl,
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
      body: _isLoading
          ? Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : Form(
              key: _formKey,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        validator: (val) =>
                            val.isEmpty ? "Enter Image Url" : null,
                        decoration: InputDecoration(
                          hintText:
                              "Quiz Image Url(enter \"A\" if you do not have a URL)",
                          hintStyle: TextStyle(fontSize: 14),
                        ),
                        onChanged: (val) {
                          if (val == "A") {
                            quizImageUrl =
                                "https://www.ouest-france.fr/leditiondusoir/data/7781/NextGenData/1734152/img/main.jpg?v=-%20%00%%20-1504086508-%20%00%%20-";
                          } else {
                            quizImageUrl = val;
                          }
                        },
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      TextFormField(
                        validator: (val) =>
                            val.isEmpty ? "Enter Quiz Title" : null,
                        decoration: InputDecoration(
                          hintText: "Quiz Title",
                        ),
                        onChanged: (val) {
                          quizTitle = val;
                        },
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      TextFormField(
                        validator: (val) =>
                            val.isEmpty ? "Enter Image Description" : null,
                        decoration: InputDecoration(
                          hintText: "Quiz Image Description",
                        ),
                        onChanged: (val) {
                          quizDescription = val;
                        },
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 3,
                      ),
                      GestureDetector(
                          onTap: () {
                            createQuizOnline();
                          },
                          child: blueButton(
                              context: context, label: "Create Quiz")),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
