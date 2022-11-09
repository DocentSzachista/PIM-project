import 'package:document_ocr/db/document.dart';
import 'package:document_ocr/provider/google_sign_in.dart';
import 'package:document_ocr/widgets/my_textfield.dart';
import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ShareDocumentWidget extends StatefulWidget {
  const ShareDocumentWidget({Key? key, required this.document})
      : super(key: key);
  final Document document;
  @override
  State<ShareDocumentWidget> createState() => _ShareDocumentWidgetState();
}

class _ShareDocumentWidgetState extends State<ShareDocumentWidget> {
  TextEditingController controllerTextEditing = TextEditingController();
  @override
  void initState() {
    controllerTextEditing.text = widget.document.text;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Nazwa dokumentu: ${widget.document.name}",
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ],
          ),
        ),
        MyTextField(
          controller: controllerTextEditing,
        ),
        Center(
            child: ElevatedButton(
                onPressed: () async {
                  bool succeed = false;
                  widget.document.text = controllerTextEditing.text;
                  try {
                    await GoogleSignInProvider()
                        .uploadToFolder(widget.document);
                    succeed = true;
                  } catch (e) {}
                  showCupertinoDialog(
                      context: context,
                      builder: (context) {
                        return CupertinoAlertDialog(
                          title: Text(succeed
                              ? AppLocalizations.of(context)!.popUpSuccess
                              : AppLocalizations.of(context)!.popUpFail),
                          actions: [
                            CupertinoDialogAction(
                              child: const Text("Ok"),
                              onPressed: () {
                                Navigator.of(context)
                                    .popUntil((router) => router.isFirst);
                              },
                            )
                          ],
                        );
                      });
                },
                child: Text(AppLocalizations.of(context)!.shareDocumentButton)))
      ],
    );
  }
}
