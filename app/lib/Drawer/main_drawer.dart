import 'dart:ui';
import 'package:flutter/material.dart';

class MainDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          ListTile(
            title: Text(
              'Home',
              style: new TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () {
              Navigator.pushNamed(context, '/home');
            },
          ),
          ListTile(
            title: Text(
              'About Us',
              style: new TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () {
              Navigator.pushNamed(context, '/about_us');
            },
          ),
          ListTile(
            title: Text(
              'All Courses',
              style: new TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () {
              Navigator.pushNamed(context, '/all_courses');
            },
          ),
          ListTile(
            title: Text(
              'Letures',
              style: new TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () {
              Navigator.pushNamed(context, '/lectures');
            },
          ),
          ListTile(
            title: Text(
              'Grammer',
              style: new TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () {
              Navigator.pushNamed(context, '/grammer');
            },
          ),
          ListTile(
            title: Text(
              'Tajweed',
              style: new TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () {
              Navigator.pushNamed(context, '/tajweed');
            },
          ),
          ListTile(
            title: Text(
              'Our Nabi',
              style: new TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () {
              Navigator.pushNamed(context, '/our_nabi');
            },
          ),
          ListTile(
            title: Text(
              'Student Corner',
              style: new TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () {
              Navigator.pushNamed(context, '/student_corner');
            },
          ),
          ListTile(
            title: Text(
              'Reading Material',
              style: new TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () {
              Navigator.pushNamed(context, '/reading_material');
            },
          ),
        ],
      ),
    );
  }
}
