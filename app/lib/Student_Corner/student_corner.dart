import 'package:arrahma_mobile_app/Student_Corner/models/student_corner.dart';
import 'package:flutter/material.dart';

class StudentCorner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: Text(
          'Student Corner',
          style: TextStyle(color: Colors.white),
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
      icon: Icons.access_alarm,
    ),
    StudentCornerItem(
      title: 'Al-Fauz PDF',
      icon: Icons.access_alarm,
    ),
    StudentCornerItem(
      title: 'Al-Fauz PDF',
      icon: Icons.access_alarm,
    ),
    StudentCornerItem(
      title: 'Al-Fauz PDF',
      icon: Icons.access_alarm,
    ),
    StudentCornerItem(
      title: 'Al-Fauz PDF',
      icon: Icons.access_alarm,
    ),
    StudentCornerItem(
      title: 'Al-Fauz PDF',
      icon: Icons.access_alarm,
    ),
    StudentCornerItem(
      title: 'Al-Fauz PDF',
      icon: Icons.access_alarm,
    ),
    StudentCornerItem(
      title: 'Al-Fauz PDF',
      icon: Icons.access_alarm,
    ),
    StudentCornerItem(
      title: 'Al-Fauz PDF',
      icon: Icons.access_alarm,
    )
  ];

  Widget _buildStudentCornerList(context, StudentCornerItem item) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/fauz_pdf');
      },
      child: Container(
        color: Color(0xffdedbdb),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              item.title,
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
            ),
            Icon(
              item.icon,
              size: 50,
            ),
          ],
        ),
      ),
    );
  }
}
