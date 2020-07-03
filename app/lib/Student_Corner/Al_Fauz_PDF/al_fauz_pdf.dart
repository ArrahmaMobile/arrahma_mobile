import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AlFauzPDF extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //AppBar -- Rending a navigation bae with title
        centerTitle: true,
        title: Text(
          'Al-Fauz',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: [
            _juzList(context),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _juzList(BuildContext context) {
    return GridView.count(
      crossAxisSpacing: 8,
      mainAxisSpacing: 8,
      crossAxisCount: 2,
      shrinkWrap: true,
      childAspectRatio: 1.9,
      children: <Widget>[
        GestureDetector(
          onTap: _juz1,
          child: Container(
            color: Color(0xffdedbdb),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Juz 1',
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
          onTap: _juz2,
          child: Container(
            color: Color(0xffdedbdb),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Juz 2',
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
          onTap: _juz3,
          child: Container(
            color: Color(0xffdedbdb),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Juz 3',
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
          onTap: _juz4,
          child: Container(
            color: Color(0xffdedbdb),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Juz 4',
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
          onTap: _juz5,
          child: Container(
            color: Color(0xffdedbdb),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Juz 5',
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
          onTap: _juz6,
          child: Container(
            color: Color(0xffdedbdb),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Juz 6',
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
          onTap: _juz7,
          child: Container(
            color: Color(0xffdedbdb),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Juz 7',
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
          onTap: _juz8,
          child: Container(
            color: Color(0xffdedbdb),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Juz 8',
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
          onTap: _juz9,
          child: Container(
            color: Color(0xffdedbdb),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Juz 9',
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
          onTap: _juz10,
          child: Container(
            color: Color(0xffdedbdb),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Juz 10',
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

  _juz1() async {
    const url = 'http://arrahma.org/alfauz/juz1.pdf';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _juz2() async {
    const url = 'http://arrahma.org/alfauz/juz2.pdf';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _juz3() async {
    const url = 'http://arrahma.org/alfauz/juz3.pdf';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _juz4() async {
    const url = 'http://arrahma.org/alfauz/juz4.pdf';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _juz5() async {
    const url = 'http://arrahma.org/alfauz/juz5.pdf';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _juz6() async {
    const url = 'http://arrahma.org/alfauz/juz6.pdf';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _juz7() async {
    const url = 'http://arrahma.org/alfauz/juz7.pdf';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _juz8() async {
    const url = 'http://arrahma.org/alfauz/juz8.pdf';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _juz9() async {
    const url = 'http://arrahma.org/alfauz/juz9.pdf';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _juz10() async {
    const url = 'http://arrahma.org/alfauz/juz10.pdf';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
