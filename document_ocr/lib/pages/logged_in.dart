import "package:flutter/material.dart";
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../provider/google_sign_in.dart';

class LoggedIn extends StatelessWidget {
  const LoggedIn({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.homePageAppBar),
          actions: [
            TextButton(
                onPressed: () {
                  final provider =
                      Provider.of<GoogleSignInProvider>(context, listen: false);
                  provider.logout();
                },
                child: Text(
                  AppLocalizations.of(context)!.logOutText,
                  style: Theme.of(context).textTheme.button,
                ))
          ],
        ),
        body: const Center(
          child: Text("You made it :D"),
        ));
  }
}
