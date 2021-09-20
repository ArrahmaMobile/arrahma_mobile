import 'package:arrahma_mobile_app/features/drawer/main_drawer.dart';
import 'package:arrahma_mobile_app/core/utils.dart';
import 'package:arrahma_mobile_app/features/common/themed_app_bar.dart';
import 'package:arrahma_mobile_app/features/course/course_view.dart';
import 'package:arrahma_mobile_app/features/media_player/collapsed_player.dart';
import 'package:arrahma_mobile_app/features/quran_course/quran_course_view.dart';
import 'package:arrahma_mobile_app/features/tawk/models/visitor.dart';
import 'package:arrahma_mobile_app/features/tawk/tawk.dart';
import 'package:arrahma_mobile_app/services/app.dart';
import 'package:arrahma_mobile_app/services/device_storage_service.dart';
import 'package:arrahma_mobile_app/widgets/carousel_indicator.dart';
import 'package:arrahma_mobile_app/widgets/restart_widget.dart';
import 'package:arrahma_shared/shared.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_framework/flutter_framework.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:inherited_state/inherited_state.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final appService = SL.get<AppService>();
  bool _registered = false;

  void restartApp() {
    RestartWidget.restartApp(context);
  }

  @override
  Widget build(BuildContext context) {
    if (!_registered) {
      _registered = true;
      ReactiveState.getReactive<AppData>(context)
          .stateListener
          .addListener(restartApp);
    }

    final appData = context.on<AppData>();
    final screenUtils = ScreenUtils.getInstance(context);
    return Scaffold(
      drawer: MainDrawer(
        items: appData.drawerItems,
      ),
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        brightness: Brightness.dark,
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
            child:
                _buildImage(appData?.logoUrl ?? 'assets/images/logo_full.png'),
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
                    _buildQuickLinks(appData.quickLinks),
                    _buildBanners(appData.banners),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(
                            top: screenUtils.isSmallScreen() ? 0 : 40.0),
                        child: CourseView(
                          courses: [
                            ...appData?.courses?.take(3)?.toList() ?? [],
                            ...staticCourses(appData),
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
                      child: const FaIcon(FontAwesomeIcons.solidCommentAlt),
                      onPressed: () {
                        Utils.pushView(
                          context,
                          const Tawk(
                            directChatLink:
                                'https://tawk.to/chat/59840e124471ce54db652823/default',
                            visitor: TawkVisitor(
                              name: '',
                              email: '',
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
              const Divider(
                height: 2,
                thickness: 2,
              ),
              const SizedBox(height: 8),
              _socialMedia(context, appData.socialMediaItems),
              _buildAudioPlayer(),
              const SizedBox(height: 8),
            ],
          ),
        ],
      ),
    );
  }

  List<StaticQuranCourse> staticCourses(AppData appData) => <StaticQuranCourse>[
        StaticQuranCourse(
          imageUrl: 'https://arrahma.org/images_n/209.png',
          title: 'Other\nCourses',
          onTap: () {
            Utils.pushView(
              context,
              CourseView(courses: appData.courses.skip(3).take(6).toList()),
              title: 'Other Courses',
            );
          },
        ),
        StaticQuranCourse(
            imageUrl: 'https://arrahma.org/images_n/202.png',
            title: 'Assorted Lectures',
            onTap: () {
              Utils.pushView(
                context,
                QuranCourseView(course: appData.courses[10]),
                title: 'Assorted Lectures',
              );
            }),
        StaticQuranCourse(
            imageUrl: 'https://arrahma.org/images_n/72.png',
            title: 'Weekly Reminders',
            onTap: () {
              Utils.pushView(
                context,
                CourseView(
                  courses: [
                    appData.courses[9],
                    ...appData.courses.skip(11).toList()
                  ],
                ),
                title: 'Weekly Reminders',
              );
            }),
      ];

  Widget _buildAudioPlayer() {
    return const CollapsedPlayer();
  }

  Widget _buildBanners(List<HeadingBanner> banners) {
    return CarouselIndicator(
      autoPlayInterval: const Duration(seconds: 5),
      items: banners
          ?.map((banner) => _buildImageLink(banner.item, banner.imageUrl))
          ?.toList(),
    );
  }

  Widget _buildQuickLinks(List<QuickLink> quickLinks) {
    return CarouselIndicator(
      autoPlayInterval: const Duration(seconds: 7),
      aspectRatio: 8,
      showIndicator: false,
      items: quickLinks
          ?.map((quickLink) => _buildQuickLink(quickLink.link, quickLink.title))
          ?.toList(),
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
      onTap: () => Utils.openUrl(context, item),
      child: _buildImage(imageUriWithCacheBuster.toString()),
    );
  }

  Widget _buildSocialImageLink(Item item, String imageUrl) {
    return GestureDetector(
      onTap: () => Utils.openUrl(context, item),
      child: _buildSocialMediaItem(
          item.data.contains('youtube')
              ? 'YouTube'
              : item.data.contains('facebook')
                  ? 'Facebook'
                  : null,
          imageUrl),
    );
  }

  Widget _buildQuickLink(Item link, String title) {
    final screenUtils = ScreenUtils.getInstance(context);
    return FittedBox(
      child: Card(
        child: InkWell(
          onTap: () => Utils.openUrl(context, link),
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
    return GridView.count(
      crossAxisCount: 6,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      childAspectRatio: 1.5,
      children: <Widget>[
        ...socialItems
                ?.map((socialMedia) => _buildSocialImageLink(
                    socialMedia.item, socialMedia.imageUrl))
                ?.toList() ??
            [],
        GestureDetector(
          onTap: () {
            // AppService.launchAppOrStore(
            //     context,
            //     AppUtils.isIOS ? 'mixlr://' : 'com.mixlr.android',
            //     AppUtils.isIOS ? '583705714' : 'com.mixlr.android');
            Launch.url('https://mixlr.com/arrahma-live/');
          },
          child: _buildSocialMediaItem(
              'Mixlr', 'assets/images/social_media/mixlr.png'),
        ),
      ],
    );
  }

  Widget _buildSocialMediaItem(String label, String imageUrl) {
    return ValueListenableBuilder<BroadcastStatus>(
      valueListenable: appService.broadcastStatusListenable,
      builder: (_, status, __) {
        final child = Padding(
          padding: const EdgeInsets.all(2.0),
          child: Badge(
            content: const Text('LIVE'),
            offset: const Offset(5, 0),
            enabled: label != null && label == 'YouTube'
                ? status.isYoutubeLive
                : label == 'Facebook'
                    ? status.isFacebookLive
                    : label == 'Mixlr' && status.isMixlrLive,
            child: Center(
              child: _buildImage(imageUrl),
            ),
          ),
        );
        return label != null
            ? Tooltip(
                message: label,
                child: child,
              )
            : child;
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
    ReactiveState.getReactive<AppData>(context)
        .stateListener
        .removeListener(restartApp);
    super.dispose();
  }
}
