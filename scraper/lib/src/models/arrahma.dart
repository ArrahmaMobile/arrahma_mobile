import 'package:scraper/src/models/banner.dart';
import 'package:scraper/src/models/broadcast_link.dart';
import 'package:scraper/src/models/course.dart';

class Arrahma {
  const Arrahma(
      {this.logoUrl, this.banners, this.broadcastLinks, this.courses});
  final String logoUrl;
  final List<Banner> banners;
  final List<BroadcastLink> broadcastLinks;
  final List<Course> courses;
}
