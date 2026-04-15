import 'package:flutter/material.dart';
import 'package:medcare_app/general/components/custom_appbar.dart';
import 'package:pdfrx/pdfrx.dart';

class PdfPreviewScreen extends StatelessWidget {
  final String filePath;

  const PdfPreviewScreen({super.key, required this.filePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppbar(title: 'Preview Document'),
      // The "Lazy" Logic:
      // If it starts with 'assets/', use the asset loader.
      // Otherwise, treat it as a system file path.
      body: filePath.startsWith('assets/')
          ? PdfViewer.asset(filePath)
          : PdfViewer.file(filePath),
    );
  }
}
