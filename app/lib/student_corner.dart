import 'package:flutter/material.dart';

class StudentCorner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //AppBar -- Rending a navigation bae with title
        centerTitle: true,
        title: Text(
          'Student Corner',
          style: TextStyle(color: Colors.black),
        ),
      ),
    );
  }
}
