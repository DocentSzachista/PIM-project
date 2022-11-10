import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TagList extends StatefulWidget {
  const TagList({Key? key, required this.tags}) : super(key: key);
  final List<dynamic> tags;
  @override
  State<TagList> createState() => _TagListState();
}

class _TagListState extends State<TagList> {
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text(AppLocalizations.of(context)!.tagTitle),
      widget.tags.isEmpty
          ? const SizedBox(
              height: 50,
            )
          : Wrap(
              spacing: 10,
              children: List.generate(
                  widget.tags.length,
                  (i) => Chip(
                        label: Text(widget.tags[i]),
                        deleteIconColor: Colors.red.shade50,
                        onDeleted: () {
                          setState(() {
                            widget.tags.removeAt(i);
                          });
                        },
                      )).toList()),
    ]);
  }
}
