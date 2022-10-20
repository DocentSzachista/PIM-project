import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../widgets/login_widget.dart';
import 'logged_in.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData) {
          return LoggedIn();
        } else if (snapshot.hasError) {
          return Center(
            child: Text("Something went wrong, try again"),
          );
        } else {
          return LoginWidget();
        }
      },
    );
  }
// @override
// State<MyHomePage> createState() => _MyHomePageState();
}
