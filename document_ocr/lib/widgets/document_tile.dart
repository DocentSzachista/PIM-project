import 'dart:ui';

import 'package:document_ocr/db/document.dart';
import 'package:document_ocr/pages/document_details.dart';
import 'package:flutter/material.dart';

class DocumentTile extends StatelessWidget {
  final Document document;
  final double _imageWidth = double.infinity;
  final double _imageHeight = 120;
  final double _sigmaX = 5.1; // from 0-10
  final double _sigmaY = 5.1; // from 0-10
  final double _opacity = 0.5;
  final double _titlePadding = 10;
  const DocumentTile({Key? key, required this.document}) : super(key: key);

  Widget _getImage(String url, String title) => Stack(
          // fit: StackFit.passthrough,
          alignment: Alignment.center,
          children: [
            Image.network(
              url,
              width: _imageWidth,
              height: _imageHeight,
              fit: BoxFit.fitWidth,
            ),
            Positioned.fill(
              // left: 0,
              // bottom: 0,
              // width: _imageWidth,
              // width: _imageWidth,

              child: ClipRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: _sigmaX,
                    sigmaY: _sigmaY,
                  ),
                  child: Container(
                    color: Colors.white.withOpacity(_opacity),
                    child: Padding(
                        padding: EdgeInsets.only(left: _titlePadding),
                        child: Center(
                          child: Text(
                            title,
                            style: const TextStyle(fontSize: 28),
                          ),
                        )),
                  ),
                ),
              ),
            )
          ]);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
        child: Card(
          shape: RoundedRectangleBorder(
            side: BorderSide(),
            borderRadius: BorderRadius.circular(15)
          ),
          child: InkWell(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => DocumentPage(document: document)));
            },
            child:
               Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _getImage(document.imageURL, document.name),
                    // Text(document.name, textScaleFactor: 1.5),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: document.tags.isNotEmpty
                              ? List<Widget>.generate(document.tags.length,
                                  (index) {
                                  return Card(
                                      color: Color(0xfff44f03),
                                      child: Padding(
                                          padding: const EdgeInsets.all(2),
                                          child: Text(
                                              document.tags[index] as String)));
                                })
                              : [
                                  const SizedBox(
                                    height: 30,
                                  ),
                                ]),
                    ),
                  ]),
            ),
          ),
        );
  }
}
