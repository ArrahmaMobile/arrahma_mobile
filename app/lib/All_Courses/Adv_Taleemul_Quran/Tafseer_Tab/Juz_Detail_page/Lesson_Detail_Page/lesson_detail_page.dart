import 'package:flutter/material.dart';

class LessonDetailPage extends StatefulWidget {
  @override
  _LessonDetailPageState createState() => _LessonDetailPageState();
}

class _LessonDetailPageState extends State<LessonDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF212121),
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(height: 50),
              Container(
                alignment: Alignment.topLeft,
                margin: EdgeInsets.only(left: 10, top: 10),
                child: Column(),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    child: ClipRRect(
                      child: Image.asset(
                        'assets/images/media_player/media_player_icon.PNG',
                        width: MediaQuery.of(context).size.width * 0.3,
                        height: MediaQuery.of(context).size.width * 0.3,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Column(
                    children: <Widget>[
                      Text(
                        'Surah Al-Fatiha  الفاتحۃ',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Colors.white),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  Column(
                    children: <Widget>[
                      Text(
                        'Lesson 1: Ayah 1-3',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 30),
              GestureDetector(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(left: 20),
                          child: Image.asset(
                            'assets/images/social_media_share/message.png',
                            height: 25,
                          ),
                        ),
                        SizedBox(width: 15),
                        Text(
                          'Root words',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.access_alarms),
                          color: Colors.grey,
                          onPressed: () {},
                        )
                      ],
                    )
                  ],
                ),
                onTap: () {},
              ),
              SizedBox(height: 30),
              GestureDetector(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(left: 20),
                          child: Image.asset(
                            'assets/images/social_media_share/facebook.png',
                            height: 25,
                          ),
                        ),
                        SizedBox(width: 15),
                        Text(
                          'Translation',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.access_alarms),
                          color: Colors.grey,
                          onPressed: () {},
                        )
                      ],
                    )
                  ],
                ),
                onTap: () {},
              ),
              SizedBox(height: 30),
              GestureDetector(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(left: 20),
                          child: Image.asset(
                            'assets/images/social_media_share/twitter.png',
                            height: 25,
                          ),
                        ),
                        SizedBox(width: 15),
                        Text(
                          'Tafseer',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.access_alarms),
                          color: Colors.grey,
                          onPressed: () {},
                        ),
                        IconButton(
                          icon: Icon(Icons.access_alarms),
                          color: Colors.grey,
                          onPressed: () {},
                        )
                      ],
                    )
                  ],
                ),
                onTap: () {},
              ),
              SizedBox(height: 30),
              GestureDetector(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(left: 20),
                          child: Image.asset(
                            'assets/images/social_media_share/whatsapp.png',
                            height: 25,
                          ),
                        ),
                        SizedBox(width: 15),
                        Text(
                          'Ref. Material',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.access_alarms),
                          color: Colors.grey,
                          onPressed: () {},
                        )
                      ],
                    )
                  ],
                ),
                onTap: () {},
              ),
              SizedBox(height: 80),
              GestureDetector(
                child: Text(
                  'Close',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.grey),
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
