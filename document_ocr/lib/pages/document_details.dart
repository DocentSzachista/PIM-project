import 'package:document_ocr/db/document.dart';
import 'package:document_ocr/pages/share_page.dart';
import 'package:document_ocr/widgets/details_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class DocumentPage extends StatelessWidget {
  const DocumentPage({Key? key, required this.document}) : super(key: key);
  final Document document;
  final TextStyle linkStyle = const TextStyle(color: Colors.blue);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(document.name),
      ),
      body: DetailsWidget(document: document),
      bottomNavigationBar: TextButton(
          style: TextButton.styleFrom(
            foregroundColor: Colors.white70,
            backgroundColor: Colors.grey[500]
          ),
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => SharePage(document: document,)));
          },
          child: Text(AppLocalizations.of(context)!.shareDocumentButton)),
    );
  }
}
