import 'package:flutter/material.dart';

class MeriAakhri extends StatefulWidget {
  @override
  _MeriAakhriState createState() => _MeriAakhriState();
}

class _MeriAakhriState extends State<MeriAakhri> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          'Meri Aakhri',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }
}
