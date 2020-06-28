import 'package:flutter/material.dart';
import 'main_drawer.dart';

class ReadingMaterial extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MainDrawer(),
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
