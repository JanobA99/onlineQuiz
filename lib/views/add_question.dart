import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:online/services/database.dart';
import 'package:online/views/home.dart';
import 'package:online/widgets/widgets.dart';

class AddQuestion extends StatefulWidget {
  final String quizId;

  AddQuestion(this.quizId);

  @override
  _AddQuestionState createState() => _AddQuestionState();
}

class _AddQuestionState extends State<AddQuestion> {
  DatabaseService databaseService = new DatabaseService();
  final _formKey = GlobalKey<FormState>();

  bool isLoading = false;

  QuizModel question = QuizModel(), option1 = QuizModel(), option2 = QuizModel(), option3 = QuizModel();


  // String question = "", option1 = "", option2 = "", option3 = "";

  uploadQuizData() {
    if (_formKey.currentState.validate()) {
      setState(() {
        isLoading = true;
      });

      Map<String, dynamic> questionMap = {
        "question": question.option,
        "option1": {
          "option": option1.option,
          "score": option1.score
        },
        "option2": {
          "option": option2.option,
          "score": option2.score
        },
        "option3": {
          "option": option3.option,
          "score": option3.score
        },
      };

      print("${widget.quizId}");
      databaseService.addQuestionData(questionMap, widget.quizId).then((value) {
        question.onClear();
        option1.onClear();
        option2.onClear();
        option3.onClear();
        setState(() {
        isLoading = false;
        });
      }).catchError((e) {
        print(e);
      });
    } else {
      print("error is happening ");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: BackButton(
          color: Colors.black54,
        ),
        title: appBar(context),
        centerTitle: true,
        brightness: Brightness.light,
        elevation: 0.0,
        backgroundColor: Colors.blue,
        //brightness: Brightness.li,
      ),
      body: WillPopScope(
        onWillPop: _onWillPop,
        child: isLoading
            ? Container(
          child: Center(child: CircularProgressIndicator()),
        )
            : Stack(children: <Widget>[
          ClipPath(
            clipper: WaveClipperTwo(),
            child: Container(
              decoration:
              BoxDecoration(color: Theme
                  .of(context)
                  .primaryColor),
              height: 400,
            ),
          ),
          Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    Container(
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500),
                            validator: (val) =>
                            val.isEmpty ? "Enter Question" : null,
                            decoration: InputDecoration(
                                hintText: "Question",
                                hintStyle: TextStyle(
                                    color: Colors.black38,
                                    fontWeight: FontWeight.w500)),
                            onChanged: (val) {
                              question.option = val;
                            },
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          TextFormField(
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500),
                            validator: (val) =>
                            val.isEmpty ? "Enter Option1 " : null,
                            decoration: InputDecoration(
                                hintText: "Option1",
                                hintStyle: TextStyle(
                                    color: Colors.black38,
                                    fontWeight: FontWeight.w500)),
                            onChanged: (val) {
                              option1.option = val;
                            },
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          TextFormField(
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500),
                            validator: (val) =>
                            val.isEmpty ? "Enter Option2 " : null,
                            decoration: InputDecoration(
                                hintText: "Option2",
                                hintStyle: TextStyle(
                                    color: Colors.black38,
                                    fontWeight: FontWeight.w500)),
                            onChanged: (val) {
                              option2.option = val;
                            },
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          TextFormField(
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500),
                            validator: (val) =>
                            val.isEmpty ? "Enter Option3 " : null,
                            decoration: InputDecoration(
                                hintText: "Option3",
                                hintStyle: TextStyle(
                                    color: Colors.black38,
                                    fontWeight: FontWeight.w500)),
                            onChanged: (val) {
                              option3.option = val;
                            },
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          SizedBox(
                            height:
                            MediaQuery
                                .of(context)
                                .size
                                .height / 3,
                          ),
                          Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  uploadQuizData();
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Home(),
                                      ));
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  width:
                                  MediaQuery
                                      .of(context)
                                      .size
                                      .width /
                                      2 -
                                      40,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 24, vertical: 20),
                                  decoration: BoxDecoration(
                                      color: Colors.blue,
                                      borderRadius:
                                      BorderRadius.circular(30)),
                                  child: Text(
                                    "Submit",
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.white),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  uploadQuizData();
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  width:
                                  MediaQuery
                                      .of(context)
                                      .size
                                      .width /
                                      2 -
                                      40,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 24, vertical: 20),
                                  decoration: BoxDecoration(
                                      color: Colors.blue,
                                      borderRadius:
                                      BorderRadius.circular(30)),
                                  child: Text(
                                    "Add Question",
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 60,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }

  Future<bool> _onWillPop() async {
    return showDialog<bool>(
        context: context,
        builder: (_) {
          return alertDialog(
              context: context,
              content: Text(
                  "Are you sure you want to quit the quiz? All your progress will be lost."),
              title: Text("Warning"));
        });
  }
}

class QuizModel {
  String option;
  int score;

  QuizModel({this.option, this.score});

  void onClear() {
    option = '';
    score = 0;
  }

}
