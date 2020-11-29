import 'package:arrahma_mobile_app/Contact_Us/contact_us.dart';
import 'package:arrahma_mobile_app/core/utils.dart';
import 'package:arrahma_mobile_app/drawer/main_drawer.dart';
import 'package:arrahma_mobile_app/features/media_player/collapsed_player.dart';
import 'package:arrahma_mobile_app/services/device_storage_service.dart';
import 'package:arrahma_mobile_app/widgets/carousel_indicator.dart';
import 'package:arrahma_shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_framework/flutter_framework.dart';
import 'package:inherited_state/inherited_state.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final appData = context.on<AppData>();
    return Scaffold(
      drawer: MainDrawer(),
      appBar: AppBar(
        centerTitle: true,
        title: HiddenTap(
          onTrigger: () async {
            if (!AppUtils.isDebug) return;
            final currentEnv = context.once<EnvironmentConfig>();
            final envs = SL.get<EnvironmentService>().getEnvironments();
            if ((envs?.length ?? -1) <= 1) return;
            final envNames = envs.map((e) => e.name).toList();
            final nextEnv =
                envs[(envNames.indexOf(currentEnv.name) + 1) % envs.length];
            RS.set<EnvironmentConfig>(context, (_) => nextEnv);
            final success = await SL
                .get<DeviceStorageService>()
                .saveEnvironmentName(nextEnv.name);
            if (success) print('Switched env to ${nextEnv.name}');
          },
          child: SizedBox(
            height: 56,
            child: _buildImage(appData?.logoUrl ??
                'assets/images/home_page_images/aarhman_mainImage.png'),
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
          .map((banner) => _buildImageLink(banner.item, banner.imageUrl))
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
                _buildImageLink(broadcast.item, broadcast.imageUrl))
            .toList());
  }

  Widget _buildImageLink(Item item, String imageUrl) {
    return GestureDetector(
      onTap: () => Utils.openUrl(context, (index) => 'Audio', '', [item], 0),
      child: _buildImage(imageUrl),
    );
  }

  Widget _buildImage(String imageUrl) {
    return imageUrl.startsWith('http')
        ? Image(
            image: ImageUtils.fromNetworkWithCached(imageUrl),
            width: 1000,
            fit: BoxFit.contain)
        : Image.asset(imageUrl);
  }

  Widget _socialMedia(BuildContext context, List<SocialMediaItem> socialItems) {
    return GridView.count(
      crossAxisCount: 6,
      shrinkWrap: true,
      childAspectRatio: 1.5,
      children: <Widget>[
        ...socialItems
            .map((socialMedia) =>
                _buildImageLink(socialMedia.item, socialMedia.imageUrl))
            .toList(),
        GestureDetector(
            onTap: () {
              Navigator.push<dynamic>(context,
                  MaterialPageRoute<dynamic>(builder: (_) => ContactUs()));
            },
            child: Image.asset('assets/images/home_page_images/contact.png')),
      ],
    );
  }
}
