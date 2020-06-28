import 'package:arrahma_mobile_app/main_drawer.dart';
import 'package:flutter/material.dart';

class AboutUs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MainDrawer(),
      appBar: AppBar(
        //AppBar -- Rending a navigation bae with title
        centerTitle: true,
        title: Text(
          'About us',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'About ArRahmah',
              style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            Text(
              'ArRahmah started its online journey in 2007 from New Jersey, USA and provided weekly Tarjuma, Tafseer and Tajweed classes.'
              'It initially catered to the needs of sisters in the area and neighboring states but by the special blessing of Allah swt we now serve students globally.'
              'All our humble efforts are only for seeking the pleasure of Allah SWT so each person in Arrahma whether teacher,administration or helpers are all working Fi Sabil Lillah.'
              'Classes here are offered absolutely FREE. We only ask for your time, dedication and duas.',
            ),
            SizedBox(height: 10),
            Text(
              "Teacher's Profile",
              style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            Text(
              'ArRahmah started its online journey in 2007 from New Jersey,'
              'USA and provided weekly Tarjuma, Tafseer and Tajweed classes.'
              'It initially catered to the needs of sisters in the area and neighboring states but by the special blessing of Allah swt we now serve students globally.'
              'All our humble efforts are only for seeking the pleasure of Allah SWT so each person in Arrahma whether teacher,'
              'administration or helpers are all working Fi Sabil Lillah. Classes here are offered absolutely FREE. We only ask for your time, dedication and duas.',
            ),
            SizedBox(height: 10),
            Text(
              "خیركم من تعلم القرآن وعلمه",
              textAlign: TextAlign.center,
              style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
