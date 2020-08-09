import 'package:flutter/material.dart';

class QuranDetailsTab extends StatefulWidget {
  const QuranDetailsTab({Key key, @required this.title}) : super(key: key);
  final String title;

  @override
  _QuranDetailsTabState createState() => _QuranDetailsTabState();
}

class _QuranDetailsTabState extends State<QuranDetailsTab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: const Color(0xff124570),
        centerTitle: true,
        title: Text(
          widget.title,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
