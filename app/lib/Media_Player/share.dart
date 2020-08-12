import 'package:flutter/material.dart';

class Share extends StatefulWidget {
  @override
  _ShareState createState() => _ShareState();
}

class _ShareState extends State<Share> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              const SizedBox(height: 30),
              Container(
                alignment: Alignment.topLeft,
                margin: const EdgeInsets.only(left: 10, top: 10),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Positioned(
                          child: IconButton(
                            iconSize: 25,
                            icon: Icon(
                              Icons.close,
                              color: Colors.black,
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 140),
                          child: Text(
                            'Share',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      child: ClipRRect(
                        child: Image.asset(
                          'assets/images/media_player/media_player_icon.PNG',
                          width: MediaQuery.of(context).size.width * 0.2,
                          height: MediaQuery.of(context).size.width * 0.2,
                        ),
                      ),
                    ),
                    const SizedBox(height: 50),
                    Text(
                      'Tafseer - "Lesson Name"',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Colors.black),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 25),
              GestureDetector(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Image.asset(
                            'assets/images/social_media_share/message.png',
                            height: 25,
                          ),
                        ),
                        const SizedBox(width: 15),
                        Text(
                          'Messages',
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.keyboard_arrow_right,
                        color: Colors.black,
                        size: 20,
                      ),
                    ),
                  ],
                ),
                onTap: () {},
              ),
              const SizedBox(height: 30),
              GestureDetector(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Image.asset(
                            'assets/images/social_media_share/facebook.png',
                            height: 25,
                          ),
                        ),
                        const SizedBox(width: 15),
                        Text(
                          'Facebook',
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.keyboard_arrow_right,
                        color: Colors.black,
                        size: 20,
                      ),
                    ),
                  ],
                ),
                onTap: () {},
              ),
              const SizedBox(height: 30),
              GestureDetector(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Image.asset(
                            'assets/images/social_media_share/twitter.png',
                            height: 25,
                          ),
                        ),
                        const SizedBox(width: 15),
                        Text(
                          'Twitter',
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.keyboard_arrow_right,
                        color: Colors.black,
                        size: 20,
                      ),
                    ),
                  ],
                ),
                onTap: () {},
              ),
              const SizedBox(height: 30),
              GestureDetector(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Image.asset(
                            'assets/images/social_media_share/whatsapp.png',
                            height: 25,
                          ),
                        ),
                        const SizedBox(width: 15),
                        Text(
                          'Whatsapp',
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.keyboard_arrow_right,
                        color: Colors.black,
                        size: 20,
                      ),
                    ),
                  ],
                ),
                onTap: () {},
              ),
              const SizedBox(height: 30),
              GestureDetector(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Image.asset(
                            'assets/images/social_media_share/instagram.png',
                            height: 25,
                          ),
                        ),
                        const SizedBox(width: 15),
                        Text(
                          'Instagram',
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.keyboard_arrow_right,
                        color: Colors.black,
                        size: 20,
                      ),
                    ),
                  ],
                ),
                onTap: () {},
              ),
              const SizedBox(height: 30),
              GestureDetector(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Image.asset(
                            'assets/images/social_media_share/copy_link.png',
                            height: 25,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(width: 15),
                        Text(
                          'Copy Link',
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.keyboard_arrow_right,
                        color: Colors.black,
                        size: 20,
                      ),
                    ),
                  ],
                ),
                onTap: () {},
              ),
              const SizedBox(height: 30),
              GestureDetector(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Image.asset(
                            'assets/images/social_media_share/three_dots.png',
                            height: 25,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(width: 15),
                        Text(
                          'More',
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.keyboard_arrow_right,
                        color: Colors.black,
                        size: 20,
                      ),
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
