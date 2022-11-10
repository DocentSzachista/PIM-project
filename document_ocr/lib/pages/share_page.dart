import 'package:document_ocr/db/document.dart';
import 'package:document_ocr/widgets/share_document_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SharePage extends StatelessWidget {
  SharePage({Key? key}) : super(key: key);
  final Document document = Document(
      name: "title",
      text: "Lorem ipsum dixum trahunt",
      imageURL: "Example",
      tags: ["1", "2,", "3"]);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.uploadPageTitle),
        ),
        body: Padding(
            padding: EdgeInsets.all(10),
            child: ShareDocumentWidget(document: document)));
  }
}
