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
  Widget build(BuildContext context) => TextFormField(
        maxLines: 4,
        controller: widget.controller,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return AppLocalizations.of(context)!.invalidRecognized;
          }
          return null;
        },
        scrollController: ScrollController(),
        decoration: InputDecoration(
            labelText: AppLocalizations.of(context)!.textfieldTooltip,
            border: const OutlineInputBorder(),
            hintStyle: Theme.of(context).textTheme.bodyMedium),
      );
}
