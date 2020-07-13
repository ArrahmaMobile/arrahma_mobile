import 'package:flutter/material.dart';

class AdvTaleemmulQuranDetailsTab extends StatefulWidget {
  @override
  _AdvTaleemmulQuranDetailsTabState createState() =>
      _AdvTaleemmulQuranDetailsTabState();
}

class _AdvTaleemmulQuranDetailsTabState
    extends State<AdvTaleemmulQuranDetailsTab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: Text(
          'Course Detail',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
