import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomDialog extends StatelessWidget {
  final primaryColor = const Color(0xFF987587);
  final greyColor = const Color(0xFF958423);

  final String title,
      description,
      ptimryButtonText,
      primaryButtonRoute,
      secondaryButtonText,
      secondaryButtonRoute;
  CustomDialog(
      {@required this.title,
      @required this.description,
      @required this.ptimryButtonText,
      @required this.primaryButtonRoute,
      this.secondaryButtonText,
      this.secondaryButtonRoute});
  static const double padding = 20.0;
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(padding)),
      child: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(padding),
              decoration: BoxDecoration(
                color: Colors.amber,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(padding),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black,
                      blurRadius: 10.0,
                      offset: const Offset(0.0, 10.0)),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SizedBox(height: 25.0),
                  AutoSizeText(
                    title,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    style: TextStyle(
                      fontSize: 25.0,
                      color: primaryColor,
                    ),
                  ),
                  SizedBox(height: 25.0),
                  AutoSizeText(
                    description,
                    textAlign: TextAlign.center,
                    maxLines: 4,
                    style: TextStyle(
                      fontSize: 18.0,
                      color: greyColor,
                    ),
                  ),
                  SizedBox(height: 25.0),
                  RaisedButton(
                    color: primaryColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0)),
                    child: AutoSizeText(
                      ptimryButtonText,
                      maxLines: 1,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                        fontWeight: FontWeight.w200,
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(context)
                          .pushReplacementNamed(primaryButtonRoute);
                    },
                  ),
                  showSecondaryButton(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  showSecondaryButton(BuildContext context) {
    if (secondaryButtonRoute != null && secondaryButtonText != null) {
      return FlatButton(
        child: AutoSizeText(
          secondaryButtonText,
          maxLines: 1,
          style: TextStyle(
            color: primaryColor,
            fontSize: 18.0,
            fontWeight: FontWeight.w400,
          ),
        ),
        onPressed: () {
          Navigator.of(context).pop();
          Navigator.of(context).pushReplacementNamed(secondaryButtonRoute);
        },
      );
    } else {
      SizedBox(
        height: 10.0,
      );
    }
  }
}
