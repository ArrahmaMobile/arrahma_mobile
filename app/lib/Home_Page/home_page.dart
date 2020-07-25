import 'package:arrahma_mobile_app/drawer/main_drawer.dart';
import 'package:arrahma_mobile_app/widgets/carousel_indicator.dart';
import 'package:arrahma_models/models.dart';
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
      drawer: MainDrawer(),
      appBar: AppBar(
        centerTitle: true,
        title: Image.asset(
            'assets/images/home_page_images/aarhman_mainImage.png',
            fit: BoxFit.cover),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            _buildBanners(),
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
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
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
                Navigator.pushNamed(context, '/media_player_screen');
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

  final _banners = [
    HeadingBanner(
      imageUrl: 'assets/images/home_page_images/front_page_banner1.jpg',
      linkUrl: 'http://arrahma.org/taf2019mp3/juz3/june26_20-imran33-44.mp3',
    ),
    HeadingBanner(
      imageUrl: 'assets/images/home_page_images/front_page_banner1.jpg',
      linkUrl: 'http://www.arrahma.org/tazkeer_n/tazkeer.php',
    ),
    HeadingBanner(
      imageUrl: 'assets/images/home_page_images/front_page_banner1.jpg',
      linkUrl:
          'https://filedn.com/lYVXaQXjsnDpmndt09ArOXz/tarbiyyatimp3/fastsofshawal.mp3',
    ),
  ];

  Widget _buildBanners() {
    return CarouselIndicator(
      items: _banners
          .map((banner) => _buildImageLink(banner.linkUrl, banner.imageUrl))
          .toList(),
    );
  }

  final _broadcasts = [
    BroadcastItem(
      imageUrl: 'assets/images/home_page_images/facebook.png',
      linkUrl: 'https://www.facebook.com/arrahmah.islamic.institute/',
    ),
    BroadcastItem(
      imageUrl: 'assets/images/home_page_images/mixlr_logo.png',
      linkUrl: 'https://mixlr.com/arrahma-live/',
    ),
    BroadcastItem(
      imageUrl: 'assets/images/home_page_images/youtube.png',
      linkUrl: 'https://www.youtube.com/c/arrahmahislamicinstitute',
    ),
    BroadcastItem(
      imageUrl: 'assets/images/home_page_images/contact_information.png',
      linkUrl: 'tel:+1 712 432 1001#491760789',
    ),
  ];

  Widget _broadcast() {
    return GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        childAspectRatio: 2.3,
        children: _broadcasts
            .map((broadcast) =>
                _buildImageLink(broadcast.linkUrl, broadcast.imageUrl))
            .toList());
  }

  Widget _buildImageLink(String linkUrl, String imageUrl) {
    return GestureDetector(
      onTap: () => _launchLink(linkUrl),
      child: Image.asset(imageUrl),
    );
  }

  void _launchLink(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  final _socialMediaList = [
    SocialMediaItem(
      imageUrl: 'assets/images/social_media/youtube.png',
      linkUrl: 'https://www.youtube.com/c/arrahmahislamicinstitute',
    ),
    SocialMediaItem(
      imageUrl: 'assets/images/social_media/facebook.png',
      linkUrl: 'https://www.facebook.com/arrahmah.islamic.institute',
    ),
    SocialMediaItem(
      imageUrl: 'assets/images/social_media/whatsapp.png',
      linkUrl: 'http://arrahma.org/images/whatsapp.png',
    ),
    SocialMediaItem(
      imageUrl: 'assets/images/social_media/twitter.png',
      linkUrl: 'https://twitter.com/ArrahmahIslamic',
    ),
    SocialMediaItem(
      imageUrl: 'assets/images/social_media/instagram.png',
      linkUrl: 'https://www.instagram.com/arrahmah_islamic_institute',
    ),
  ];

  Widget _socialMedia(BuildContext context) {
    return GridView.count(
      crossAxisCount: 6,
      shrinkWrap: true,
      childAspectRatio: 1.5,
      children: <Widget>[
        ..._socialMediaList
            .map((socialMedia) =>
                _buildImageLink(socialMedia.linkUrl, socialMedia.imageUrl))
            .toList(),
        GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/contact_us');
            },
            child: Image.asset('assets/images/home_page_images/contact.png')),
      ],
    );
  }
}
