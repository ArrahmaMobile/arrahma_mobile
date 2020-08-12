import 'package:arrahma_models/models.dart';
import 'package:flutter/material.dart';

class QuranRegistrationTab extends StatelessWidget {
  const QuranRegistrationTab({
    Key key,
    @required this.registration,
    @required this.title,
  }) : super(key: key);
  final CourseRegistration registration;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: const Color(0xff124570),
        centerTitle: true,
        title: Text(
          title,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'IMP: After you submit the form, you should receive a confirmation email. If you do not receive it,'
                  'please check your junk email or re-register with correct email address.',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Prerequisites:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Have you completed Taleem ul Quran course?',
                  style: TextStyle(
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
