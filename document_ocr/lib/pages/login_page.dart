import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/google_sign_in.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 200,
          height: 200,
          child: Container(
            color: Colors.black12,
          ),
        ),
        Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Text(
              "Hi, welcome back",
              style: TextStyle(fontSize: 32, fontFamily: "Roboto"),
            )),
        ElevatedButton(
          style: ButtonStyle(),
          child: Text(
            "Sign in with Google",
            style: TextStyle(fontSize: 16),
          ),
          onPressed: () {
            final provider =
                Provider.of<GoogleSignInProvider>(context, listen: false);
            provider.googleLogin();
          },
        ),
      ],
    )));
  }
}
