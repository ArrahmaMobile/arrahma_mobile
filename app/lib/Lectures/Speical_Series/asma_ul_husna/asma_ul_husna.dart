import 'package:flutter/material.dart';

class AsmaUlHusna extends StatefulWidget {
  @override
  AasmUlHusnaState createState() => AasmUlHusnaState();
}

class AasmUlHusnaState extends State<AsmaUlHusna> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          'Asma ul Husna',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }
}
