import 'package:flutter/material.dart';

class SpecialSeries extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Speical Series',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: [
            _specialSeriesList(context),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _specialSeriesList(BuildContext context) {
    return GridView.count(
      crossAxisSpacing: 8,
      mainAxisSpacing: 8,
      crossAxisCount: 2,
      shrinkWrap: true,
      childAspectRatio: 1,
      children: <Widget>[
        GestureDetector(
          child: Container(
            color: Color(0xffdedbdb),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Gumnaam Ki Diary',
                  style:
                      TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
                ),
                Icon(
                  Icons.access_alarm,
                  size: 50,
                ),
              ],
            ),
          ),
        ),
        GestureDetector(
          child: Container(
            color: Color(0xffdedbdb),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Medan - Mehshar Mr Meri Kahani',
                  style:
                      TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
                ),
                Icon(
                  Icons.access_alarm,
                  size: 50,
                ),
              ],
            ),
          ),
        ),
        GestureDetector(
          child: Container(
            color: Color(0xffdedbdb),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Meri Aakhari Saansain',
                  style:
                      TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
                ),
                Icon(
                  Icons.access_alarm,
                  size: 50,
                ),
              ],
            ),
          ),
        ),
        GestureDetector(
          child: Container(
            color: Color(0xffdedbdb),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Asma ul Husna',
                  style:
                      TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
                ),
                Icon(
                  Icons.access_alarm,
                  size: 50,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
