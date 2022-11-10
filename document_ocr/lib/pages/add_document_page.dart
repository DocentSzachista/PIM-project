import 'package:document_ocr/widgets/add_document_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddDocumentPage extends StatelessWidget {
  const AddDocumentPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.addDocument),
        ),
        body: const AddDocument());
  }
}
