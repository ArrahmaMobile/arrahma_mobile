import 'package:arrahma_mobile_app/Media_Player/media_player.dart';
import 'package:flutter/material.dart';

class Share extends StatefulWidget {
  @override
  _ShareState createState() => _ShareState();
}

class _ShareState extends State<Share> {
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
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 40,
                      width: double.infinity,
                      child: Stack(
                        children: [
                          Center(
                            child: Text(
                              'Share',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: Colors.white),
                            ),
                          ),
                          Positioned(
                            child: IconButton(
                              iconSize: 25,
                              icon: Icon(
                                Icons.close,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MediaPlayerScreen(),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      child: ClipRRect(
                        child: Image.asset(
                          'assets/images/media_player/media_player_icon.PNG',
                          width: MediaQuery.of(context).size.width * 0.2,
                          height: MediaQuery.of(context).size.width * 0.2,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(height: 50),
                    Text(
                      'Tafseer - "Lesson Name"',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Colors.white),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15),
              GestureDetector(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: Image.asset(
                        'assets/images/social_media_share/message.png',
                        height: 25,
                      ),
                    ),
                    Text(
                      'Messages',
                      style: TextStyle(color: Colors.white),
                    ),
                    Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.keyboard_arrow_right,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                onTap: () {},
              ),
              SizedBox(height: 5),
              GestureDetector(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: Image.asset(
                        'assets/images/social_media_share/facebook.png',
                        height: 25,
                      ),
                    ),
                    Text(
                      'Facebook',
                      style: TextStyle(color: Colors.white),
                    ),
                    Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.keyboard_arrow_right,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                onTap: () {},
              ),
              SizedBox(height: 5),
              GestureDetector(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: Image.asset(
                        'assets/images/social_media_share/snapchat.png',
                        height: 25,
                      ),
                    ),
                    Text(
                      'Snapchat',
                      style: TextStyle(color: Colors.white),
                    ),
                    Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.keyboard_arrow_right,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                onTap: () {},
              ),
              SizedBox(height: 5),
              GestureDetector(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: Image.asset(
                        'assets/images/social_media_share/twitter.png',
                        height: 25,
                      ),
                    ),
                    Text(
                      'Twitter',
                      style: TextStyle(color: Colors.white),
                    ),
                    Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.keyboard_arrow_right,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                onTap: () {},
              ),
              SizedBox(height: 5),
              GestureDetector(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: Image.asset(
                        'assets/images/social_media_share/whatsapp.png',
                        height: 25,
                      ),
                    ),
                    Text(
                      'Whatsapp',
                      style: TextStyle(color: Colors.white),
                    ),
                    Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.keyboard_arrow_right,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                onTap: () {},
              ),
              SizedBox(height: 5),
              GestureDetector(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: Image.asset(
                        'assets/images/social_media_share/instagram.png',
                        height: 25,
                      ),
                    ),
                    Text(
                      'Instagram',
                      style: TextStyle(color: Colors.white),
                    ),
                    Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.keyboard_arrow_right,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                onTap: () {},
              ),
              SizedBox(height: 5),
              GestureDetector(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: Image.asset(
                        'assets/images/social_media_share/copy_link.png',
                        height: 25,
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      'Copy Link',
                      style: TextStyle(color: Colors.white),
                    ),
                    Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.keyboard_arrow_right,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                onTap: () {},
              ),
              SizedBox(height: 5),
              GestureDetector(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: Image.asset(
                        'assets/images/social_media_share/three_dots.png',
                        height: 25,
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      'More',
                      style: TextStyle(color: Colors.white),
                    ),
                    Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.keyboard_arrow_right,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
