import 'package:arrahma_mobile_app/all_courses/assorted_lectures/model/assorted_lecture.dart';
import 'package:flutter/material.dart';
import 'model/assorted_lectures.dart';

class AssortedLectures extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: const Color(0xff124570),
        centerTitle: true,
        title: Text(
          'Assorted Lectures',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                _lecturesList(context),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _lecturesList(BuildContext context) {
    return GridView.count(
      crossAxisSpacing: 8,
      mainAxisSpacing: 8,
      crossAxisCount: 2,
      shrinkWrap: true,
      childAspectRatio: 1.9,
      children: _assortedLectures
          .map((lecture) => _buildAssortedLecture(context, lecture))
          .toList(),
    );
  }

  final _assortedLectures = [
    AssortedLectureCategoryItem(
      title: 'New Lectures',
      lectures: List.generate(
        10,
        (index) => const AssortedLecture(
          title: 'Lecture on Zakat By Ustadh Abu Saif (2019)',
          subtitle: 'زکوٰۃ ـ استاد ابو سیف',
          audioLength: '12:14',
        ),
      ),
    ),
    AssortedLectureCategoryItem(
      title: 'Marriage',
      lectures: List.generate(
        10,
        (index) => const AssortedLecture(
          title: 'Kamyab Shadi Ke Sunehre Asool',
          subtitle: 'کامیاب شادی کے سنہرے اصول',
          audioLength: '12:14',
        ),
      ),
    ),
    AssortedLectureCategoryItem(
      title: 'Akhirah',
      lectures: List.generate(
        10,
        (index) => const AssortedLecture(
          title: 'Ya Allah Mera Nur Mukammal Karde',
          subtitle: 'یا اللہ میرا نور مکمّل کر دے',
          audioLength: '12:14',
        ),
      ),
    ),
    AssortedLectureCategoryItem(
      title: 'Months and Events',
      lectures: List.generate(
        10,
        (index) => const AssortedLecture(
          title: 'Lecture on Zakat By Ustadh Abu Saif (2019)',
          subtitle: 'زکوٰۃ ـ استاد ابو سیف',
          audioLength: '12:14',
        ),
      ),
    ),
    AssortedLectureCategoryItem(
      title: 'Adaab-e-Zindagi',
      lectures: List.generate(
        10,
        (index) => const AssortedLecture(
          title: 'Ghar ke sukoon ka raaz',
          subtitle: 'سورہٴ الروم آیت ٢١  گھر کے سکون کا را',
          audioLength: '12:14',
        ),
      ),
    ),
    AssortedLectureCategoryItem(
      title: "Rubb Se Taa'luk",
      lectures: List.generate(
        10,
        (index) => const AssortedLecture(
          title: 'Qabuliyate amal ki lazmi shart ',
          subtitle: 'سورہٴ الزمر آیت ٢  قبولیتِ عمل کی لازمی شرط',
          audioLength: '12:14',
        ),
      ),
    ),
    AssortedLectureCategoryItem(
      title: 'Imaan',
      lectures: List.generate(
        10,
        (index) => const AssortedLecture(
          title: 'Qulb-e-Saleem',
          subtitle: 'قلبِ سلیم',
          audioLength: '12:14',
        ),
      ),
    ),
    AssortedLectureCategoryItem(
      title: 'Humare Rasool ﷺ',
      lectures: List.generate(
        10,
        (index) => const AssortedLecture(
          title: 'Sifate Mustufa(saw){New}',
          subtitle: 'صفات مصطفی',
          audioLength: '12:14',
        ),
      ),
    ),
    AssortedLectureCategoryItem(
      title: 'Duniya ki zindagi',
      lectures: List.generate(
        10,
        (index) => const AssortedLecture(
          title: 'Depression Aur Uska Ilaaj  ',
          subtitle: 'ڈپریشن اور اسکا علاج',
          audioLength: '12:14',
        ),
      ),
    ),
    AssortedLectureCategoryItem(
      title: 'Quran/ilm',
      lectures: List.generate(
        10,
        (index) => const AssortedLecture(
          title: 'Quran mai kya parde ka hukum hai?',
          subtitle: ' سورہٴ الاحزاب آیت ٥٩  قرآن می کیا پردے کا حکم ہے؟',
          audioLength: '12:14',
        ),
      ),
    ),
    AssortedLectureCategoryItem(
      title: 'Humare Aamal',
      lectures: List.generate(
        10,
        (index) => const AssortedLecture(
          title: 'Laanat Ke Mustahiq Log ',
          subtitle: 'لعنت کے مستحق لوگ',
          audioLength: '12:14',
        ),
      ),
    ),
    AssortedLectureCategoryItem(
      title: 'Miscellaneous',
      lectures: List.generate(
        10,
        (index) => const AssortedLecture(
          title: 'Na Shukre na Bano ',
          subtitle: 'نا شکرے نہ بنو',
          audioLength: '12:14',
        ),
      ),
    ),
  ];

  Widget _buildAssortedLecture(
      BuildContext context, AssortedLectureCategoryItem lecture) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/assorted_lecture_page',
            arguments: lecture);
      },
      child: Container(
        color: const Color(0xff124570),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              lecture.title,
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
