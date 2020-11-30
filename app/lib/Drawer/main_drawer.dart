import 'dart:ui';
import 'package:arrahma_mobile_app/Home_Page/home_page.dart';
import 'package:arrahma_mobile_app/all_courses/all_courses.dart';
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
    ),
    const DrawerList(
      title: 'About Us',
    ),
    DrawerList(
      title: 'All Courses',
      pageRoute: () => AllCourses(),
    ),
    const DrawerList(
      title: 'Lectures',
    ),
    const DrawerList(
      title: 'Arabic Grammer',
    ),
    const DrawerList(
      title: 'Tajweed',
    ),
    const DrawerList(
      title: 'Our Nabi',
    ),
    const DrawerList(
      title: 'Student Corner',
    ),
    const DrawerList(
      title: 'Reading Material',
    ),
  ];

  Widget _buildDrawer(BuildContext context, DrawerList list) {
    return ListTile(
      title: Text(
        list.title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
      onTap: () {
        Navigator.push<dynamic>(
            context,
            MaterialPageRoute<dynamic>(
                builder: (_) => list?.pageRoute?.call() ?? HomePage()));
      },
    );
  }
}
