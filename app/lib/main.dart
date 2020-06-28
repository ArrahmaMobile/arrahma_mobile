import 'package:arrahma_mobile_app/main_drawer.dart';
import 'package:flutter/material.dart';

main() {
  runApp(
    MaterialApp(
      //using materialApp -- instantitiing widgets and passing parameters
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          color: Colors.white,
          iconTheme: IconThemeData(color: Colors.black),
        ),
      ),
      home: Scaffold(
        //scafford -- presents a screen to the user
        drawer: MainDrawer(),
        appBar: AppBar(
          centerTitle: true,
          //AppBar -- Rending a navigation bae with title
          title: Image.asset('assets/images/AarhmanMainImage.png',
              fit: BoxFit.cover),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Flexible(
              child: Container(
                padding: EdgeInsets.all(40.0),
                color: Colors.lightBlue,
                child: Text('MIXLR LIVE'),
              ),
            ),
            Container(
              padding: EdgeInsets.all(40.0),
              color: Colors.lightBlue,
              child: Text('MIXLR LIVE'),
            ),
            Container(
              padding: EdgeInsets.all(40.0),
              color: Colors.lightBlue,
              child: Text('MIXLR LIVE'),
            ),
            Container(
              padding: EdgeInsets.all(40.0),
              color: Colors.lightBlue,
              child: Text('MIXLR LIVE'),
            ),
            Container(
              padding: EdgeInsets.all(40.0),
              color: Colors.lightBlue,
              child: Text('MIXLR LIVE'),
            ),
          ],
        ),
      ),
    ),
  );
}
