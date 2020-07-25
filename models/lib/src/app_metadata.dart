import '../models.dart';

class AppMetadata {
  const AppMetadata(
      {this.logoUrl, this.banners, this.broadcastLinks, this.courses});
  final String logoUrl;
  final List<HeadingBanner> banners;
  final List<BroadcastItem> broadcastLinks;
  final List<CourseItem> courses;
}
