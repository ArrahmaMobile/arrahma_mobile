import 'package:arrahma_mobile_app/All_Courses/quran_courses/models/quran_course.dart';
import 'package:flutter/material.dart';
import 'models/course.dart';

class AllCourses extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          'All Courses',
          style: TextStyle(color: Colors.black),
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
          children:
              _courses.map((course) => _buildCourse(context, course)).toList(),
        ),
      ),
    );
  }

  final _courses = [
    Course(
      title: 'Adv Taleemul Quran',
      imageUrl: 'assets/images/courses/adv_taleemul_quran.png',
      pageRoute: '/quran_course_page',
      data: QuranCourse(
        title: 'Adv Taleemul Quran',
        courseDetailPdfUrl: '',
      ),
    ),
    Course(
      title: 'Taleem Quran',
      imageUrl: 'assets/images/courses/taleemul_quran.png',
      pageRoute: '/quran_course_page',
      data: QuranCourse(
        title: 'Taleem Quran',
        courseDetailPdfUrl: '',
      ),
    ),
    Course(
      title: 'Fehmul Quran',
      imageUrl: 'assets/images/courses/fehmul_quran.png',
      pageRoute: '/quran_course_page',
      data: QuranCourse(
        title: 'Fehmul Quran',
        courseDetailPdfUrl: '',
      ),
    ),
    Course(
      title: 'Course In Pashtu',
      imageUrl: 'assets/images/courses/course_in_pashtu.png',
      pageRoute: '/quran_course_page',
      data: QuranCourse(title: 'Course In Pashtu'),
    ),
    Course(
        title: 'Ilmul Yaqeen',
        imageUrl: 'assets/images/courses/ilmul_yaqeen.png',
        pageRoute: '/ilmul_taqeen'),
    Course(
        title: 'Ahsanul Bayan',
        imageUrl: 'assets/images/courses/ahsanul_bayan.png',
        pageRoute: '/ahsanul_bayan'),
    Course(
        title: 'Al Furqan',
        imageUrl: 'assets/images/courses/al_furqan.png',
        pageRoute: '/al_furqan'),
    Course(
        title: 'Seerah',
        imageUrl: 'assets/images/courses/seerah.png',
        pageRoute: '/seerah_course'),
    Course(
        title: 'Al Misbah (Whatsapp Program)',
        imageUrl: 'assets/images/courses/al_misbah.png',
        pageRoute: '/al_misbah'),
    Course(
        title: 'Weekly Gems',
        imageUrl: 'assets/images/courses/weekly_gems.png',
        pageRoute: '/weekly_gems_course'),
    Course(
        title: 'Assorted Lectures',
        imageUrl: 'assets/images/courses/assorted_letures.png',
        pageRoute: '/assorted_lectures_course'),
    Course(
        title: 'Tazkeer',
        imageUrl: 'assets/images/courses/tazkeer.png',
        pageRoute: '/tazkeer'),
    Course(
        title: 'Weekly Dua, Sunnah & Zikr',
        imageUrl: 'assets/images/courses/weekly_dua_sunnat_zikr.png',
        pageRoute: '/dua_sunnah_zikr'),
  ];

  Widget _buildCourse(BuildContext context, Course course) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, course.pageRoute, arguments: course.data);
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
