import '../../shared.dart';

class DrawerItem {
  const DrawerItem({
    this.title,
    this.link,
    this.children,
  });
  final String title;
  final Item link;
  final List<DrawerItem> children;
}
