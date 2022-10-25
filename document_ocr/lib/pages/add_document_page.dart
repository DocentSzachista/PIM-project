import 'package:document_ocr/widgets/add_document_widget.dart';
import 'package:flutter/material.dart';

class AddDocumentPage extends StatelessWidget {
  const AddDocumentPage({Key? key}) : super(key: key);

  Widget _imageContainer() => SizedBox(
        width: 300,
        height: 300,
        child: Container(
          color: Colors.grey.shade300,
        ),
      );

  Widget _button(String text) => TextButton(
      style: ButtonStyle(
        backgroundColor: MaterialStatePropertyAll<Color>(Colors.grey.shade400),
      ),
      onPressed: () {},
      child: Text(text));

  Widget _buttonsRow() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [_button("Wybierz z galerii"), _button("Zrób zdjęcie")],
      );

  Widget _generatedTextArea() => TextFormField(
        initialValue:
            "Lorem ipsum Lorem Ipsum Lorem ipsum Lorem Ipsum Lorem ipsum Lorem Ipsum Lorem ipsum Lorem Ipsum Lorem ipsum Lorem Ipsum Lorem ipsum Lorem Ipsum Lorem ipsum Lorem Ipsum Lorem ipsum Lorem Ipsum Lorem ipsum Lorem Ipsum Lorem ipsum Lorem Ipsum ",
        maxLines: 4,
        scrollController: ScrollController(),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AddDocument()
    );
  }
}
