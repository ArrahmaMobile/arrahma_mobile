import 'package:arrahma_models/models.dart';
import 'package:arrahma_models/src/course_item.dart';

class AppMetadata {
  const AppMetadata(
      {this.logoUrl, this.banners, this.broadcastLinks, this.courses});
  final String logoUrl;
  final List<HeadingBanner> banners;
  final List<BroadcastItem> broadcastLinks;
  final List<CourseItem> courses;
}
