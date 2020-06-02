import 'package:flutter/material.dart';

void snack(_scaffoldKey, String text, Icon icon) {
  SnackBar snackBar = new SnackBar(
    content: Row(children: <Widget>[
      icon,
      SizedBox(
        width: 10,
      ),
      Text(
        "$text",
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
      ),
    ]),
    backgroundColor: Colors.red,
  );
  _scaffoldKey.currentState.showSnackBar(snackBar);
}

Widget appBar(BuildContext context) {
  return RichText(
    text: TextSpan(style: TextStyle(fontSize: 22), children: <TextSpan>[
      TextSpan(
        text: 'Quiz',
        style:
            TextStyle(fontWeight: FontWeight.w600, color: Colors.yellowAccent),
      ),
      TextSpan(
          text: 'Maker',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          )),
    ]),
  );
}

Widget blueButton({BuildContext context, String label, buttonWidth}) {
  return Container(
    padding: EdgeInsets.symmetric(vertical: 18),
    decoration: BoxDecoration(
        color: Colors.blue, borderRadius: BorderRadius.circular(30)),
    alignment: Alignment.center,
    width: buttonWidth != null
        ? buttonWidth
        : MediaQuery.of(context).size.width - 48,
    child: Text(
      label,
      style: TextStyle(color: Colors.white, fontSize: 16),
    ),
  );
}

Widget alertDialog<bool>({BuildContext context, Text content, Text title}) {
  return AlertDialog(
    content: content,
    title: title,
    actions: <Widget>[
      FlatButton(
        child: Text("Yes"),
        onPressed: () {
          Navigator.pop(context, true);
        },
      ),
      FlatButton(
        child: Text("No"),
        onPressed: () {
          Navigator.pop(context, false);
        },
      ),
    ],
  );
}
