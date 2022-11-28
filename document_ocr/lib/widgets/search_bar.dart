import 'package:flutter/material.dart';

import '../db/document.dart';
import 'document_tile.dart';

class DocumentSearchDelegate extends SearchDelegate{
  Future<List<Document>> documents;

  DocumentSearchDelegate({required this.documents});

  @override
  List<Widget>? buildActions(BuildContext context) =>[
    IconButton(
      onPressed: () {
        if (query.isEmpty){
          close(context, null);
        }
        query = "";
      },
      icon: const Icon(Icons.clear),
    )
  ];

  @override
  Widget? buildLeading(BuildContext context) => IconButton(
    onPressed: ()=>close(context, null),
    icon: const Icon(Icons.arrow_back),
  );

  @override
  Widget buildResults(BuildContext context) => FutureBuilder(
    future: documents,
    builder: ((context, snapshot) {
      if (!snapshot.hasData) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      } else {
        List<Document> docs = snapshot.data as List<Document>;
        docs = docs.where(
                (element) => element.name.contains(query)
                || element.tags.where(
                        (element) => element.contains(query)
                ).isNotEmpty
        ).toList();
        return ListView.builder(
          itemCount: docs.length,
          itemBuilder: ((context, index) {
            return DocumentTile(document: docs[index]);
          }),
        );
      }
    }),
  );

  @override
  Widget buildSuggestions(BuildContext context) =>Container();
}