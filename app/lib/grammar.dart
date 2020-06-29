import 'package:flutter/material.dart';

class Grammer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //AppBar -- Rending a navigation bae with title
        centerTitle: true,
        title: Text(
          'Grammer',
          style: TextStyle(color: Colors.black),
        ),
      ),
    );
  }
}
