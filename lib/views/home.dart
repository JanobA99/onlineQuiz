import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:online/services/auth.dart';
import 'package:online/views/create_quiz.dart';
import 'package:online/views/quiz_list.dart';
import 'package:online/widgets/provider_widget.dart';
import 'package:online/widgets/widgets.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 1;
  final List<Widget> _children = [
    CreateQuiz(),
    QuizList(),
    CreateQuiz(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: appBar(context),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        brightness: Brightness.light,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.exit_to_app,
              color: Colors.black87,
            ),
            onPressed: () async {
              try {
                AuthService auth = Provider.of(context).auth;
                await auth.signOut();
                print("Signed Out");
              } catch (e) {
                print('Eror: $e');
              }
            },
          ),
          IconButton(
            icon: Icon(Icons.account_circle, color: Colors.black87),
            onPressed: () {
              Navigator.of(context).pushNamed('/convertUser');
            },
          ),
        ],
      ),
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            title: Text('Add Quiz'),
            icon: Icon(Icons.add_circle),
          ),
          BottomNavigationBarItem(
            title: Text('Home'),
            icon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            title: Text('Add Test'),
            icon: Icon(Icons.add_box),
          ),
        ],
      ),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
