import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';

class PdfReader extends StatelessWidget {
  final String url;
  const PdfReader({super.key, required this.url});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: const PDF().cachedFromUrl(url),
      ),
    );
  }
}
