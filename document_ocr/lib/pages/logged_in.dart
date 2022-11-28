import 'package:document_ocr/db/db_handler.dart';
import 'package:document_ocr/db/document.dart';
import 'package:document_ocr/pages/add_document_page.dart';
import 'package:document_ocr/widgets/search_bar.dart';
import "package:flutter/material.dart";
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:document_ocr/widgets/document_tile.dart';
import '../provider/google_sign_in.dart';

class LoggedIn extends StatefulWidget {
  const LoggedIn({Key? key}) : super(key: key);

  @override
  LoggedInState createState() => LoggedInState();
}

class LoggedInState extends State<LoggedIn> {
  final DbHandler db = DbHandler();

  @override
  Widget build(BuildContext context) {
    Future<List<Document>> documentFuture = db.getDocument();
    return Scaffold(
      drawer: Drawer(
          child: ListView(
            children:  [
              DrawerHeader(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.grey,
                      Colors.black12,
                    ],),
                ),
                child: Center(
                  child: Text(
                      "Document OCR",
                      style: Theme.of(context).textTheme.headlineMedium
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.logout),
                title: Text(AppLocalizations.of(context)!.logOutText,),
                onTap: (){
                  final provider =
                  Provider.of<GoogleSignInProvider>(context, listen: false);
                  provider.logout();
                },
              ),
              ListTile(
                leading: const Icon(Icons.search),
                title: Text(AppLocalizations.of(context)!.searchText),
                onTap: () {
                  showSearch(context: context, delegate: DocumentSearchDelegate(documents: documentFuture));
                },
              )
            ],
          ) ,
      ),

      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.homePageAppBar),
      ),
      body: FutureBuilder(
        future: documentFuture,
        builder: ((context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            List<Document> docs = snapshot.data as List<Document>;
            return ListView.builder(
              itemCount: docs.length,
              itemBuilder: ((context, index) {
                return DocumentTile(document: docs[index]);
              }),
            );
          }
        }),
      ),
      floatingActionButton: FloatingActionButton(
        child: Text("+", style: Theme.of(context).textTheme.headlineLarge),
        onPressed: () async {
          await Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const AddDocumentPage()));

          documentFuture = db.getDocument();
          setState(() {});
        },
      ),
    );
  }
}
