import 'models/models.dart';

class AppData {
  const AppData({
    this.logoUrl,
    this.banners,
    this.broadcastItems,
    this.courses,
    this.socialMediaItems,
  });
  final String logoUrl;
  final List<HeadingBanner> banners;
  final List<BroadcastItem> broadcastItems;
  final List<QuranCourse> courses;
  final List<SocialMediaItem> socialMediaItems;
}
