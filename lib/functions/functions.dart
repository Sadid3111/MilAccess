import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/document_item.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

void viewDocument(DocumentItem document, BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(
          title: Text(document.title),
          backgroundColor: Colors.green,
        ),
        body: SafeArea(
          child: SfPdfViewer.network(
            document.url,
            onDocumentLoaded: (details) {
              print('PDF loaded with ${details.document} pages');
            },
            onDocumentLoadFailed: (error) {
              print('Failed to load PDF: $error');
            },
          ),
        ),
      ),
    ),
  );
}

Future<void> changeStatus(
  String docId,
  String status, [
  String? remarks,
  String? ownerId,
]) async {
  try {
    if (status != 'Pending') {
      print(ownerId);
      await FirebaseFirestore.instance.collection('notifications').add({
        'content': 'Your document has been $status !',
        'createdAt': FieldValue.serverTimestamp(),
        'targetId': ownerId,
        'seen': false,
      });
    }
    print('next1-------------------------->');
    await FirebaseFirestore.instance.collection('files').doc(docId).update({
      'status': status,
      'remarks': remarks,
    });
    print('next1-------------------------->');
  } catch (e) {
    print('Upload error: $e');
  }
}
