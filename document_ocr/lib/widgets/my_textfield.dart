import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MyTextField extends StatefulWidget {
  const MyTextField({Key? key, required this.controller}) : super(key: key);
  final TextEditingController controller;
  @override
  State<MyTextField> createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  @override
  Widget build(BuildContext context) => Column(children: [
        Text(AppLocalizations.of(context)!.textfieldTooltip),
        TextFormField(
          maxLines: 4,
          controller: widget.controller,
          scrollController: ScrollController(),
          decoration: InputDecoration(
              border: const OutlineInputBorder(),
              hintText: "Here will appear recognized text.",
              hintStyle: Theme.of(context).textTheme.bodyMedium),
        )
      ]);
}
