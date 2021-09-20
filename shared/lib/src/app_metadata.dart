import 'models/models.dart';
import 'models/quick_link.dart';
import 'models/quran_course/v2/quran_course.dart';

class AppData {
  const AppData({
    this.logoUrl,
    this.aboutUsMarkdown,
    this.banners,
    this.broadcastItems,
    this.courses,
    this.socialMediaItems,
    this.quickLinks,
    this.drawerItems,
  });
  final List<DrawerItem> drawerItems;
  final List<QuickLink> quickLinks;
  final String logoUrl;
  final String aboutUsMarkdown;
  final List<HeadingBanner> banners;
  final List<BroadcastItem> broadcastItems;
  final List<QuranCourse> courses;
  final List<SocialMediaItem> socialMediaItems;
}
