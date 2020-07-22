import 'package:arrahma_mobile_app/Lectures/Pashto_Course/model/pashto_course.dart';
import 'package:flutter/material.dart';

class PashtoCourse extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          'Pashto Course',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: [
            _pashtoCourseList(context),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _pashtoCourseList(BuildContext context) {
    return GridView.count(
      crossAxisSpacing: 8,
      mainAxisSpacing: 8,
      crossAxisCount: 2,
      shrinkWrap: true,
      childAspectRatio: 1,
      children: _pashtoCourse
          .map((item) => _buildPashtoCourse(context, item))
          .toList(),
    );
  }

  final _pashtoCourse = [
    PashtoCourseItem(
      title: 'Quran Tafseer 2019',
      pageRoute: '/quran_tafseer_tab',
    ),
    PashtoCourseItem(
      title: 'Selected Surahs',
      pageRoute: '',
    )
  ];

  Widget _buildPashtoCourse(BuildContext context, PashtoCourseItem item) {
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
