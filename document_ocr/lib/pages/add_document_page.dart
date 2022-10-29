import 'package:document_ocr/widgets/add_document_widget.dart';
import 'package:flutter/material.dart';

class AddDocumentPage extends StatelessWidget {
  const AddDocumentPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: AddDocument()
    );
  }
}
