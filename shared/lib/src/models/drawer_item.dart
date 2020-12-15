import '../../shared.dart';

class DrawerItem {
  const DrawerItem({
    this.title,
    this.link,
    this.content,
    this.children,
  });
  final String title;
  final Item link;
  final QuranCourseContent content;
  final List<DrawerItem> children;
}
