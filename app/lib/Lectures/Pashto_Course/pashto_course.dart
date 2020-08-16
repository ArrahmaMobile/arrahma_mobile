import 'package:arrahma_mobile_app/Lectures/Pashto_Course/model/pashto_course.dart';
import 'package:flutter/material.dart';

class PashtoCourse extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color(0xff124570),
        centerTitle: true,
        title: const Text(
          'Pashto Course',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
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
      childAspectRatio: 1.5,
      children: _pashtoCourse
          .map((item) => _buildPashtoCourse(context, item))
          .toList(),
    );
  }

  final _pashtoCourse = [
    const PashtoCourseItem(
      title: 'Quran Tafseer 2019',
      pageRoute: '/quran_tafseer_tab',
    ),
    const PashtoCourseItem(
      title: 'Selected Surahs',
      pageRoute: '',
    )
  ];

  Widget _buildPashtoCourse(BuildContext context, PashtoCourseItem item) {
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
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }
}
