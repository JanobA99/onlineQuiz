import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class FirstWiev extends StatelessWidget {
  final primaryColor = const Color(0xFF75A2EA);
  final primaryColor2 = Colors.white;
  @override
  Widget build(BuildContext context) {
    final _widht = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        width: _widht,
        height: _height,
        color: primaryColor,
        child: ListView.builder(
          itemCount: 1,
          itemBuilder: (BuildContext context, int index) =>
              buildSafeArea(_height, context),
        ),
      ),
    );
  }

  SafeArea buildSafeArea(double _height, BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Container(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: _height * 0.10,
              ),
              Text(
                "Welcome",
                style: TextStyle(
                  fontSize: 45,
                  color: Colors.white,
                ),
              ),
              SizedBox(
                height: _height * 0.10,
              ),
              AutoSizeText(
                "Let's start planning your next quiz",
                maxLines: 2,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 35,
                  color: Colors.white,
                ),
              ),
              SizedBox(
                height: _height * 0.10,
              ),
              RaisedButton(
                color: primaryColor2,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40.0)),
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 10.0, bottom: 10, left: 30.0, right: 30.0),
                  child: Text(
                    "Get Started",
                    style: TextStyle(
                      color: primaryColor,
                      fontSize: 30.0,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
                onPressed: () {
                  Navigator.popAndPushNamed(context, "/anonymouslySignIn");
                },
              ),
              SizedBox(
                height: _height * 0.05,
              ),
              FlatButton(
                child: Text(
                  "Sign in",
                  style: TextStyle(
                    fontSize: 25.0,
                    color: primaryColor2,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed('/signIn');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
