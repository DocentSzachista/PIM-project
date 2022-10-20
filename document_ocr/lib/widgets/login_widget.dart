import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../provider/google_sign_in.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginWidget extends StatelessWidget {
  const LoginWidget({Key? key}) : super(key: key);
  final Size buttonSize = const Size(230, 50);
  final double padding = 30;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
                width: 250,
                height: 250,
                child: Image.asset("assets/images/logo.png")),
            Padding(
                padding: EdgeInsets.symmetric(vertical: padding),
                child: Text(
                  AppLocalizations.of(context)!.welcome,
                  style: Theme.of(context).textTheme.headlineSmall,
                )),
            ElevatedButton.icon(
              style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all(buttonSize),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          side: const BorderSide()))),
              icon: const Icon(FontAwesomeIcons.google),
              label: Text(
                AppLocalizations.of(context)!.logInText,
                style: Theme.of(context).textTheme.button,
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
