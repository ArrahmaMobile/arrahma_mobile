import 'package:arrahma_mobile_app/Student_Corner/models/student_corner.dart';
import 'package:flutter/material.dart';

class StudentCorner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color(0xff124570),
        centerTitle: true,
        title: const Text(
          'Student Corner',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            _studentCornerList(context),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _studentCornerList(BuildContext context) {
    return GridView.count(
      crossAxisSpacing: 8,
      mainAxisSpacing: 8,
      crossAxisCount: 2,
      shrinkWrap: true,
      childAspectRatio: 1.5,
      children: _studentCornerItem
          .map((item) => _buildStudentCornerList(context, item))
          .toList(),
    );
  }

  final _studentCornerItem = [
    const StudentCornerItem(
      title: 'Weekly Updates',
      pageRoute: '/student_corner',
    ),
    const StudentCornerItem(
      title: 'FQ & TQ Tests',
      pageRoute: '/quran_test_page',
    ),
    const StudentCornerItem(
      title: 'ATQ Tests & Assignments',
      pageRoute: '/quran_test_page',
    ),
    const StudentCornerItem(
      title: 'Al-Fauz Pdf',
      pageRoute: '/fauz_pdf',
    ),
    const StudentCornerItem(
      title: 'Sisters Support',
      pageRoute: '/student_corner',
    ),
    const StudentCornerItem(
      title: 'Phone Attendance Req. Form',
      pageRoute: '/student_corner',
    ),
    const StudentCornerItem(
      title: 'Tafseer Attendance',
      pageRoute: '/student_corner',
    ),
  ];

  Widget _buildStudentCornerList(BuildContext context, StudentCornerItem item) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, item.pageRoute);
      },
      child: Container(
        color: const Color(0xff124570),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              item.title,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
