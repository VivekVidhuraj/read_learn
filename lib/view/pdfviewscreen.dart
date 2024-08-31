import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

class PdfViewerScreen extends StatefulWidget {
  final String pdfUrl;

  PdfViewerScreen({required this.pdfUrl});

  @override
  _PdfViewerScreenState createState() => _PdfViewerScreenState();
}

class _PdfViewerScreenState extends State<PdfViewerScreen> {
  String? _pdfPath;

  @override
  void initState() {
    super.initState();
    _downloadAndSavePdf();
  }

  Future<void> _downloadAndSavePdf() async {
    try {
      final response = await http.get(Uri.parse(widget.pdfUrl));
      if (response.statusCode == 200) {
        final Uint8List pdfData = response.bodyBytes;
        final directory = await getApplicationDocumentsDirectory();
        final filePath = '${directory.path}/temp.pdf';
        final file = File(filePath);
        await file.writeAsBytes(pdfData);
        setState(() {
          _pdfPath = filePath;
        });
      } else {
        throw Exception('Failed to load PDF');
      }
    } catch (e) {
      print('Error downloading or saving PDF: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'PDF Viewer',
          style: TextStyle(color: Colors.white), // Set title text color to white
        ),
        backgroundColor: const Color(0xFF0A0E21),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white), // Set icon color to white
      ),
      body: _pdfPath == null
          ? const Center(child: CircularProgressIndicator())
          : PDFView(
        filePath: _pdfPath,
      ),
    );
  }
}
