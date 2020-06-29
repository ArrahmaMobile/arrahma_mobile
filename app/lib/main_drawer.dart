import 'dart:ui';
import 'package:arrahma_mobile_app/all_courses.dart';
import 'package:arrahma_mobile_app/grammar.dart';
import 'package:arrahma_mobile_app/letures.dart';
import 'package:arrahma_mobile_app/reading_material.dart';
import 'package:arrahma_mobile_app/student_corner.dart';
import 'package:arrahma_mobile_app/tajweed.dart';
import 'package:flutter/material.dart';
import 'about_us.dart';
import 'our_nabi.dart';

class MainDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(children: [
      ListTile(
        title: Text(
          'Home',
          style: new TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        onTap: () {},
      ),
      ListTile(
        title: Text(
          'About Us',
          style: new TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AboutUs()),
          );
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
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AllCourses()),
          );
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
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Lectures()),
          );
        },
      ),
      ListTile(
        title: Text(
          'Grammar',
          style: new TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Grammer()),
          );
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
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Tajweed()),
          );
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
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => OurNabi()),
          );
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
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => StudentCorner()),
          );
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
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ReadingMaterial()),
          );
        },
      ),
    ]));
  }
}
