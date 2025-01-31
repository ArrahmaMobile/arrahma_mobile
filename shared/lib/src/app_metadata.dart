import 'package:arrahma_shared/src/models/quran_course/v2/dua_category.dart';
import 'package:dart_json_mapper/dart_json_mapper.dart';

import 'models/models.dart';

@jsonSerializable
class AppData {
  const AppData({
    required this.logoUrl,
    required this.aboutUsMarkdown,
    required this.banners,
    required this.broadcastItems,
    required this.courses,
    this.otherCourseGroups,
    required this.socialMediaItems,
    required this.quickLinks,
    required this.drawerItems,
    this.duaCategories,
  });
  final List<DrawerItem> drawerItems;
  final List<QuickLink> quickLinks;
  final String logoUrl;
  final String aboutUsMarkdown;
  final List<HeadingBanner> banners;
  final List<BroadcastItem> broadcastItems;
  final List<QuranCourse> courses;
  final List<QuranCourseGroup>? otherCourseGroups;
  final List<SocialMediaItem> socialMediaItems;
  final List<DuaCategory>? duaCategories;
}
