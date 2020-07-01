import 'package:dropdownfield/dropdownfield.dart';
import 'package:flutter/material.dart';

class AdvTaleemmulQuran extends StatefulWidget {
  @override
  _AdvTaleemmulQuranState createState() => _AdvTaleemmulQuranState();
}

class _AdvTaleemmulQuranState extends State<AdvTaleemmulQuran> {
  int _currentIndex = 2;

  Widget _headingTitle = Container(
    margin: const EdgeInsets.all(20.0),
    decoration: BoxDecoration(
      border: Border(
        top: BorderSide(color: Colors.black),
        bottom: BorderSide(color: Colors.black),
      ),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            'Tafseer',
            style: TextStyle(
                color: Color(0xff808080),
                fontWeight: FontWeight.bold,
                fontSize: 30.0),
          ),
        )
      ],
    ),
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Adv Taleemmul Quran',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: ListView(
        children: <Widget>[
          _headingTitle,
          SizedBox(
            height: 20.0,
          ),
          Text('hello'),
          DropDownField(
            controller: juzSlected,
            hintText: 'Select a Juzs',
            enabled: true,
            items: juzs,
            onValueChanged: (value) {
              setState(() {
                selectJuz = value;
              });
            },
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.library_books),
              title: Text('Details'),
              backgroundColor: Colors.blue),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            title: Text('Registration'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Tafseer'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Tajweed'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Tests'),
          ),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}

String selectJuz = "";

final juzSlected = TextEditingController();

List<String> juzs = [
  "juz1",
  "juz2",
  "juz3",
  "juz4",
];
