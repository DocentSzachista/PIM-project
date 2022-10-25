import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:textfield_tags/textfield_tags.dart';
class AddDocument extends StatefulWidget {
  const AddDocument({Key? key}) : super(key: key);

  @override
  State<AddDocument> createState() => _AddDocumentState();
}

class _AddDocumentState extends State<AddDocument> {

  final List<String> _tags = [];
  String recognizedText = " ";
  late XFile? imageFile = null;

  void retrieveImage (ImageSource source) async{
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
    }
    setState(() {});
  }

  Widget _imageContainer() => SizedBox(
    width: 300,
    height: 300,
    child: Container(
      color: Colors.grey.shade300,
    ),
  );

  Widget _button(String text, ImageSource source) => TextButton(
      style: ButtonStyle(
        backgroundColor: MaterialStatePropertyAll<Color>(Colors.grey.shade400),
      ),
      onPressed: (){
        retrieveImage(source);
      },
      child: Text(text));

  Widget _buttonsRow() => Row(
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    children: [
      _button("Wybierz z galerii", ImageSource.gallery),
      _button("Zrób zdjęcie", ImageSource.camera)
    ],
  );


  Widget _generatedTextArea(BuildContext context) => TextFormField(
    initialValue:
    "Lorem ipsum Lorem Ipsum Lorem ipsum Lorem Ipsum Lorem ipsum Lorem Ipsum "
        "Lorem ipsum Lorem Ipsum Lorem ipsum Lorem"
        "Ipsum Lorem ipsum Lorem Ipsum Lorem ipsum Lorem Ipsum Lorem ipsum Lorem"
        "Ipsum Lorem ipsum Lorem Ipsum Lorem ipsum Lorem Ipsum ",
    maxLines: 4,
    scrollController: ScrollController(),
    decoration:  InputDecoration(
      border: const OutlineInputBorder(),
      hintText: "Here will appear recognized text.",
      hintStyle: Theme.of(context).textTheme.bodyMedium
    ),
  );

  // Widget _tagsTextField() => TextFieldTags(
  //     tagsStyler: TagsStyler(
  //       tagDecoration: BoxDecoration(
  //         color: Colors.blueGrey.shade200
  //       ),
  //       tagPadding: EdgeInsets.all(6),
  //       tagCancelIcon: Icon(Icons.cancel, color: Colors.black,)
  //     ),
  //     textFieldStyler: TextFieldStyler(),
  //     onTag: (tag){
  //       _tags.add(tag);
  //     },
  //     onDelete: (tag){
  //       _tags.remove(tag);
  //     },
  //     validator: (tag){
  //       if(tag.length < 4)
  //         return "Tag must be at least 4 letters long";
  //       return null;
  //     } ,
  //     );

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        child: SingleChildScrollView( child: Center(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              imageFile == null ? _imageContainer() : Image.file(File(imageFile!.path), width:  300, height: 300,),
              _buttonsRow(),
              Divider(
                height: 30,
                // color: Colors.teal,
                thickness: 5.0,
              ),
              _generatedTextArea(context),
              Divider(
                // color: Colors.teal.shade200,
                thickness: 5.0,
              ),
              // _tagsTextField(),

              ElevatedButton(onPressed: () {}, child: Text("Dodaj dokument")),

            ],
          ),
        ))) ;
  }
}
