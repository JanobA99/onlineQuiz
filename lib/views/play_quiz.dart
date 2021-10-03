import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:online/models/question_model.dart';
import 'package:online/services/database.dart';
import 'package:online/views/add_question.dart';
import 'package:online/views/result.dart';
import 'package:online/widgets/quiz_play_widgets.dart';
import 'package:online/widgets/widgets.dart';

class QuizPlay extends StatefulWidget {
  final String quizId;

  QuizPlay(this.quizId);

  @override
  _QuizPlayState createState() => _QuizPlayState();
}

int _correct = 0;
int _incorrect = 0;
int _notAttempted = 0;
int total = 0;
int sum = 0;

/// Stream
Stream infoStream;

class _QuizPlayState extends State<QuizPlay> {
  QuerySnapshot questionSnaphot;
  DatabaseService databaseService = new DatabaseService();

  bool isLoading = true;

  @override
  void initState() {
    databaseService.getQuizData(widget.quizId).then((value) {
      questionSnaphot = value;
      _notAttempted = questionSnaphot.documents.length;
      _correct = 0;
      _incorrect = 0;
      isLoading = false;
      total = questionSnaphot.documents.length;
      setState(() {});
      print("init don $total ${widget.quizId} ");
    });

    if (infoStream == null) {
      infoStream = Stream<List<int>>.periodic(Duration(milliseconds: 100), (x) {
        return [_correct, _incorrect];
      });
    }

    super.initState();
  }

  QuestionModel getQuestionModelFromDatasnapshot(
      DocumentSnapshot questionSnapshot) {
    QuestionModel questionModel = new QuestionModel();

    questionModel.question = questionSnapshot.data["question"];

    questionModel.option1 = QuizModel(
        option: questionSnapshot.data["option1"]["option"],
        score: questionSnapshot.data["option1"]["score"]);
    questionModel.option2 = QuizModel(
        option: questionSnapshot.data["option2"]["option"],
        score: questionSnapshot.data["option2"]["score"]);
    questionModel.option3 = QuizModel(
        option: questionSnapshot.data["option3"]["option"],
        score: questionSnapshot.data["option3"]["score"]);
    questionModel.correctOption = questionSnapshot.data["option1"]["option"];
    questionModel.answered = false;

    return questionModel;
  }

  @override
  void dispose() {
    infoStream = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: appBar(context),
        centerTitle: true,
        backgroundColor: Colors.blue,
        brightness: Brightness.light,
        elevation: 0.0,
      ),
      body: isLoading
          ? Container(
              child: Center(child: CircularProgressIndicator()),
            )
          : SingleChildScrollView(
              child: Container(
                child: Column(
                  children: [
                    // InfoHeader(
                    //   length: questionSnaphot.documents.length,
                    // ),
                    SizedBox(
                      height: 10,
                    ),
                    questionSnaphot.documents == null
                        ? Container(
                            child: Center(
                              child: Text("No Data"),
                            ),
                          )
                        : WillPopScope(
                            onWillPop: _onWillPop,
                            child: ListView.builder(
                                itemCount: questionSnaphot.documents.length,
                                shrinkWrap: true,
                                physics: ClampingScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return QuizPlayTile(
                                    questionModel:
                                        getQuestionModelFromDatasnapshot(
                                            questionSnaphot.documents[index]),
                                    index: index,
                                  );
                                }),
                          )
                  ],
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => Results(sum: sum,),
            ),
          );
        },
        child: Icon(Icons.check),
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


class QuizPlayTile extends StatefulWidget {
  final QuestionModel questionModel;
  final int index;

  QuizPlayTile({@required this.questionModel, @required this.index});

  @override
  _QuizPlayTileState createState() => _QuizPlayTileState();
}

class _QuizPlayTileState extends State<QuizPlayTile> {
  String optionSelected = "";
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              "Q${widget.index + 1}: ${widget.questionModel.question}",
              style:
                  TextStyle(fontSize: 18, color: Colors.black.withOpacity(0.8)),
            ),
          ),
          SizedBox(
            height: 12,
          ),
          GestureDetector(
            onTap: () {
              if (index == 0) {
                sum = sum + widget.questionModel.option1.score;
              } else if (index == 2) {
                sum = sum - widget.questionModel.option2.score;
                sum = sum + widget.questionModel.option1.score;
              } else if (index == 3) {
                sum = sum - widget.questionModel.option3.score;
                sum = sum + widget.questionModel.option1.score;
              }
              setState(() {
                index = 1;
              });
              print(sum);
            },
            child: OptionTile(
              option: "A",
              description: "${widget.questionModel.option1.option}",
              correctAnswer: widget.questionModel.correctOption,
              optionSelected: optionSelected,
              answered: index == 1,
            ),
          ),
          SizedBox(
            height: 4,
          ),
          GestureDetector(
            onTap: () {
              if (index == 0) {
                sum = sum + widget.questionModel.option2.score;
              } else if (index == 1) {
                sum = sum - widget.questionModel.option1.score;
                sum = sum + widget.questionModel.option2.score;
              } else if (index == 3) {
                sum = sum - widget.questionModel.option3.score;
                sum = sum + widget.questionModel.option2.score;
              }
              setState(() {
                index = 2;
              });
              print(sum);
            },
            child: OptionTile(
              option: "B",
              description: "${widget.questionModel.option2.option}",
              correctAnswer: widget.questionModel.correctOption,
              optionSelected: optionSelected,
              answered: index == 2,
            ),
          ),
          SizedBox(
            height: 4,
          ),
          GestureDetector(
            onTap: () {
              if (index == 0) {
                sum = sum + widget.questionModel.option3.score;
              } else if (index == 1) {
                sum = sum - widget.questionModel.option1.score;
                sum = sum + widget.questionModel.option3.score;
              } else if (index == 2) {
                sum = sum - widget.questionModel.option2.score;
                sum = sum + widget.questionModel.option3.score;
              }
              setState(() {
                index = 3;
              });
              print(sum);
            },
            child: OptionTile(
              option: "C",
              description: "${widget.questionModel.option3.option}",
              correctAnswer: widget.questionModel.correctOption,
              optionSelected: optionSelected,
              answered: index == 3,
            ),
          ),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
