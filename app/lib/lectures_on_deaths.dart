import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class LecturesOnDeath extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //AppBar -- Rending a navigation bae with title
        centerTitle: true,
        title: Text(
          'Lectures on Deaths',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: [
            _lecturesList(context),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _lecturesList(BuildContext context) {
    return GridView.count(
      crossAxisSpacing: 30,
      mainAxisSpacing: 50,
      crossAxisCount: 2,
      shrinkWrap: true,
      childAspectRatio: 1.8,
      children: <Widget>[
        GestureDetector(
          onTap: _willForm,
          child: Container(
            color: Colors.white,
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(width: 2, color: Colors.black)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  new Container(
                    child: Image.asset(
                        'assets/images/lectures_on_deaths/will_form.jpg',
                        height: 75.0,
                        fit: BoxFit.cover),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: Color(0xff133a63),
                        border: Border.all(color: Colors.black)),
                    child: Text(
                      'Will Form',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: _duaForJanaza,
          child: Container(
            color: Colors.white,
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(width: 2, color: Colors.black)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  new Container(
                    child: Image.asset(
                        'assets/images/lectures_on_deaths/dua_for_janaza.jpg',
                        height: 75.0,
                        fit: BoxFit.cover),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: Color(0xff133a63),
                        border: Border.all(color: Colors.black)),
                    child: Text(
                      'Dua for Janaza',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: _audioLecture,
          child: Container(
            color: Colors.white,
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(width: 2, color: Colors.black)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  new Container(
                    child: Image.asset(
                        'assets/images/lectures_on_deaths/audio_lecture.jpeg',
                        height: 75.0,
                        fit: BoxFit.cover),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: Color(0xff133a63),
                        border: Border.all(color: Colors.black)),
                    child: Text(
                      'Audio Leture',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: _ghuslAfterDeath,
          child: Container(
            color: Colors.white,
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(width: 2, color: Colors.black)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  new Container(
                    child: Image.asset(
                        'assets/images/lectures_on_deaths/ghusl_after_death.jpg',
                        height: 75.0,
                        fit: BoxFit.cover),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: Color(0xff133a63),
                        border: Border.all(color: Colors.black)),
                    child: Text(
                      'Ghusl After Death',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: _kafan,
          child: Container(
            color: Colors.white,
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(width: 2, color: Colors.black)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  new Container(
                    child: Image.asset(
                        'assets/images/lectures_on_deaths/kafan.jpg',
                        height: 75.0,
                        fit: BoxFit.cover),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: Color(0xff133a63),
                        border: Border.all(color: Colors.black)),
                    child: Text(
                      'Kafan',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  _willForm() async {
    const url = 'http://arrahma.org/misc/LastWillFrom.pdf';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _duaForJanaza() async {
    const url = 'http://arrahma.org/misc/dua_maghfirat.pdf';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _audioLecture() async {
    const url =
        'https://filedn.com/lYVXaQXjsnDpmndt09ArOXz/MiscellaneousAudio/DURS-ON-MUYUT.mp3';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _ghuslAfterDeath() async {
    const url = 'http://arrahma.org/death/mayyat_ghusul_presentation.ppsx';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _kafan() async {
    const url = 'http://arrahma.org/death/kafan_presentation.ppsx';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
