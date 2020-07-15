import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'model/fauz_pdf.dart';

class AlFauzPDF extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          'Al-Fauz',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(10.0),
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
      children:
          _fauzPDF.map((item) => _biildFauzPDF(item, item.pdfUrl)).toList(),
    );
  }

  final _fauzPDF = [
    FauzPDF(
      title: 'Juz 1',
      pdfUrl: 'http://arrahma.org/alfauz/juz1.pdf',
    ),
    FauzPDF(
      title: 'Juz 1',
      pdfUrl: 'http://arrahma.org/alfauz/juz1.pdf',
    ),
    FauzPDF(
      title: 'Juz 1',
      pdfUrl: 'http://arrahma.org/alfauz/juz1.pdf',
    ),
    FauzPDF(
      title: 'Juz 1',
      pdfUrl: 'http://arrahma.org/alfauz/juz1.pdf',
    ),
    FauzPDF(
      title: 'Juz 1',
      pdfUrl: 'http://arrahma.org/alfauz/juz1.pdf',
    ),
    FauzPDF(
      title: 'Juz 1',
      pdfUrl: 'http://arrahma.org/alfauz/juz1.pdf',
    ),
    FauzPDF(
      title: 'Juz 1',
      pdfUrl: 'http://arrahma.org/alfauz/juz1.pdf',
    ),
    FauzPDF(
      title: 'Juz 1',
      pdfUrl: 'http://arrahma.org/alfauz/juz1.pdf',
    ),
    FauzPDF(
      title: 'Juz 1',
      pdfUrl: 'http://arrahma.org/alfauz/juz1.pdf',
    ),
    FauzPDF(
      title: 'Juz 1',
      pdfUrl: 'http://arrahma.org/alfauz/juz1.pdf',
    ),
  ];

  Widget _biildFauzPDF(item, pdfUrl) {
    return GestureDetector(
      onTap: () => _launchLink(pdfUrl),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            item.title,
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ],
      ),
    );
  }

  _launchLink(String pdfUrl) async {
    if (await canLaunch(pdfUrl)) {
      await launch(pdfUrl);
    } else {
      throw 'Could not launch $pdfUrl';
    }
  }

  // _juz1() async {
  //   const url = 'http://arrahma.org/alfauz/juz1.pdf';
  //   if (await canLaunch(url)) {
  //     await launch(url);
  //   } else {
  //     throw 'Could not launch $url';
  //   }
  // }

  // _juz2() async {
  //   const url = 'http://arrahma.org/alfauz/juz2.pdf';
  //   if (await canLaunch(url)) {
  //     await launch(url);
  //   } else {
  //     throw 'Could not launch $url';
  //   }
  // }

  // _juz3() async {
  //   const url = 'http://arrahma.org/alfauz/juz3.pdf';
  //   if (await canLaunch(url)) {
  //     await launch(url);
  //   } else {
  //     throw 'Could not launch $url';
  //   }
  // }

  // _juz4() async {
  //   const url = 'http://arrahma.org/alfauz/juz4.pdf';
  //   if (await canLaunch(url)) {
  //     await launch(url);
  //   } else {
  //     throw 'Could not launch $url';
  //   }
  // }

  // _juz5() async {
  //   const url = 'http://arrahma.org/alfauz/juz5.pdf';
  //   if (await canLaunch(url)) {
  //     await launch(url);
  //   } else {
  //     throw 'Could not launch $url';
  //   }
  // }

  // _juz6() async {
  //   const url = 'http://arrahma.org/alfauz/juz6.pdf';
  //   if (await canLaunch(url)) {
  //     await launch(url);
  //   } else {
  //     throw 'Could not launch $url';
  //   }
  // }

  // _juz7() async {
  //   const url = 'http://arrahma.org/alfauz/juz7.pdf';
  //   if (await canLaunch(url)) {
  //     await launch(url);
  //   } else {
  //     throw 'Could not launch $url';
  //   }
  // }

  // _juz8() async {
  //   const url = 'http://arrahma.org/alfauz/juz8.pdf';
  //   if (await canLaunch(url)) {
  //     await launch(url);
  //   } else {
  //     throw 'Could not launch $url';
  //   }
  // }

  // _juz9() async {
  //   const url = 'http://arrahma.org/alfauz/juz9.pdf';
  //   if (await canLaunch(url)) {
  //     await launch(url);
  //   } else {
  //     throw 'Could not launch $url';
  //   }
  // }

  // _juz10() async {
  //   const url = 'http://arrahma.org/alfauz/juz10.pdf';
  //   if (await canLaunch(url)) {
  //     await launch(url);
  //   } else {
  //     throw 'Could not launch $url';
  //   }
  // }
}
