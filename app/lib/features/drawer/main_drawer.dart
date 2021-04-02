import 'package:arrahma_shared/shared.dart';
import 'package:flutter/material.dart';

import 'menu_item_list.dart';

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
        items: [
          const DrawerItem(title: 'Home'),
          const DrawerItem(title: 'About Us'),
          ...items,
          const DrawerItem(title: 'Contact Us'),
          const DrawerItem(title: 'Settings')
        ],
      ),
    );
  }
}
