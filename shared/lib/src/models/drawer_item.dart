import 'models.dart';

class DrawerItem {
  const DrawerItem({
    this.title,
    this.link,
    this.media,
    this.content,
    this.children,
  });
  final String title;
  final Item link;
  final MediaContent media;
  final QuranCourseContent content;
  final List<DrawerItem> children;
}
