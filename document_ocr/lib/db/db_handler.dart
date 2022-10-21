import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:document_ocr/db/document.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DbHandler {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final _userUID = FirebaseAuth.instance.currentUser != null
      ? FirebaseAuth.instance.currentUser!.uid
      : null;

  Future<void> addDocument(Document document) async {
    final doc = _db.collection("users").doc();
    document.id = doc.id;
    document.uuid = _userUID;
    await doc.set(document.toJSON());
  }

  Future<List<Document>> getDocument() async {
    QuerySnapshot documentsSnapshot = await _db.collection("users").get();
    final documents = documentsSnapshot.docs.map((object) {
      return Document.fromJson(object.data() as Map<String, dynamic>);
    }).toList();
    return documents;
  }
}
