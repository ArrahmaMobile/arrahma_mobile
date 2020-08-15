import 'package:arrahma_mobile_app/all_courses/quran_courses/quran_course_page.dart';
import 'package:arrahma_models/models.dart';
import 'package:flutter/material.dart';

class AllCourses extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color(0xff124570),
        centerTitle: true,
        title: const Text(
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
                description: 'The Openisssng',
                lessons: [
                  Lesson(
                    title: 'Lessssson',
                    lessonNum: '1',
                    ayahNum: '1-3',
                    uploadDate: '08/17/2020',
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
      tafseer: QuranCourseTafseer(
        title: 'Surah Al-Bassssssqarah',
        surahs: [
          Surah(
            name: 'Surah Al-Baqarah',
            arabicName: 'الفاتحۃ',
            description: 'The Opening',
            lessons: [
              Lesson(
                lessonNum: '1',
                ayahNum: '1-3',
                uploadDate: '08/17/2020',
                rootWordPdfUrls: [''],
                translationAudioUrls: [''],
                tafseerAudioUrls: [''],
                refMaterials: [''],
              )
            ],
          )
        ],
      ),
      tests: [
        QuranCourseTest(
          title: '',
        )
      ],
    ),
    const QuranCourse(
      title: 'Taleemul Quran',
      imageUrl: 'assets/images/courses/taleemul_quran.png',
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
                description: 'The Openisssng',
                lessons: [
                  Lesson(
                    title: 'Lessssson',
                    lessonNum: '1',
                    ayahNum: '1-3',
                    uploadDate: '08/17/2020',
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
      tafseer: QuranCourseTafseer(
        title: 'Surah Al-Bassssssqarah',
        surahs: [
          Surah(
            name: 'Surah Al-Baqarah',
            arabicName: 'الفاتحۃ',
            description: 'The Opening',
            lessons: [
              Lesson(
                lessonNum: '1',
                ayahNum: '1-3',
                uploadDate: '08/17/2020',
                rootWordPdfUrls: [''],
                translationAudioUrls: [''],
                tafseerAudioUrls: [''],
                refMaterials: [''],
              )
            ],
          )
        ],
      ),
      tests: [
        QuranCourseTest(
          title: 'asd',
        )
      ],
    ),
    const QuranCourse(
      title: 'Fehmul Quran',
      imageUrl: 'assets/images/courses/fehmul_quran.png',
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
                description: 'The Openisssng',
                lessons: [
                  Lesson(
                    title: 'Lessssson',
                    lessonNum: '1',
                    ayahNum: '1-3',
                    uploadDate: '08/17/2020',
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
      tafseer: QuranCourseTafseer(
        title: 'Surah Al-Bassssssqarah',
        surahs: [
          Surah(
            name: 'Surah Al-Baqarah',
            arabicName: 'الفاتحۃ',
            description: 'The Opening',
            lessons: [
              Lesson(
                lessonNum: '1',
                ayahNum: '1-3',
                uploadDate: '08/17/2020',
                rootWordPdfUrls: [''],
                translationAudioUrls: [''],
                tafseerAudioUrls: [''],
                refMaterials: [''],
              )
            ],
          )
        ],
      ),
      tests: [
        QuranCourseTest(
          title: '',
        )
      ],
    ),
    const QuranCourse(
      title: 'Course In Pashtu ',
      imageUrl: 'assets/images/courses/course_in_pashtu.png',
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
                description: 'The Openisssng',
                lessons: [
                  Lesson(
                    title: 'Lessssson',
                    lessonNum: '1',
                    ayahNum: '1-3',
                    uploadDate: '08/17/2020',
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
      tafseer: QuranCourseTafseer(
        title: 'Surah Al-Bassssssqarah',
        surahs: [
          Surah(
            name: 'Surah Al-Baqarah',
            arabicName: 'الفاتحۃ',
            description: 'The Opening',
            lessons: [
              Lesson(
                lessonNum: '1',
                ayahNum: '1-3',
                uploadDate: '08/17/2020',
                rootWordPdfUrls: [''],
                translationAudioUrls: [''],
                tafseerAudioUrls: [''],
                refMaterials: [''],
              )
            ],
          )
        ],
      ),
      tests: [
        QuranCourseTest(
          title: '',
        )
      ],
    ),
    const QuranCourse(
      title: 'Ilmul Yaqeen',
      imageUrl: 'assets/images/courses/ilmul_yaqeen.png',
    ),
    const QuranCourse(
      title: 'Ahsanul Bayan',
      imageUrl: 'assets/images/courses/ahsanul_bayan.png',
      courseDetailPdfUrl: '',
    ),
    const QuranCourse(
      title: 'Al Furqan',
      imageUrl: 'assets/images/courses/fehmul_quran.png',
      courseDetailPdfUrl: '',
    ),
    const QuranCourse(
      title: 'Seerah',
      imageUrl: 'assets/images/courses/seerah.png',
      courseDetailPdfUrl: '',
    ),
    const QuranCourse(
      title: 'Al Misbah (Whatsapp Program)',
      imageUrl: 'assets/images/courses/al_misbah.png',
      courseDetailPdfUrl: '',
    ),
    const QuranCourse(
      title: 'Weekly Gems',
      imageUrl: 'assets/images/courses/weekly_gems.png',
    ),
    const QuranCourse(
      title: 'Assorted Lectures',
      imageUrl: 'assets/images/courses/assorted_letures.png',
    ),
    const QuranCourse(
      title: 'Tazkeer',
      imageUrl: 'assets/images/courses/tazkeer.png',
    ),
    const QuranCourse(
      title: 'Weekly Dua, Sunnah & Zikr',
      imageUrl: 'assets/images/courses/weekly_dua_sunnat_zikr.png',
    ),
  ];

  Widget _buildCourse(BuildContext context, Course course) {
    return GestureDetector(
      onTap: () {
        Navigator.push<dynamic>(
            context,
            MaterialPageRoute<dynamic>(
                builder: (_) => const QuranCoursePage(
                      title: '',
                      course: QuranCourse(),
                    )));
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
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ],
      ),
    );
  }
}
