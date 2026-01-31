import 'package:arrahma_mobile_app/core/utils.dart';
import 'package:arrahma_mobile_app/features/course/course_view.dart';
import 'package:arrahma_mobile_app/features/drawer/main_drawer.dart';
import 'package:arrahma_mobile_app/features/dua/dua_category_view.dart';
import 'package:arrahma_mobile_app/features/media_player/collapsed_player.dart';
import 'package:arrahma_mobile_app/features/tawk/models/visitor.dart';
import 'package:arrahma_mobile_app/features/tawk/tawk.dart';
import 'package:arrahma_mobile_app/services/app.dart';
import 'package:arrahma_mobile_app/services/device_storage_service.dart';
import 'package:arrahma_mobile_app/widgets/carousel_indicator.dart';
import 'package:arrahma_shared/shared.dart';
import 'package:flutter/material.dart' hide Badge;
import 'package:flutter/services.dart';
import 'package:flutter_framework/flutter_framework.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:inherited_state/inherited_state.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final appService = SL.get<AppService>()!;

  @override
  Widget build(BuildContext context) {
    final appData = context.on<AppData>();
    final screenUtils = ScreenUtils.getInstance(context)!;
    if (appService.firstDataFetchFailed)
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Failed to load data'),
              Center(
                child: ValueListenableBuilder(
                  valueListenable: appService.dataLoadingListenable,
                  builder: (_, loading, __) {
                    return loading
                        ? const CircularProgressIndicator()
                        : const Text(
                            'Retrying every 10 seconds',
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                            ),
                          );
                  },
                ),
              ),
            ],
          ),
        ),
      );
    return Scaffold(
      drawer: MainDrawer(
        items: appData.drawerItems,
      ),
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        // brightness: Brightness.dark,
        title: HiddenTap(
          onTrigger: () async {
            if (!AppUtils.isDebug) return;
            final currentEnv = context.once<EnvironmentConfig>();
            final envs = SL.get<EnvironmentService>()!.getEnvironments();
            if ((envs.length) <= 1) return;
            final envNames = envs.map((e) => e.name).toList();
            final nextEnv =
                envs[(envNames.indexOf(currentEnv.name) + 1) % envs.length];
            RS.set<EnvironmentConfig>(context, (_) => nextEnv);
            final success = await SL
                .get<DeviceStorageService>()!
                .saveEnvironmentName(nextEnv.name);
            if (success) print('Switched env to ${nextEnv.name}');
          },
          child: SizedBox(
            height: 56,
            child: _buildImage(appData.logoUrl),
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(height: 10),
          Expanded(
            child: Stack(
              children: [
                Column(
                  children: [
                    // DataLoadingBanner(),
                    _buildQuickLinks(appData.quickLinks),
                    _buildBanners(appData.banners),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(
                            top: screenUtils.isSmallScreen() ? 0 : 40.0),
                        child: CourseView(
                          courses: [
                            ...staticCourses(appData),
                            ...appData.courses.toList(),
                            ...(appData.otherCourseGroups?.toList() ??
                                <QuranCourseGroup>[]),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: FloatingActionButton(
                      backgroundColor: Colors.brown.shade400,
                      child: const FaIcon(FontAwesomeIcons.solidMessage),
                      onPressed: () {
                        Utils.pushView(
                          context,
                          const Tawk(
                            directChatLink:
                                'https://tawk.to/chat/59840e124471ce54db652823/default',
                            visitor: TawkVisitor(
                              name: '',
                              email: '',
                              hash: 'default',
                            ),
                          ),
                          title: 'Chat With Us',
                        );
                      },
                    ),
                  ),
                )
              ],
            ),
          ),
          Column(
            children: [
              _buildFooter(Column(
                children: [
                  const Divider(
                    height: 2,
                    thickness: 2,
                  ),
                  const SizedBox(height: 8),
                  _socialMedia(context, appData.socialMediaItems),
                ],
              )),
            ],
          ),
        ],
      ),
    );
  }

  List<StaticQuranCourse> staticCourses(AppData appData) => <StaticQuranCourse>[
        StaticQuranCourse(
            imageUrl: 'assets/images/dua-dhikr.jpg',
            title: 'Duas & Dhikr',
            onTap: () {
              Utils.pushView(
                context,
                const DuaCategoryView(),
              );
            }),
      ];

  Widget _buildFooter(Widget defaultFooter) {
    return HomePageFooter(
      defaultFooter: defaultFooter,
    );
  }

  Widget _buildBanners(List<HeadingBanner> banners) {
    return CarouselIndicator(
      autoPlayInterval: const Duration(seconds: 5),
      items: banners.map((banner) => _buildBanner(banner)).toList(),
    );
  }

  Widget _buildBanner(HeadingBanner banner) {
    // Check if this is a basic banner image that needs text overlay
    final isBasicBanner = banner.imageUrl
        .contains(RegExp(r'banner\d*\.jpg', caseSensitive: false));
    final hasText = (banner.heading != null && banner.heading!.isNotEmpty) ||
        (banner.title != null && banner.title!.isNotEmpty);

    if (isBasicBanner && hasText) {
      return _buildBannerWithText(banner);
    } else {
      return _buildImageLink(banner.item, banner.imageUrl);
    }
  }

  Widget _buildBannerWithText(HeadingBanner banner) {
    final screenUtils = ScreenUtils.getInstance(context)!;

    return GestureDetector(
      onTap: () => Utils.openUrl(context, banner.item),
      child: ClipRect(
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Container(
            //   decoration: BoxDecoration(
            //     gradient: LinearGradient(
            //       begin: Alignment.topCenter,
            //       end: Alignment.bottomCenter,
            //       colors: [
            //         Colors.black.withValues(alpha: 0.3),
            //         Colors.black.withValues(alpha: 0.6),
            //       ],
            //     ),
            //   ),
            // ),
            _buildImage(banner.imageUrl),
            Positioned.fill(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 12.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (banner.heading != null && banner.heading!.isNotEmpty)
                      Flexible(
                        child: Text(
                          banner.heading!,
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: screenUtils.getSp(18),
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(
                                offset: const Offset(1, 1),
                                blurRadius: 3.0,
                                color: Colors.black.withValues(alpha: 0.8),
                              ),
                            ],
                          ),
                        ),
                      ),
                    if (banner.heading != null &&
                        banner.heading!.isNotEmpty &&
                        banner.title != null &&
                        banner.title!.isNotEmpty)
                      const SizedBox(height: 6),
                    if (banner.title != null && banner.title!.isNotEmpty)
                      Flexible(
                        child: Text(
                          banner.title!,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: screenUtils.getSp(14),
                            fontWeight: FontWeight.w500,
                            shadows: [
                              Shadow(
                                offset: const Offset(1, 1),
                                blurRadius: 3.0,
                                color: Colors.black.withValues(alpha: 0.8),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickLinks(List<QuickLink> quickLinks) {
    return CarouselIndicator(
      autoPlayInterval: const Duration(seconds: 7),
      aspectRatio: 8,
      showIndicator: false,
      items: quickLinks
          .where((quickLink) => quickLink.link != null)
          .map((quickLink) => _buildQuickLink(quickLink.link!, quickLink.title))
          .toList(),
    );
  }

  Widget _buildImageLink(Item item, String imageUrl) {
    final imageUri = Uri.parse(imageUrl);
    final imageUriWithCacheBuster = imageUri.replace(
        queryParameters: <String, String>{
          ...imageUri.queryParameters,
          'buster': item.data
        });
    return GestureDetector(
      onTap: () => Utils.openUrl(context, item.copyWith(imageUrl: imageUrl)),
      child: _buildImage(imageUriWithCacheBuster.toString()),
    );
  }

  Widget _buildSocialImageLink(Item item, String? imageUrl) {
    // Determine platform and default image
    final String platform;
    final String defaultImage;

    if (item.data.contains('youtube')) {
      platform = 'YouTube';
      defaultImage = 'assets/images/social_media/youtube.png';
    } else if (item.data.contains('facebook')) {
      platform = 'Facebook';
      defaultImage = 'assets/images/social_media/facebook.png';
    } else if (item.data.contains('mixlr')) {
      platform = 'Mixlr';
      defaultImage = 'assets/images/social_media/mixlr.png';
    } else if (item.data.contains('instagram')) {
      platform = 'Instagram';
      defaultImage = 'assets/images/social_media/instagram.png';
    } else if (item.data.contains('twitter') || item.data.contains('x.com')) {
      platform = 'Twitter';
      defaultImage = 'assets/images/social_media/twitter.png';
    } else if (item.data.contains('tiktok')) {
      platform = 'TikTok';
      defaultImage = 'assets/images/social_media/tiktok.png';
    } else {
      platform = 'Website';
      defaultImage = 'assets/images/social_media/web.png';
    }

    // Handle icon: prefix from scraper for Font Awesome icons
    String finalImageUrl;
    if (imageUrl != null && imageUrl.startsWith('icon:')) {
      final iconType = imageUrl.substring(5); // Remove 'icon:' prefix
      if (iconType == 'youtube') {
        finalImageUrl = 'assets/images/social_media/youtube.png';
      } else if (iconType == 'facebook') {
        finalImageUrl = 'assets/images/social_media/facebook.png';
      } else if (iconType == 'microphone') {
        finalImageUrl = 'assets/images/social_media/mixlr.png';
      } else if (iconType == 'instagram') {
        finalImageUrl = 'assets/images/social_media/instagram.png';
      } else if (iconType == 'twitter') {
        finalImageUrl = 'assets/images/social_media/twitter.png';
      } else if (iconType == 'tiktok') {
        finalImageUrl = 'assets/images/social_media/tiktok.png';
      } else {
        finalImageUrl = defaultImage;
      }
    } else {
      finalImageUrl =
          imageUrl != null && imageUrl.isNotEmpty ? imageUrl : defaultImage;
    }

    return GestureDetector(
      onTap: () => Utils.openUrl(context, item),
      child: _buildSocialMediaItem(platform, finalImageUrl),
    );
  }

  Widget _buildQuickLink(Item link, String title) {
    final screenUtils = ScreenUtils.getInstance(context)!;
    return FittedBox(
      child: Card(
        child: InkWell(
          onTap: () => Utils.openUrl(context, TitledItem.fromItem(title, link)),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Center(
              child: Text(
                title,
                textAlign: TextAlign.center,
                maxLines: 2,
                style: TextStyle(
                  fontSize: screenUtils.getSp(14),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _socialMedia(BuildContext context, List<SocialMediaItem> socialItems) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
        child: Wrap(
          alignment: WrapAlignment.center,
          spacing: 16.0,
          runSpacing: 12.0,
          children: <Widget>[
            ...socialItems
                .map((socialMedia) => SizedBox(
                      width: 40,
                      height: 40,
                      child: _buildSocialImageLink(
                          socialMedia.item, socialMedia.imageUrl),
                    ))
                .toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialMediaItem(String label, String imageUrl) {
    return ValueListenableBuilder<BroadcastStatus>(
      valueListenable: appService.broadcastStatusListenable,
      builder: (_, status, __) {
        final child = Padding(
          padding: const EdgeInsets.all(2.0),
          child: Badge(
            constraints: const BoxConstraints(maxWidth: 32),
            content: const Padding(
              padding: EdgeInsets.all(2.0),
              child: Text('LIVE'),
            ),
            offset: const Offset(0, -8),
            enabled: label == 'YouTube'
                ? status.isYoutubeLive
                : label == 'Facebook'
                    ? status.isFacebookLive
                    : label == 'Mixlr' && status.isMixlrLive,
            child: Center(
              child: _buildImage(imageUrl),
            ),
          ),
        );
        return Tooltip(
          message: label,
          child: child,
        );
      },
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

  @override
  void dispose() {
    super.dispose();
  }
}
