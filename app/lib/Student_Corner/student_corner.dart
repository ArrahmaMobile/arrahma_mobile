import 'package:arrahma_mobile_app/Student_Corner/models/student_corner.dart';
import 'package:flutter/material.dart';

class StudentCorner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          'Student Corner',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(10.0),
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
      childAspectRatio: 1.9,
      children: _studentCornerItem
          .map((item) => _buildStudentCornerList(context, item))
          .toList(),
    );
  }

  final _studentCornerItem = [
    StudentCornerItem(
      title: 'Al-Fauz PDF',
      pageRoute: '',
    ),
    StudentCornerItem(
      title: 'FQ & TQ Tests',
      pageRoute: '',
    ),
    StudentCornerItem(
      title: 'ATQ Tests & Assignments',
      pageRoute: '',
    ),
    StudentCornerItem(
      title: 'Al-Fauz Pdf',
      pageRoute: '/fauz_pdf',
    ),
    StudentCornerItem(
      title: 'Sisters Support',
      pageRoute: '',
    ),
    StudentCornerItem(
      title: 'Phone Attendance Req. Form',
    ),
    StudentCornerItem(
      title: 'Tafseer Attendance',
      pageRoute: '',
    ),
  ];

  Widget _buildStudentCornerList(context, StudentCornerItem item) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, item.pageRoute);
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            item.title,
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ],
      ),
    );
  }
}
