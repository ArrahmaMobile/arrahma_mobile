import 'package:flutter/material.dart';

class QuranDetailsTab extends StatefulWidget {
  const QuranDetailsTab({Key key, @required this.pdfUrl, @required this.title})
      : super(key: key);
  final String title;
  final String pdfUrl;

  @override
  _QuranDetailsTabState createState() => _QuranDetailsTabState();
}

class _QuranDetailsTabState extends State<QuranDetailsTab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          widget.title,
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
