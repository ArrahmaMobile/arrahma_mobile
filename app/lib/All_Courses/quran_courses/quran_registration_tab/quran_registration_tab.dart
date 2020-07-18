import 'package:arrahma_mobile_app/All_Courses/quran_courses/models/course_registration.dart';
import 'package:flutter/material.dart';

class QuranRegistrationTab extends StatelessWidget {
  const QuranRegistrationTab({Key key, this.registration, this.title})
      : super(key: key);
  final CourseRegistration registration;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          title,
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ConstrainedBox(
            constraints: BoxConstraints(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'IMP: After you submit the form, you should receive a confirmation email. If you do not receive it,'
                  'please check your junk email or re-register with correct email address.',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black),
                ),
                SizedBox(height: 20),
                Text(
                  "Prerequisites:",
                  style: new TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Have you completed Taleem ul Quran course?',
                  style: new TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
