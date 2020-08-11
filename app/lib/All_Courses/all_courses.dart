import 'package:arrahma_models/models.dart';
import 'package:flutter/material.dart';

class AllCourses extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: const Color(0xff124570),
        centerTitle: true,
        title: Text(
          'All Courses',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
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
    const QuranCourse(
      title: 'Adv Taleemul Quran',
      imageUrl: 'assets/images/courses/adv_taleemul_quran.png',
      pageRoute: '/quran_course_page',
      courseDetailPdfUrl: '',
      registration: CourseRegistration(
        courseRegistration: '',
      ),
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
                    title: 'Surah Al-Baqarah',
                    rootWordPdfUrls: ['hee'],
                    translationAudioUrls: ['hee'],
                    tafseerAudioUrls: ['hee'],
                    refMaterials: ['hee'],
                  )
                ],
              ),
            ],
          ),
        ],
      ),
      tafseer: [
        QuranCourseTafseer(
          title: 'Surah Al-Baqarah',
          surah: [
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
            )
          ],
        )
      ],
      tests: [
        QuranCourseTest(
          title: '',
        )
      ],
    ),
    const QuranCourse(
      title: 'Taleem Quran',
      imageUrl: 'assets/images/courses/taleemul_quran.png',
      pageRoute: '/quran_course_page',
      courseDetailPdfUrl: '',
      registration: CourseRegistration(
        courseRegistration: '',
      ),
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
                    title: 'Surah Al-Baqarah',
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
      tafseer: [],
      tests: [
        QuranCourseTest(
          title: '',
        )
      ],
    ),
    const QuranCourse(
      title: 'Course In Pashtu',
      imageUrl: 'assets/images/courses/course_in_pashtu.png',
      pageRoute: '/quran_course_page',
      courseDetailPdfUrl: '',
      registration: CourseRegistration(
        courseRegistration: '',
      ),
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
      tafseer: [],
      tests: [
        QuranCourseTest(
          title: '',
        )
      ],
    ),
    const QuranCourse(
      title: 'Ilmul Yaqeen',
      imageUrl: 'assets/images/courses/ilmul_yaqeen.png',
      pageRoute: '/supplementary_course',
    ),
    const QuranCourse(
      title: 'Ahsanul Bayan',
      imageUrl: 'assets/images/courses/ahsanul_bayan.png',
      pageRoute: '/supplementary_course',
    ),
    const QuranCourse(
      title: 'Al Furqan',
      imageUrl: 'assets/images/courses/fehmul_quran.png',
      pageRoute: '/supplementary_course',
      courseDetailPdfUrl: '',
    ),
    const QuranCourse(
        title: 'Seerah',
        imageUrl: 'assets/images/courses/seerah.png',
        pageRoute: '/supplementary_course'),
    const QuranCourse(
        title: 'Al Misbah (Whatsapp Program)',
        imageUrl: 'assets/images/courses/al_misbah.png',
        pageRoute: '/supplementary_course'),
    const QuranCourse(
        title: 'Weekly Gems',
        imageUrl: 'assets/images/courses/weekly_gems.png',
        pageRoute: '/weekly_gems_course'),
    const QuranCourse(
        title: 'Assorted Lectures',
        imageUrl: 'assets/images/courses/assorted_letures.png',
        pageRoute: '/assorted_lectures'),
    const QuranCourse(
        title: 'Tazkeer',
        imageUrl: 'assets/images/courses/tazkeer.png',
        pageRoute: '/tazkeer'),
    const QuranCourse(
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
