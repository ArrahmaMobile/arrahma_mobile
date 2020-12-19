import 'dart:ui';
import 'package:arrahma_mobile_app/Drawer/menu_item_list.dart';
import 'package:arrahma_shared/shared.dart';
import 'package:flutter/material.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({
    Key key,
    this.items,
  }) : super(key: key);
  final List<DrawerItem> items;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: MenuItemList(
        items: items,
      ),
    );
  }
}
