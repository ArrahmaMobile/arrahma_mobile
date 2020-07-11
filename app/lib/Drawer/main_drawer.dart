import 'dart:ui';
import 'package:arrahma_mobile_app/About_Us/about_us.dart';
import 'package:arrahma_mobile_app/All_Courses/all_courses.dart';
import 'package:arrahma_mobile_app/Contact_Us/contact_us.dart';
import 'package:arrahma_mobile_app/Grammer/grammar.dart';
import 'package:arrahma_mobile_app/Home_Page/home_page.dart';
import 'package:arrahma_mobile_app/Lectures/letures.dart';
import 'package:arrahma_mobile_app/Media_Player/media_player.dart';
import 'package:arrahma_mobile_app/Our_Nabi/our_nabi.dart';
import 'package:arrahma_mobile_app/Reading_Material/reading_material.dart';
import 'package:arrahma_mobile_app/Student_Corner/student_corner.dart';
import 'package:arrahma_mobile_app/Tajweed/tajweed.dart';
import 'package:flutter/material.dart';

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
      ListTile(
        title: Text(
          'Media Player',
          style: new TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        onTap: () {
          Navigator.pushNamed(context, '/media_player_screen');
        },
      ),
      ListTile(
        title: Text(
          'Contact Us',
          style: new TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        onTap: () {
          Navigator.pushNamed(context, '/contact_us');
        },
      ),
    ]));
  }
}
