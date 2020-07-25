import 'package:arrahma_models/models.dart';
import 'package:flutter/material.dart';

class AllCourses extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
          children:
              _courses.map((course) => _buildCourse(context, course)).toList(),
        ),
      ),
    );
  }

  final _courses = <Course>[
    QuranCourse(
      title: 'Adv Taleemul Quran',
      imageUrl: 'assets/images/courses/adv_taleemul_quran.png',
      pageRoute: '/quran_course_page',
      courseDetailPdfUrl: '',
      tajweed: QuranCourseTajweed(
        introductionUrl: '',
        items: [
          QuranCourseTajweedItem(
            title: 'Surah Al-Baqarah',
            surahs: [
              Surah(
                name: 'Surah Al-Baqarah',
                arabicName: 'الفاتحۃ',
                description: 'The Opening',
                lessons: [
                  Lesson(
                    title: '',
                    rootWordPdfUrls: [''],
                    translationAudioUrls: [''],
                    tafseerAudioUrls: [''],
                    refMaterials: [''],
                  )
                ],
              ),
            ],
          ),
        ],
      ),
    ),
    QuranCourse(
      title: 'Taleem Quran',
      imageUrl: 'assets/images/courses/taleemul_quran.png',
      pageRoute: '/quran_course_page',
      courseDetailPdfUrl: '',
      tafseer: [],
      tajweed: QuranCourseTajweed(
        introductionUrl: '',
        items: [
          QuranCourseTajweedItem(
            title: 'Surah Al-Baqarah',
            surahs: [
              Surah(
                name: 'hi',
                arabicName: 'hi',
                description: 'hh',
              )
            ],
          ),
        ],
      ),
    ),
    QuranCourse(
      title: 'Fehmul Quran',
      imageUrl: 'assets/images/courses/fehmul_quran.png',
      pageRoute: '/quran_course_page',
      courseDetailPdfUrl: '',
      tajweed: QuranCourseTajweed(
        introductionUrl: '',
        items: [
          QuranCourseTajweedItem(
            title: 'Surah Al-Baqarah',
            surahs: [
              Surah(
                name: 'hi',
                arabicName: 'hi',
                description: 'hh',
              )
            ],
          ),
        ],
      ),
    ),
    QuranCourse(
      title: 'Course In Pashtu',
      imageUrl: 'assets/images/courses/course_in_pashtu.png',
      pageRoute: '/quran_course_page',
      tajweed: QuranCourseTajweed(
        introductionUrl: '',
        items: [
          QuranCourseTajweedItem(
            title: 'Surah Al-Baqarah',
            surahs: [
              Surah(
                name: 'Surah Al-Fatiha ',
                arabicName: 'الفاتحۃ',
                description: 'The Opening',
                lessons: [
                  Lesson(
                    lessonNum: 'Lesson 1: ',
                    lessonName: 'Surah Al-Baqarah',
                    lessonAyah: 'Ayah 1-5',
                    title: 'hiii',
                    rootWordPdfUrls: ['hii'],
                    translationAudioUrls: ['hii'],
                    tafseerAudioUrls: ['hii'],
                    refMaterials: ['hiii'],
                  )
                ],
              ),
            ],
          )
        ],
      ),
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
        pageRoute: '/assorted_lectures'),
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
