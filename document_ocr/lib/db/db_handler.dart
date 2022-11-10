import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:document_ocr/db/document.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class DbHandler {
  final ref = FirebaseStorage.instance.ref();
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final _userUID = FirebaseAuth.instance.currentUser != null
      ? FirebaseAuth.instance.currentUser!.uid
      : null;

  Future<bool> addDocument(Document document) async {
    try {
      final doc = _db.collection("users").doc();
      document.id = doc.id;
      document.uuid = _userUID;
      await doc.set(document.toJSON());
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<String> uploadFile(XFile file) async {
    final imagesRef = ref.child("images/${file.name}");
    await imagesRef.putFile(File(file.path));
    return await imagesRef.getDownloadURL();
  }

  Future<List<Document>> getDocument() async {
    QuerySnapshot documentsSnapshot = await _db.collection("users").get();
    final documents = documentsSnapshot.docs.map((object) {
      return Document.fromJson(object.data() as Map<String, dynamic>);
    }).toList();
    return documents;
  }
}
