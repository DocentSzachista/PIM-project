import 'package:flutter/material.dart';

class MyCheckbox extends StatefulWidget {
  MyCheckbox({Key? key, required this.title}) : super(key: key);
  final String title;
  bool _value = false;
  bool get value => _value;
  @override
  State<MyCheckbox> createState() => _MyCheckboxState();
}

class _MyCheckboxState extends State<MyCheckbox> {
  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
        controlAffinity: ListTileControlAffinity.leading,
        title: Text(
          widget.title,
        ),
        value: widget._value,
        onChanged: (checked) {
          setState(() {
            widget._value = checked!;
          });
        });
  }
}
