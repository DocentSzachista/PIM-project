import 'package:document_ocr/db/document.dart';
import 'package:document_ocr/pages/document_details.dart';
import 'package:flutter/material.dart';

class DocumentTile extends StatelessWidget {
  final Document document;

  const DocumentTile({Key? key, required this.document}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () async {
          await Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => DocumentPage(document: document)));
        },
        child: Padding(
          padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
          child: Card(
              child: Padding(
                  padding: const EdgeInsets.all(2),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(document.name, textScaleFactor: 1.5),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: List<Widget>.generate(
                                document.tags.length, (index) {
                              return Card(
                                  color: Colors.greenAccent,
                                  child: Padding(
                                      padding: const EdgeInsets.all(2),
                                      child: Text(
                                          document.tags[index] as String)));
                            }))
                      ]))),
        ));
  }
}
