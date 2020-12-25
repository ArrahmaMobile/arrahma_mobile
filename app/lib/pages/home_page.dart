import 'package:arrahma_mobile_app/features/drawer/main_drawer.dart';
import 'package:arrahma_mobile_app/core/utils.dart';
import 'package:arrahma_mobile_app/features/common/themed_app_bar.dart';
import 'package:arrahma_mobile_app/features/course/course_view.dart';
import 'package:arrahma_mobile_app/features/media_player/collapsed_player.dart';
import 'package:arrahma_mobile_app/features/quran_course/quran_course_view.dart';
import 'package:arrahma_mobile_app/services/device_storage_service.dart';
import 'package:arrahma_mobile_app/widgets/carousel_indicator.dart';
import 'package:arrahma_shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_framework/flutter_framework.dart';
import 'package:flutter_tawk/flutter_tawk.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
      drawer: MainDrawer(
        items: appData.drawerItems,
      ),
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
                      child: CourseView(
                        courses: [
                          ...appData.courses.take(3),
                          ...staticCourses(appData),
                        ],
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
                        NavigationUtils.push<dynamic>(
                            context,
                            MaterialPageRoute<dynamic>(
                                builder: (_) => SafeArea(
                                      child: Scaffold(
                                        appBar: const ThemedAppBar(
                                          title: 'Chat With Us',
                                        ),
                                        body: Tawk(
                                          directChatLink:
                                              'https://tawk.to/chat/59840e124471ce54db652823/default',
                                          visitor: TawkVisitor(
                                            name: '',
                                            email: '',
                                          ),
                                        ),
                                      ),
                                    )));
                      },
                    ),
                  ),
                )
              ],
            ),
          ),
          Column(
            children: [
              Divider(
                height: 2,
                thickness: 2,
                color: Colors.grey.shade300,
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
          imageUrl: 'https://arrahma.org/images_n/202.png',
          title: 'OTHER \nCOURSES',
          onTap: () {
            NavigationUtils.push<dynamic>(
                context,
                MaterialPageRoute<dynamic>(
                    builder: (_) => Scaffold(
                        appBar: ThemedAppBar(
                          title: 'OTHER COURSES',
                        ),
                        body: CourseView(
                            courses:
                                appData.courses.skip(3).take(6).toList()))));
          },
        ),
        StaticQuranCourse(
            imageUrl: 'https://arrahma.org/images_n/209.png',
            title: 'ASSORTED LECTURES',
            onTap: () {
              NavigationUtils.push<dynamic>(
                  context,
                  MaterialPageRoute<dynamic>(
                      builder: (_) =>
                          QuranCourseView(course: appData.courses[10])));
            }),
        StaticQuranCourse(
            imageUrl: 'https://arrahma.org/images_n/72.png',
            title: 'WEEKLY REMINDERS',
            onTap: () {
              NavigationUtils.push<dynamic>(
                  context,
                  MaterialPageRoute<dynamic>(
                      builder: (_) => Scaffold(
                            appBar: ThemedAppBar(
                              title: 'WEEKLY REMINDERS',
                            ),
                            body: CourseView(
                              courses: [
                                appData.courses[9],
                                ...appData.courses.skip(11).toList()
                              ],
                            ),
                          )));
            }),
      ];

  Widget _buildAudioPlayer() {
    return CollapsedPlayer();
  }

  Widget _buildBanners(List<HeadingBanner> banners) {
    return CarouselIndicator(
      autoPlayInterval: const Duration(seconds: 5),
      items: banners
          .map((banner) => _buildImageLink(banner.item, banner.imageUrl))
          .toList(),
    );
  }

  Widget _buildQuickLinks(List<QuickLink> quickLinks) {
    return CarouselIndicator(
      autoPlayInterval: const Duration(seconds: 7),
      aspectRatio: 10,
      showIndicator: false,
      items: quickLinks
          ?.map((quickLink) => _buildQuickLink(quickLink.link, quickLink.title))
          ?.toList(),
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

  Widget _buildQuickLink(Item link, String title) {
    return ConstrainedBox(
      constraints: BoxConstraints(minWidth: double.infinity),
      child: Card(
        child: InkWell(
          onTap: () =>
              Utils.openUrl(context, (index) => 'Audio', '', [link], 0),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Center(child: Text(title)),
          ),
        ),
      ),
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
            Launch.url('https://mixlr.com/arrahma-live/');
          },
          child: Tooltip(
            message: 'Mixlr',
            child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Image.asset('assets/images/social_media/mixlr.png')),
          ),
        ),
      ],
    );
  }
}
