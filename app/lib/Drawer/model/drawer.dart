import 'package:flutter/widgets.dart';

class DrawerList {
  const DrawerList({this.title, this.pageRoute});
  final String title;
  final Widget Function() pageRoute;
}
