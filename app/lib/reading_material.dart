import 'package:flutter/material.dart';

class ReadingMaterial extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //AppBar -- Rending a navigation bae with title
        centerTitle: true,
        title: Text(
          'Reading Material',
          style: TextStyle(color: Colors.black),
        ),
      ),
    );
  }
}
