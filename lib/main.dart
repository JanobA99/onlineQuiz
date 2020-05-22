import 'package:flutter/material.dart';
import 'package:online/services/auth.dart';
import 'package:online/views/firs_wiev.dart';
import 'package:online/views/home.dart';
import 'package:online/views/sign_up.dart';
import 'package:online/widgets/provider_widget.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Provider(
      auth: AuthService(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: HomeController(),
        routes: <String, WidgetBuilder>{
          '/home': (BuildContext context) => HomeController(),
          '/signUp': (BuildContext context) =>
              SignUpWiev(authFormType: AuthFormType.signUp),
          '/signIn': (BuildContext context) =>
              SignUpWiev(authFormType: AuthFormType.signIn),
          '/anonymouslySignIn': (BuildContext context) =>
              SignUpWiev(authFormType: AuthFormType.anonymous),
          '/convertUser': (BuildContext context) => SignUpWiev(
                authFormType: AuthFormType.convert,
              )
        },
      ),
    );
  }
}

class HomeController extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AuthService auth = Provider.of(context).auth;
    return StreamBuilder<String>(
        stream: auth.onAuthStateChanged,
        builder: (context, AsyncSnapshot<String> snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            final bool signedIn = snapshot.hasData;
            return signedIn ? Home() : FirstWiev();
          }
          return CircularProgressIndicator();
        });
  }
}
