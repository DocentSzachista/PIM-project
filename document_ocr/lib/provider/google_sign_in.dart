import 'package:document_ocr/db/document.dart';
import 'package:document_ocr/db/pdf_handler.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
class GoogleSignInProvider extends ChangeNotifier {
  final googleSignIn = GoogleSignIn( scopes: [
    drive.DriveApi.driveAppdataScope,
    drive.DriveApi.driveFileScope,
  ]);

  GoogleSignInAccount? _user;
  GoogleSignInAccount get user => _user!;

  Future googleLogin() async {
    final googleUser = await googleSignIn.signIn();
    if (googleUser == null) return;

    final googleAuth = await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

    await FirebaseAuth.instance.signInWithCredential(credential);
    notifyListeners();
  }

  Future logout() async {
    await googleSignIn.disconnect();
    FirebaseAuth.instance.signOut();
  }

  Future<void> uploadToFolder(Document document) async {
    try {
      final driveApi = await _getDriveApi();
      if (driveApi == null) {
        return;
      }
      final folderId = await _getFolderId(driveApi);
      if (folderId == null) {
        //throw exception instead
        // await showMessage(context, "Failure", "Error");
        return;
      }

      // Create data here instead of loading a file
      List<int> bytesList = await PDFHandler.generatePDF(document);
      final Stream<List<int>> mediaStream =
      Future.value(bytesList).asStream().asBroadcastStream();
      var media = drive.Media(mediaStream, bytesList.length);

      // Set up File info
      var driveFile = drive.File();
      final timestamp = DateFormat("yyyy-MM-dd-hhmmss").format(DateTime.now());
      driveFile.name = "${document.name}-$timestamp.pdf";
      driveFile.modifiedTime = DateTime.now().toUtc();
      driveFile.parents = [folderId];

      // Upload
      final response =
      await driveApi.files.create(driveFile, uploadMedia: media);
      print("response: $response");

      // simulate a slow process
      await Future.delayed(Duration(seconds: 2));
    }finally{

    }
  }
  Future<drive.DriveApi?> _getDriveApi() async {
    final googleUser = await googleSignIn.signIn();
    final headers = await googleUser?.authHeaders;
    if (headers == null) {
      // await showMessage(context, "Sign-in first", "Error");
      return null;
    }
    //handle here call to api
    final client = GoogleAuthClient(headers);
    final driveApi = drive.DriveApi(client);
    return driveApi;
  }

  Future<String?> _getFolderId(drive.DriveApi driveApi) async {
    const mimeType = "application/vnd.google-apps.folder";
    String folderName = "document_ocr";

    try {
      final found = await driveApi.files.list(
        q: "mimeType = '$mimeType' and name = '$folderName'",
        $fields: "files(id, name)",
      );
      final files = found.files;
      if (files == null) {
        return null;
      }

      if (files.isNotEmpty) {
        return files.first.id;
      }

      // Create a folder
      var folder = drive.File();
      folder.name = folderName;
      folder.mimeType = mimeType;
      final folderCreation = await driveApi.files.create(folder);

      return folderCreation.id;
    } catch (e) {
      print(e);
      return null;
    }
  }


}

class GoogleAuthClient extends http.BaseClient {
  final Map<String, String> _headers;
  final _client = http.Client();

  GoogleAuthClient(this._headers);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    request.headers.addAll(_headers);
    return _client.send(request);
  }
}
