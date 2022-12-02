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
  final controllerTitle = TextEditingController();

  final _key = GlobalKey<FormState>();

  void retrieveImage(ImageSource source) async {
    try {
      final pickedImage = await ImagePicker().pickImage(source: source);
      if (pickedImage != null) {
        imageFile = pickedImage;
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
          width: 250,
          height: 250,
          child: Container(
            color: Colors.grey.shade300,
            child: Center(
              child: Text(AppLocalizations.of(context)!.chooseImageTooltip),
            ),
          ),
        )
      : Image.file(
          File(imageFile!.path),
          width: 250,
          height: 250,
          fit: BoxFit.cover,
        );

  Widget _button(String text, ImageSource source) => SizedBox(
        width: 120,
        child: TextButton(
          style: const ButtonStyle(
            backgroundColor: MaterialStatePropertyAll<Color>(Colors.lightBlue),
          ),
          onPressed: () {
            retrieveImage(source);
          },
          child: Text(
            text,
            style: const TextStyle(color: Colors.black),
          ),
        ),
      );

  Widget _buttonsRow(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
            });
          }
        },
      );

  Widget _documentTitle() => TextFormField(
        validator: (value) {
          if (value == null || value.isEmpty) {
            return AppLocalizations.of(context)!.invalidTitle;
          }
          return null;
        },
        controller: controllerTitle,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
        ),
      );
  SnackBar _snackBar() => const SnackBar(
        content: Text('Done'),
        backgroundColor: Colors.blueGrey,
        duration: Duration(seconds: 2),
      );

  Widget _submitButton(BuildContext context) => SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () async {
            if (_key.currentState!.validate() && imageFile != null) {
              final db = DbHandler();
              String fileURL = await db.uploadFile(imageFile!);
              Document documentToAdd = Document(
                  name: controllerTitle.text,
                  text: recognizedText,
                  imageURL: fileURL,
                  tags: _tags);
              bool success = await db.addDocument(documentToAdd);
              if (success) {
                ScaffoldMessenger.of(context).showSnackBar(_snackBar());
              }
            }
          },
          child: Text(AppLocalizations.of(context)!.addDocument),
        ),
      );

  Widget _paddedText(
          BuildContext context, String text, paddingLeft, paddingTop) =>
      Padding(
        padding: EdgeInsets.only(left: paddingLeft, top: paddingTop),
        child: Text(
          text,
          style: Theme.of(context).textTheme.titleMedium,
        ),
      );
  Widget _roundedThing() => Container(
        padding: const EdgeInsets.only(
          top: 80,
          left: 20,
          right: 20,
        ),
        decoration: const BoxDecoration(
          boxShadow: [BoxShadow(color: Colors.white24, spreadRadius: 5)],
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(120),
            topRight: Radius.circular(120),
          ),
          color: Colors.white,
        ),
      );
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Form(
          key: _key,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  top: 20,
                  bottom: 20,
                ),
                child: Column(
                  children: [
                    _imageContainer(),
                    _buttonsRow(context),
                  ],
                ),
              ),
              _roundedThing(),
              Container(
                color: Colors.white,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _paddedText(
                          context,
                          AppLocalizations.of(context)!.documentTitleLabel,
                          10.0,
                          0.0),
                      SizedBox(height: 50, child: _documentTitle()),
                      SizedBox(
                        height: 20,
                      ),
                      TagList(tags: _tags),
                      _paddedText(context,
                          AppLocalizations.of(context)!.tagTitle, 10.0, 10.0),
                      SizedBox(height: 50, child: _tagsTextField(context)),
                      _paddedText(
                          context,
                          AppLocalizations.of(context)!.textfieldTooltip,
                          10.0,
                          20.0),
                      SizedBox(
                        height: 100,
                        child: MyTextField(
                          controller: controllerTextEditing,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: _submitButton(context),
                      ),
                    ],
                  ),
                ),
              ),
              // TagList(tags: _tags),
            ],
          ),
        ),
      ),
    );
  }
}

