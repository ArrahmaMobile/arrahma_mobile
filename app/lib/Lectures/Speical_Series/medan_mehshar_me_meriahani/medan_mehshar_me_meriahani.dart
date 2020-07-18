import 'package:flutter/material.dart';

class MedanMehsharMeMeriahani extends StatefulWidget {
  @override
  _MedanMehsharMeMeriahaniState createState() =>
      _MedanMehsharMeMeriahaniState();
}

class _MedanMehsharMeMeriahaniState extends State<MedanMehsharMeMeriahani> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          'Medan Mehshar Me Meriahani',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
    );
  }
}
