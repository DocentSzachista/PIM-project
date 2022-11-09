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
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData) {
          return const LoggedIn();
        } else if (snapshot.hasError) {
          return const Center(
            child: Text("Something went wrong, try again"),
          );
        } else {
          return const LoginWidget();
        }
      },
    );
  }
}
