import 'package:flutter/material.dart';
import 'package:flutter_framework/flutter_framework.dart';

import 'model/fauz_pdf.dart';

class AlFauzPDF extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color(0xff124570),
        centerTitle: true,
        title: const Text(
          'Al-Fauz',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            _juzList(context),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _juzList(BuildContext context) {
    return GridView.count(
      crossAxisSpacing: 8,
      mainAxisSpacing: 8,
      crossAxisCount: 2,
      shrinkWrap: true,
      childAspectRatio: 1.9,
      children: _fauzPDF.map((item) => _biildFauzPDF(item)).toList(),
    );
  }

  final _fauzPDF = [
    const FauzPdf(
      title: 'Juz 1',
      pdfUrl: 'http://arrahma.org/alfauz/juz1.pdf',
    ),
    const FauzPdf(
      title: 'Juz 1',
      pdfUrl: 'http://arrahma.org/alfauz/juz1.pdf',
    ),
    const FauzPdf(
      title: 'Juz 1',
      pdfUrl: 'http://arrahma.org/alfauz/juz1.pdf',
    ),
    const FauzPdf(
      title: 'Juz 1',
      pdfUrl: 'http://arrahma.org/alfauz/juz1.pdf',
    ),
    const FauzPdf(
      title: 'Juz 1',
      pdfUrl: 'http://arrahma.org/alfauz/juz1.pdf',
    ),
    const FauzPdf(
      title: 'Juz 1',
      pdfUrl: 'http://arrahma.org/alfauz/juz1.pdf',
    ),
    const FauzPdf(
      title: 'Juz 1',
      pdfUrl: 'http://arrahma.org/alfauz/juz1.pdf',
    ),
    const FauzPdf(
      title: 'Juz 1',
      pdfUrl: 'http://arrahma.org/alfauz/juz1.pdf',
    ),
    const FauzPdf(
      title: 'Juz 1',
      pdfUrl: 'http://arrahma.org/alfauz/juz1.pdf',
    ),
    const FauzPdf(
      title: 'Juz 1',
      pdfUrl: 'http://arrahma.org/alfauz/juz1.pdf',
    ),
  ];

  Widget _biildFauzPDF(FauzPdf item) {
    return GestureDetector(
      onTap: () => Launch.url(item.pdfUrl),
      child: Container(
        color: const Color(0xff124570),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              item.title,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
