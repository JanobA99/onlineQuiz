import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart' show SpinKitDoubleBounce;
import 'package:online/services/auth.dart';
import 'package:online/widgets/provider_widget.dart';

final primaryColor = const Color(0xFF75A2EA);

enum AuthFormType { signIn, signUp, reset, anonymous, convert }

class SignUpWiev extends StatefulWidget {
  final AuthFormType authFormType;

  SignUpWiev({Key key, @required this.authFormType}) : super(key: key);
  @override
  _SignUpWievState createState() =>
      _SignUpWievState(authFormType: this.authFormType);
}

class _SignUpWievState extends State<SignUpWiev> {
  AuthFormType authFormType;
  _SignUpWievState({this.authFormType});

  final formKey = GlobalKey<FormState>();
  String _email, _password, _username, _warning;

  void switchFormState(String state) {
    formKey.currentState.reset();
    if (state == "signUp") {
      setState(() {
        authFormType = AuthFormType.signUp;
      });
    } else if (state == 'home') {
      Navigator.of(context).pop();
    } else {
      setState(() {
        authFormType = AuthFormType.signIn;
      });
    }
  }

  bool validate() {
    final form = formKey.currentState;
    if (authFormType == AuthFormType.anonymous) {
      return true;
    }
    form.save();
    if (form.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }

  void submit() async {
    if (validate()) {
      try {
        final auth = Provider.of(context).auth;
        switch (authFormType) {
          case AuthFormType.signIn:
            await auth.signInUserWithEmailAndPassword(_email, _password);
            Navigator.of(context).pushReplacementNamed('/home');
            break;
          case AuthFormType.signUp:
            await auth.createUserWithEmailAndPassword(
                _email, _password, _username);
            Navigator.of(context).pushReplacementNamed('/home');
            break;
          case AuthFormType.reset:
            await auth.sendPasswordResetEmail(_email);
            _warning = "A password reset link has been sent to $_email";
            setState(() {
              authFormType = AuthFormType.signIn;
            });
            break;
          case AuthFormType.anonymous:
            await auth.signInAnonymously();
            Navigator.of(context).pushReplacementNamed('/home');
            break;
          case AuthFormType.convert:
            await auth.convertUserWithEmail(_email, _password, _username);
            Navigator.of(context).pop();
            break;
        }
      } catch (e) {
        print(e);
        setState(() {
          _warning = e.message;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;

    if (authFormType == AuthFormType.anonymous) {
      submit();
      return Scaffold(
        backgroundColor: primaryColor,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SpinKitDoubleBounce(
              color: Colors.white,
            ),
            Text(
              "Loading",
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      );
    } else {
      return Scaffold(
        body: Container(
          color: primaryColor,
          height: _height,
          width: _width,
          child: SingleChildScrollView(
            child: SafeArea(
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: _height * 0.025,
                  ),
                  showAlert(),
                  SizedBox(
                    height: _height * 0.025,
                  ),
                  buildHeaderText(),
                  SizedBox(
                    height: _height * 0.05,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Form(
                      key: formKey,
                      child: Column(
                        children: buildInPuts() + buildButtoms(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
  }

  Widget showAlert() {
    if (_warning != null) {
      return Container(
        padding: EdgeInsets.all(8.0),
        color: Colors.amberAccent,
        width: double.infinity,
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Icon(Icons.error_outline),
            ),
            Expanded(
              child: AutoSizeText(
                _warning,
                maxLines: 3,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  setState(() {
                    _warning = null;
                  });
                },
              ),
            )
          ],
        ),
      );
    }
    return SizedBox(
      height: 0,
    );
  }

  AutoSizeText buildHeaderText() {
    String _headerText;
    if (authFormType == AuthFormType.signIn) {
      _headerText = "Sign In";
    } else if (authFormType == AuthFormType.reset) {
      _headerText = "Reset Password";
    } else {
      _headerText = "Create New Accaunt";
    }
    return AutoSizeText(
      _headerText,
      maxLines: 1,
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Colors.white,
        fontSize: 35,
      ),
    );
  }

  List<Widget> buildInPuts() {
    List<Widget> textField = [];
    if (authFormType == AuthFormType.reset) {
      textField.add(TextFormField(
        validator: EmailValidator.validate,
        style: TextStyle(
          fontSize: 22.0,
        ),
        decoration: buildSignUpInputDecoration("Email"),
        onSaved: (value) => _email = value,
      ));
      textField.add(SizedBox(
        height: 20.0,
      ));
      return textField;
    }

    //if were the sign up state and name
    if ([AuthFormType.signUp, AuthFormType.convert].contains(authFormType)) {
      textField.add(TextFormField(
        validator: NameValidator.validate,
        style: TextStyle(
          fontSize: 22.0,
        ),
        decoration: buildSignUpInputDecoration("Name"),
        onSaved: (value) => _username = value,
      ));
      textField.add(SizedBox(
        height: 20.0,
      ));
    }
    // add email & password
    textField.add(TextFormField(
      validator: EmailValidator.validate,
      style: TextStyle(
        fontSize: 22.0,
      ),
      decoration: buildSignUpInputDecoration("Email"),
      onSaved: (value) => _email = value,
    ));
    textField.add(SizedBox(
      height: 20.0,
    ));
    textField.add(TextFormField(
      validator: PasswordValidator.validate,
      style: TextStyle(
        fontSize: 22.0,
      ),
      decoration: buildSignUpInputDecoration("Password"),
      obscureText: true,
      onSaved: (value) => _password = value,
    ));
    textField.add(SizedBox(
      height: 20.0,
    ));
    return textField;
  }

  List<Widget> buildButtoms() {
    String _switchButtomText, _newFormState, _sumbitBottomText;
    bool _showForgetPassword = false;
    bool _showSocialIcons = true;
    if (authFormType == AuthFormType.signIn) {
      _switchButtomText = "Create New Accaunt";
      _newFormState = "signUp";
      _sumbitBottomText = "Sign In";
      _showForgetPassword = true;
    } else if (authFormType == AuthFormType.reset) {
      _switchButtomText = "Return to Sign In";
      _newFormState = "signIn";
      _sumbitBottomText = "Sumbit";
      _showSocialIcons = false;
    } else if (authFormType == AuthFormType.convert) {
      _switchButtomText = "Cancel";
      _newFormState = "home";
      _sumbitBottomText = "Sign Up";
    } else {
      _switchButtomText = "Hava an Accaunt? Sign In";
      _newFormState = "signIn";
      _sumbitBottomText = "Sign Up";
    }
    return [
      Container(
        width: MediaQuery.of(context).size.width * 0.7,
        child: RaisedButton(
          color: Colors.white,
          textColor: primaryColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Text(
              _sumbitBottomText,
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w300),
            ),
          ),
          onPressed: submit,
        ),
      ),
      showForgetPassword(_showForgetPassword),
      FlatButton(
        child: Text(
          _switchButtomText,
          style: TextStyle(color: Colors.white),
        ),
        onPressed: () {
          switchFormState(_newFormState);
        },
      ),
      buildSocialIcons(_showSocialIcons),
    ];
  }

  Widget showForgetPassword(bool visible) {
    return Visibility(
      child: FlatButton(
        child: Text(
          "Forgot Password?",
          style: TextStyle(color: Colors.white),
        ),
        onPressed: () {
          setState(() {
            authFormType = AuthFormType.reset;
          });
        },
      ),
      visible: visible,
    );
  }

  Widget buildSocialIcons(bool visible) {
    final _auth = Provider.of(context).auth;
    return Visibility(
      child: Column(
        children: <Widget>[
          Divider(
            color: Colors.white,
          ),
          SizedBox(
            height: 10.0,
          ),
          GoogleSignInButton(
            onPressed: () async {
              try {
                if (authFormType == AuthFormType.convert) {
                  await _auth.convertWithGoogle();
                  Navigator.of(context).pop();
                } else {
                  await _auth.signInWithGoogle();
                  Navigator.of(context).pushReplacementNamed('/home');
                }
              } catch (e) {
                print(e);
                setState(() {
                  _warning = e.message;
                });
              }
            },
          )
        ],
      ),
      visible: visible,
    );
  }

  InputDecoration buildSignUpInputDecoration(String hint) {
    return InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        focusColor: Colors.white,
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: 0.0)),
        contentPadding:
            const EdgeInsets.only(left: 14.0, bottom: 10.0, top: 10.0));
  }
}
