import 'package:flutter/material.dart';
import 'package:project_quang_flutter/screens/login_screen.dart';
import 'package:project_quang_flutter/screens/main_screen.dart';

import 'db/auth_helper.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder<bool>(
        future: AuthHelper.isLoggedIn(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else {
            return snapshot.data == true ? MainScreen() : LoginScreen();
          }
        },
      ),
    );
  }
}
