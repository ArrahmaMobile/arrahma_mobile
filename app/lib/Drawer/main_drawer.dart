import 'dart:ui';
import 'package:flutter/material.dart';

import 'model/drawer.dart';

class MainDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
          children:
              _drawer.map((list) => _buildDrawer(context, list)).toList()),
    );
  }

  final _drawer = [
    const DrawerList(
      title: 'Home',
      pageRoute: '/home',
    ),
    const DrawerList(
      title: 'About Us',
      pageRoute: '/about_us',
    ),
    const DrawerList(
      title: 'All Courses',
      pageRoute: '/all_courses',
    ),
    const DrawerList(
      title: 'Lectures',
      pageRoute: '/lectures',
    ),
    const DrawerList(
      title: 'Arabic Grammer',
      pageRoute: '/arabic_grammer',
    ),
    const DrawerList(
      title: 'Tajweed',
      pageRoute: '/tajweed',
    ),
    const DrawerList(
      title: 'Our Nabi',
      pageRoute: '/our_nabi',
    ),
    const DrawerList(
      title: 'Student Corner',
      pageRoute: '/student_corner',
    ),
    const DrawerList(
      title: 'Reading Material',
      pageRoute: '/reading_material',
    ),
  ];

  Widget _buildDrawer(BuildContext context, DrawerList list) {
    return ListTile(
      title: Text(
        list.title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
      onTap: () {
        Navigator.pushNamed(context, list.pageRoute);
      },
    );
  }
}
