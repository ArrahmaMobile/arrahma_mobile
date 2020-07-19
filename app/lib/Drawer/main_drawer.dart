import 'dart:ui';
import 'package:arrahma_mobile_app/Drawer/model/drawer.dart';
import 'package:flutter/material.dart';

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
    DrawerList(
      title: 'Home',
      pageRoute: '/home',
    ),
    DrawerList(
      title: 'About Us',
      pageRoute: '/about_us',
    ),
    DrawerList(
      title: 'All Courses',
      pageRoute: '/all_courses',
    ),
    DrawerList(
      title: 'Lectures',
      pageRoute: '/lectures',
    ),
    DrawerList(
      title: 'Grammer',
      pageRoute: '/arabic_grammer',
    ),
    DrawerList(
      title: 'Tajweed',
      pageRoute: '/tajweed',
    ),
    DrawerList(
      title: 'Our Nabi',
      pageRoute: '/our_nabi',
    ),
    DrawerList(
      title: 'Student Corner',
      pageRoute: '/student_corner',
    ),
    DrawerList(
      title: 'Reading Material',
      pageRoute: '/reading_material',
    ),
  ];

  Widget _buildDrawer(BuildContext context, DrawerList list) {
    return ListTile(
      title: Text(
        list.title,
        style: new TextStyle(
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
