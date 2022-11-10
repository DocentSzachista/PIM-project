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
    // function tries to pick image from gallery and later invokes function
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
          width: 300,
          height: 300,
          child: Container(
            color: Colors.grey.shade300,
            child: Center(
              child: Text(AppLocalizations.of(context)!.chooseImageTooltip),
            ),
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
        decoration: InputDecoration(
          labelText: AppLocalizations.of(context)!.documentTitleLabel,
          border: const OutlineInputBorder(),
        ),
      );
  SnackBar _snackBar() => const SnackBar(
        content: Text('Done'),
        backgroundColor: Colors.blueGrey,
        duration: Duration(seconds: 3),
      );

  Widget _submitButton(BuildContext context) => ElevatedButton(
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
      child: Text(AppLocalizations.of(context)!.addDocument));

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        child: SingleChildScrollView(
            child: Center(
                child: Form(
          key: _key,
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _imageContainer(),
              _buttonsRow(context),
              const Divider(
                height: 30,
                thickness: 5.0,
              ),
              _documentTitle(),
              const Divider(
                height: 30,
              ),
              MyTextField(
                controller: controllerTextEditing,
              ),
              // _generatedTextArea(context),
              const Divider(
                thickness: 5.0,
              ),
              TagList(tags: _tags),
              _tagsTextField(context),
              _submitButton(context)
            ],
          ),
        ))));
  }
}
