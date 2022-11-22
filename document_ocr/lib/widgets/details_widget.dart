import 'package:document_ocr/db/db_handler.dart';
import 'package:document_ocr/db/document.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DetailsWidget extends StatefulWidget {
  const DetailsWidget({Key? key, required this.document}) : super(key: key);
  final Document document;
  @override
  State<DetailsWidget> createState() => _DetailsWidgetState();
}

class _DetailsWidgetState extends State<DetailsWidget> {
  Image? _image;
  final DbHandler db = DbHandler();
  final controllerTextEditing = TextEditingController();
  final controllerTagsText = TextEditingController();

  @override
  void initState() {
    super.initState();
    _image = Image.network(
      widget.document.imageURL,
      fit: BoxFit.fill,
    );
    controllerTextEditing.text = widget.document.text;
    controllerTagsText.text = widget.document.tags.join(";");
  }

  void _updateDocument() async {
    widget.document.text = controllerTextEditing.text;
    widget.document.tags = controllerTagsText.text.split(";");
    await db.updateDocument(widget.document);
    setState(() {});

  }

  Widget _imageContainer() => SizedBox(
        width: 300,
        height: 300,
        child: Container(
            // color: Colors.grey.shade300,
            child: _image),
      );
  Widget _editRow(BuildContext context, String rowText,
          TextEditingController controller) =>
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(rowText),
          TextButton(
              onPressed: () {
                _openTagsDialog(context, rowText, controller, () {
                  _updateDocument();
                });
              },
              child: Text("edit"),
              style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40.0),
                          side: BorderSide()))))
        ],
      );
  Future _openTagsDialog(BuildContext context, String fieldName,
          TextEditingController controller, Function onClickAction,
          {bool multilineInput = false}) =>
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text("Edit $fieldName"),
                content: TextField(
                  controller: controller,
                  decoration: InputDecoration(hintText: "Edit your tags"),
                  maxLines: multilineInput ? 5 : 1,
                  onSubmitted: (text) {
                    if (text.isNotEmpty) {
                      controller.text = text;
                      setState(() {});
                    }
                  },
                ),
                actions: [
                  TextButton(
                      onPressed: () {
                        onClickAction();
                      },
                      child: Text("Submit"))
                ],
              ));

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
        child: SingleChildScrollView(
            child: Center(
                child: Column(
          children: [
            _imageContainer(),
            _editRow(context, AppLocalizations.of(context)!.tagTitle,
                controllerTagsText),
            Wrap(
                children: List.generate(
                        widget.document.tags.length,
                        (index) =>
                            Chip(label: Text(widget.document.tags[index])))
                    .toList()),
            _editRow(context, "Treść dokumentu", controllerTextEditing),
            Text(controllerTextEditing.text)
          ],
        ))));
  }
}
