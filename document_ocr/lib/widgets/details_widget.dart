import 'package:document_ocr/db/db_handler.dart';
import 'package:document_ocr/db/document.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:document_ocr/pages/share_page.dart';

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
          TextEditingController controller,
          {bool multilineInput = false}) =>
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child:Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(rowText,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            TextButton(
              onPressed: () {
                _openTagsDialog(context, rowText, controller, () {
                  _updateDocument();
                }, multilineInput);
              },
              style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40.0),
                          side: const BorderSide()))),
              child: Text(AppLocalizations.of(context)!.editText),
            )
          ],
        ),
      ),);

  Future _openTagsDialog(
          BuildContext context,
          String fieldName,
          TextEditingController controller,
          Function onClickAction,
          bool multilineInput) =>
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text(
                    "${AppLocalizations.of(context)!.editText} $fieldName"),
                content: TextField(
                  controller: controller,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  maxLines:
                      multilineInput ? (controller.text.length / 5).round() : 1,
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
                      child: Text(AppLocalizations.of(context)!.editSubmit))
                ],
              ));
  Widget _roundedThing() => Container(
        padding: const EdgeInsets.only(
          top: 40,
          left: 20,
          right: 20,
        ),
        decoration: const BoxDecoration(
          boxShadow: [BoxShadow(color: Colors.white24, spreadRadius: 5)],
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(80),
            topRight: Radius.circular(80),
          ),
          color: Colors.white,
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: _imageContainer(),
        ),
        _roundedThing(),
        Expanded(
          child: Container(
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _editRow(context, AppLocalizations.of(context)!.tagTitle,
                    controllerTagsText),
                Center( child: Wrap(
                    children: List.generate(
                            widget.document.tags.length,
                            (index) =>
                                Chip(label: Text(widget.document.tags[index])))
                        .toList()),),
                _editRow(context, "Treść dokumentu", controllerTextEditing,
                    multilineInput: true),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child:
                  SingleChildScrollView(child:Text(controllerTextEditing.text,),),
                ),
                Center( child:SizedBox(
                    width: 200,
                    child: TextButton(
                        style: TextButton.styleFrom(
                            foregroundColor: Colors.black,
                            backgroundColor: Colors.lightBlue),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SharePage(
                                        document: widget.document,
                                      )));
                        },
                        child: Text(AppLocalizations.of(context)!
                            .shareDocumentButton),),),),
              ],
            ),
          ),
        ),
      ],
    ));
  }
}
