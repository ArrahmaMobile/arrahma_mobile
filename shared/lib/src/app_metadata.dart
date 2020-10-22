import 'models/models.dart';

class AppData {
  const AppData({
    this.logoUrl,
    this.aboutUsMarkdown,
    this.banners,
    this.broadcastItems,
    this.courses,
    this.socialMediaItems,
  });
  final String logoUrl;
  final String aboutUsMarkdown;
  final List<HeadingBanner> banners;
  final List<BroadcastItem> broadcastItems;
  final List<QuranCourse> courses;
  final List<SocialMediaItem> socialMediaItems;
}
