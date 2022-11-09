import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:document_ocr/db/document.dart' as api;

class PDFHandler {
  static Future<List<int>> generatePDF(api.Document textToGenerate) async {
    final pdf = Document();
    pdf.addPage(Page(build: (context) {
      return Text(textToGenerate.text);
    }));
    return await pdf.save();
    // final dir = await getApplicationDocumentsDirectory();
    // final file = File("${dir.path}/${textToGenerate.name}.pdf");
    // return file.writeAsBytes(await pdf.save());
  }
}
