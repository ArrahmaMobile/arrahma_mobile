import 'dart:ui';
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
      child: ListView(
        children: items?.map((item) => _buildDrawer(context, item))?.toList(),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context, DrawerItem item) {
    return ExpansionTile(
      title: Text(
        item.title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
      children: [],
    );
  }
}
