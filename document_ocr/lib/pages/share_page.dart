import 'package:document_ocr/db/document.dart';
import 'package:document_ocr/widgets/share_document_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SharePage extends StatelessWidget {
  const SharePage({Key? key, required this.document}) : super(key: key);
  final Document document;

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
