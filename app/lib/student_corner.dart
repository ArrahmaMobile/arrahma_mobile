import 'package:flutter/material.dart';
import 'main_drawer.dart';

class StudentCorner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MainDrawer(),
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
