import 'package:arrahma_models/models.dart';
import 'package:flutter/material.dart';
import 'package:inherited_state/inherited_state.dart';

class AllCourses extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appData = context.on<AppData>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          'All Courses',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(10.0),
        child: GridView.count(
          crossAxisCount: 3,
          crossAxisSpacing: 20,
          mainAxisSpacing: 8,
          shrinkWrap: true,
          childAspectRatio: .90,
          children: appData.courses
              .map((course) => _buildCourse(context, course))
              .toList(),
        ),
      ),
    );
  }

  Widget _buildCourse(BuildContext context, Course course) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, course.pageRoute, arguments: course);
      },
      child: Column(
        children: <Widget>[
          Image.asset(
            course.imageUrl,
            width: 80,
            height: 80,
          ),
          Text(
            course.title,
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ],
      ),
    );
  }
}
