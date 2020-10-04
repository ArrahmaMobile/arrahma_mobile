import 'package:arrahma_mobile_app/drawer/main_drawer.dart';
import 'package:arrahma_mobile_app/features/media_player/collapsed_player.dart';
import 'package:arrahma_mobile_app/services/device_storage_service.dart';
import 'package:arrahma_mobile_app/widgets/carousel_indicator.dart';
import 'package:arrahma_shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_framework/flutter_framework.dart';
import 'package:inherited_state/inherited_state.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int tapCount;

  @override
  void initState() {
    super.initState();
    tapCount = 0;
  }

  @override
  Widget build(BuildContext context) {
    final appData = context.on<AppData>();
    return Scaffold(
      drawer: MainDrawer(),
      appBar: AppBar(
        centerTitle: true,
        title: GestureDetector(
          onTap: () async {
            tapCount++;
            if (tapCount > 2) {
              tapCount = 0;
              final currentEnv = context.once<EnvironmentConfig>();
              final envs = SL.get<EnvironmentService>().getEnvironments();
              final envNames = envs.map((e) => e.name).toList();
              final nextEnv =
                  envs[(envNames.indexOf(currentEnv.name) + 1) % envs.length];
              RS.set<EnvironmentConfig>(context, (_) => nextEnv);
              final success = await SL
                  .get<DeviceStorageService>()
                  .saveEnvironmentName(nextEnv.name);
              if (success) print('Switched env to ${nextEnv.name}');
            }
          },
          child: SizedBox(
            height: 56,
            child: (appData?.logoUrl?.startsWith('http') ?? false)
                ? Image.network(appData.logoUrl)
                : Image.asset(
                    'assets/images/home_page_images/aarhman_mainImage.png',
                    fit: BoxFit.cover),
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(height: 10),
          Expanded(
            child: Column(
              children: [
                _buildBanners(appData.banners),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(10),
                    child: _broadcast(appData.broadcastItems),
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: [
              _socialMedia(context, appData.socialMediaItems),
              Padding(
                padding: const EdgeInsets.only(top: 18.0),
                child: _buildAudioPlayer(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAudioPlayer() {
    return CollapsedPlayer();
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
      child: imageUrl.startsWith('http')
          ? Image.network(imageUrl, fit: BoxFit.contain, width: 1000.0)
          : Image.asset(imageUrl),
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
