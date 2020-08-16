import 'package:arrahma_mobile_app/drawer/main_drawer.dart';
import 'package:arrahma_mobile_app/widgets/carousel_indicator.dart';
import 'package:arrahma_models/models.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:inherited_state/inherited_state.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

bool _isPlaying = false;

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final appData = context.on<AppData>();
    return Scaffold(
      drawer: MainDrawer(),
      appBar: AppBar(
        centerTitle: true,
        title: appData?.logoUrl != null
            ? Image.network(appData.logoUrl)
            : Image.asset(
                'assets/images/home_page_images/aarhman_mainImage.png',
                fit: BoxFit.cover),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            _buildBanners(appData.banners),
            const SizedBox(height: 15),
            _broadcast(appData.broadcastItems),
            const Spacer(),
            _socialMedia(context, appData.socialMediaItems),
            const SizedBox(height: 15),
            const SizedBox(height: 20),
            Container(
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(color: Colors.black, width: 2),
                ),
              ),
            ),
            GestureDetector(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  const Text(
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

  Future onPlayAudio() async {
    final assetsAudioPlayer = AssetsAudioPlayer();
    assetsAudioPlayer.open(
      Audio(
        'assets/audio/introduction.mp3',
      ),
    );
  }

  Widget _buildBanners(List<HeadingBanner> banners) {
    return CarouselIndicator(
      items: banners
          .map((banner) => _buildImageLink(banner.linkUrl, banner.imageUrl))
          .toList(),
    );
  }

  Widget _broadcast(List<BroadcastItem> broadcasts) {
    return GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        childAspectRatio: 2.3,
        children: broadcasts
            .map((broadcast) =>
                _buildImageLink(broadcast.linkUrl, broadcast.imageUrl))
            .toList());
  }

  Widget _buildImageLink(String linkUrl, String imageUrl) {
    return GestureDetector(
      onTap: () => _launchLink(linkUrl),
      child: Image.network(imageUrl),
    );
  }

  Future _launchLink(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget _socialMedia(BuildContext context, List<SocialMediaItem> socialItems) {
    return GridView.count(
      crossAxisCount: 6,
      shrinkWrap: true,
      childAspectRatio: 1.5,
      children: <Widget>[
        ...socialItems
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
