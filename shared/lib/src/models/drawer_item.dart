import 'package:dart_json_mapper/dart_json_mapper.dart';

import 'models.dart';

@jsonSerializable
class DrawerItem {
  const DrawerItem({
    required this.title,
    this.link,
    this.media,
    this.content,
    this.children,
  });
  final String title;
  final Item? link;
  final MediaContent? media;
  final QuranCourseContent? content;
  final List<DrawerItem>? children;
}
