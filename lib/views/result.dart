import 'package:flutter/material.dart';

class Results extends StatefulWidget {
  final int sum;

  Results({@required this.sum});

  @override
  _ResultsState createState() => _ResultsState();
}

class _ResultsState extends State<Results> {
  @override
  Widget build(BuildContext context) {
    final TextStyle titleStyle = TextStyle(
        color: Colors.black87, fontSize: 16.0, fontWeight: FontWeight.w500);
    final TextStyle trailingStyle = TextStyle(
        color: Theme.of(context).primaryColor,
        fontSize: 20.0,
        fontWeight: FontWeight.bold);
    return Scaffold(
        appBar: AppBar(
          title: Text('Result'),
          elevation: 0,
        ),
        body: Padding(
          padding: const EdgeInsets.only(left: 20,right: 20,bottom: 30),
          child: Center(
            child: 49 <= widget.sum && widget.sum <= 56
                ? Text(
                    "Great interest in signature systems. Ideal profession - editor, secretary, economist, painter, cartographer;",style: TextStyle(fontSize: 18),textAlign: TextAlign.center,)
                : 37 <= widget.sum && widget.sum <= 48
                    ? Text(
                        "Interest in signature systems has increased. It is better to give preference to the profession of manager, lawyer, financier, journalist;",style: TextStyle(fontSize: 18),textAlign: TextAlign.center,)
                    : 25 <= widget.sum && widget.sum <= 36
                        ? Text(
                            "Certain interests cannot be separated. You should try not to choose the second option of the answer or repeat the test to move on to another test;",style: TextStyle(fontSize: 18),textAlign: TextAlign.center,)
                        : 13 <= widget.sum && widget.sum <= 24
                            ? Text(
                                "There is a great interest in creativity. The best areas of activity are production, advertising, design, psychology, journalism, etc .;",style: TextStyle(fontSize: 18),textAlign: TextAlign.center,)
                            : Text(
                                "'Free Artist'. In this case, it is better to work as a sole proprietor or freelancer.",style: TextStyle(fontSize: 18),textAlign: TextAlign.center,),
          ),
        ),
    );
  }
}
