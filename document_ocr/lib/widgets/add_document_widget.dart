import 'dart:io';
import 'package:document_ocr/db/db_handler.dart';
import 'package:document_ocr/db/document.dart';
import 'package:document_ocr/widgets/tag_list.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'my_textfield.dart';

class AddDocument extends StatefulWidget {
  const AddDocument({Key? key}) : super(key: key);

  @override
  State<AddDocument> createState() => _AddDocumentState();
}

class _AddDocumentState extends State<AddDocument> {
  final _tags = [];
  String recognizedText = " ";
  late XFile? imageFile = null;
  final controllerTextEditing = TextEditingController();
  final controllerTagsText = TextEditingController();
  void retrieveImage(ImageSource source) async {
    // function tries to pick image from gallery and later invokes function
    // to recognize
    try {
      final pickedImage = await ImagePicker().pickImage(source: source);
      if (pickedImage != null) {
        imageFile = pickedImage;
        // setState is called to rebuild widget
        setState(() {});
        getRecognisedText(pickedImage);
      }
    } catch (e) {
      setState(() {});
    }
  }

  void getRecognisedText(XFile image) async {
    final inputImage = InputImage.fromFilePath(image.path);
    RecognizedText recognisedText =
        await TextRecognizer().processImage(inputImage);
    recognizedText = "";
    for (TextBlock block in recognisedText.blocks) {
      for (TextLine line in block.lines) {
        recognizedText = "$recognizedText${line.text} \n";
      }
      controllerTextEditing.text = recognizedText;
    }
    setState(() {});
  }

  Widget _imageContainer() => imageFile == null
      ? SizedBox(
          width: 300,
          height: 300,
          child: Container(
            color: Colors.grey.shade300,
          ),
        )
      : Image.file(
          File(imageFile!.path),
          width: 300,
          height: 300,
        );

  Widget _button(String text, ImageSource source) => TextButton(
      style: ButtonStyle(
        backgroundColor: MaterialStatePropertyAll<Color>(Colors.grey.shade400),
      ),
      onPressed: () {
        retrieveImage(source);
      },
      child: Text(text));

  Widget _buttonsRow(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _button(AppLocalizations.of(context)!.gallery, ImageSource.gallery),
          _button(AppLocalizations.of(context)!.takePicture, ImageSource.camera)
        ],
      );

  Widget _tagsTextField(BuildContext context) => TextField(
        controller: controllerTagsText,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
        ),
        onSubmitted: (text) {
          if (text.isNotEmpty) {
            setState(() {
              _tags.add(text);
              controllerTagsText.text = "";
              print(_tags);
            });
          }
        },
      );

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        child: SingleChildScrollView(
            child: Center(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _imageContainer(),
              _buttonsRow(context),
              Divider(
                height: 30,
                thickness: 5.0,
              ),
              MyTextField(
                controller: controllerTextEditing,
              ),
              // _generatedTextArea(context),
              Divider(
                thickness: 5.0,
              ),
              TagList(tags: _tags),
              _tagsTextField(context),
              ElevatedButton(
                  onPressed: () async {
                    if (imageFile != null && recognizedText.isNotEmpty) {
                      final db = DbHandler();
                      String fileURL = await db.uploadFile(imageFile!);
                      Document documentToAdd = Document(
                          name: "Debug",
                          text: recognizedText,
                          imageURL: fileURL);
                      await db.addDocument(documentToAdd);
                    }
                  },
                  child: Text(AppLocalizations.of(context)!.addDocument)),
            ],
          ),
        )));
  }
}
