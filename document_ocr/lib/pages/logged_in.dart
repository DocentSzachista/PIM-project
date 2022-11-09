import 'package:document_ocr/db/db_handler.dart';
import 'package:document_ocr/pages/add_document_page.dart';
import 'package:document_ocr/pages/share_page.dart';
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
      body: Center(
        child: Column(children: [
          Text("You made it :D"),
          TextButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SharePage()));
              },
              child: Text("Test"))
        ]),
      ),
      floatingActionButton: FloatingActionButton(
        child: Text("+", style: Theme.of(context).textTheme.headlineLarge),
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => AddDocumentPage()));
        },
      ),
    );
  }
}
