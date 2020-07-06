import 'package:arrahma_mobile_app/Contact_Us/contact_us.dart';
import 'package:arrahma_mobile_app/Drawer/main_drawer.dart';
import 'package:arrahma_mobile_app/Media_Player/media_player.dart';
import 'package:arrahma_mobile_app/widgets/carousel_indicator.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

bool _isPlaying = false;

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //scafford -- presents a screen to the user
      drawer: MainDrawer(),
      appBar: AppBar(
        centerTitle: true,
        //AppBar -- Rending a navigation bae with title
        title: Image.asset(
            'assets/images/home_page_images/aarhman_mainImage.png',
            fit: BoxFit.cover),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            _buildBanner(),
            const SizedBox(height: 15),
            _broadcast(),
            Spacer(),
            _socialMedia(context),
            const SizedBox(height: 15),
            SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: Colors.black, width: 2),
                ),
              ),
            ),
            GestureDetector(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Talemul Quran - Lesson name',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  Row(
                    children: <Widget>[
                      IconButton(
                        iconSize: 40,
                        icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
                        onPressed: () {
                          onPlayAudio();
                          setState(
                            () {
                              _isPlaying = !_isPlaying;
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MediaPlayerScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void onPlayAudio() async {
    AssetsAudioPlayer assetsAudioPlayer = AssetsAudioPlayer();
    assetsAudioPlayer.open(
      Audio(
        'assets/audio/introduction.mp3',
      ),
    );
  }

  Widget _buildBanner() {
    return CarouselIndicator(
      items: [
        GestureDetector(
            onTap: _latestFridayLecture,
            child: Image.asset(
                'assets/images/home_page_images/front_page_banner1.jpg')),
        GestureDetector(
            onTap: _launchTazkeer,
            child: Image.asset(
                'assets/images/home_page_images/front_page_banner2.jpg')),
        GestureDetector(
            onTap: _launchShawaal,
            child: Image.asset(
                'assets/images/home_page_images/front_page_banner3.jpg')),
      ],
    );
  }

  _latestFridayLecture() async {
    const url = 'http://arrahma.org/taf2019mp3/juz3/june26_20-imran33-44.mp3';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _launchTazkeer() async {
    const url = 'http://www.arrahma.org/tazkeer_n/tazkeer.php';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _launchShawaal() async {
    const url =
        'https://filedn.com/lYVXaQXjsnDpmndt09ArOXz/tarbiyyatimp3/fastsofshawal.mp3';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget _broadcast() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      childAspectRatio: 2.3,
      children: <Widget>[
        GestureDetector(
            onTap: _launchFacebook,
            child: Image.asset('assets/images/home_page_images/facebook.png')),
        GestureDetector(
            onTap: _launchMixlr,
            child:
                Image.asset('assets/images/home_page_images/mixlr_logo.png')),
        GestureDetector(
            onTap: _launchPhone,
            child: Image.asset(
                'assets/images/home_page_images/contact_information.png')),
        GestureDetector(
            onTap: _launchYoutube,
            child: Image.asset('assets/images/home_page_images/youtube.png')),
      ],
    );
  }

  _launchMixlr() async {
    const url = 'https://mixlr.com/arrahma-live/';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _launchFacebook() async {
    const url = 'https://www.facebook.com/arrahmah.islamic.institute/';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _launchYoutube() async {
    const url = 'https://www.youtube.com/c/arrahmahislamicinstitute';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _launchPhone() async {
    const url = 'tel:+1 712 432 1001#491760789';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget _socialMedia(context) {
    return GridView.count(
      crossAxisCount: 6,
      shrinkWrap: true,
      childAspectRatio: 1.5,
      children: <Widget>[
        GestureDetector(
            onTap: _youtube,
            child: Image.asset('assets/images/social_media/youtube.png')),
        GestureDetector(
            onTap: _facebook,
            child: Image.asset('assets/images/social_media/facebook.png')),
        GestureDetector(
            onTap: _whatsapp,
            child: Image.asset('assets/images/social_media/whatsapp.png')),
        GestureDetector(
            onTap: _twitter,
            child: Image.asset('assets/images/social_media/twitter.png')),
        GestureDetector(
            onTap: _instagram,
            child: Image.asset('assets/images/social_media/instagram.png')),
        GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ContactUs()),
              );
            },
            child: Image.asset('assets/images/home_page_images/contact.png')),
      ],
    );
  }

  _youtube() async {
    const url = 'https://www.youtube.com/c/arrahmahislamicinstitute';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _facebook() async {
    const url = 'https://www.facebook.com/arrahmah.islamic.institute/';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _whatsapp() async {
    const url = 'http://arrahma.org/images/whatsapp.png';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _twitter() async {
    const url = 'https://twitter.com/ArrahmahIslamic';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _instagram() async {
    const url = 'https://www.instagram.com/arrahmah_islamic_institute/';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
