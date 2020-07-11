import 'package:arrahma_mobile_app/About_Us/about_us.dart';
import 'package:arrahma_mobile_app/All_Courses/Adv_Taleemul_Quran/Detail_Tab/details_page.dart';
import 'package:arrahma_mobile_app/All_Courses/Adv_Taleemul_Quran/Registration_Tab/registration_page.dart';
import 'package:arrahma_mobile_app/All_Courses/Adv_Taleemul_Quran/Tafseer_Tab/Favorite_Juz/favorite_juz.dart';
import 'package:arrahma_mobile_app/All_Courses/Adv_Taleemul_Quran/Tafseer_Tab/Juz_Detail_page/Favorite_Surah/favorite_surah.dart';
import 'package:arrahma_mobile_app/All_Courses/Adv_Taleemul_Quran/Tafseer_Tab/Juz_Detail_page/Lesson_Detail_Page/lesson_detail_page.dart';
import 'package:arrahma_mobile_app/All_Courses/Adv_Taleemul_Quran/Tafseer_Tab/tafseer_page.dart';
import 'package:arrahma_mobile_app/All_Courses/Adv_Taleemul_Quran/Tajweed_Tab/tajweed_page.dart';
import 'package:arrahma_mobile_app/All_Courses/Adv_Taleemul_Quran/Tests_Tab/tests_page.dart';
import 'package:arrahma_mobile_app/All_Courses/all_courses.dart';
import 'package:arrahma_mobile_app/Contact_Us/contact_us.dart';
import 'package:arrahma_mobile_app/Drawer/main_drawer.dart';
import 'package:arrahma_mobile_app/Grammer/grammar.dart';
import 'package:arrahma_mobile_app/Lectures/letures.dart';
import 'package:arrahma_mobile_app/Media_Player/media_player.dart';
import 'package:arrahma_mobile_app/Media_Player/share.dart';
import 'package:arrahma_mobile_app/Our_Nabi/Hadith/hadith.dart';
import 'package:arrahma_mobile_app/Our_Nabi/our_nabi.dart';
import 'package:arrahma_mobile_app/Reading_Material/reading_material.dart';
import 'package:arrahma_mobile_app/Student_Corner/Al_Fauz_PDF/al_fauz_pdf.dart';
import 'package:arrahma_mobile_app/Student_Corner/student_corner.dart';
import 'package:arrahma_mobile_app/Tajweed/tajweed.dart';
import 'package:flutter/material.dart';
import 'All_Courses/Adv_Taleemul_Quran/Tafseer_Tab/Juz_Detail_page/juz_detail_page.dart';
import 'All_Courses/Adv_Taleemul_Quran/taleemmul_quran.dart';
import 'Home_Page/home_page.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/taleemmul-quran': (context) => TaleemmulQuran(),
        '/home': (context) => HomePage(),
        '/about_us': (context) => AboutUs(),
        '/all_courses': (context) => AllCourses(),
        '/lectures': (context) => Lectures(),
        '/grammer': (context) => Grammer(),
        '/tajweed': (context) => Tajweed(),
        '/our_nabi': (context) => OurNabi(),
        '/student_corner': (context) => StudentCorner(),
        '/reading_material': (context) => ReadingMaterial(),
        '/media_player_screen': (context) => MediaPlayerScreen(),
        '/contact_us': (context) => ContactUs(),
        '/drawer': (context) => MainDrawer(),
        '/detail_tab': (context) => DetailsPage(),
        '/registration_tab': (context) => RegistrationPage(),
        '/tafseer_tab': (context) => TafseerPage(),
        '/tajweed_tab': (context) => TajweedPage(),
        '/test_tab': (context) => TestsPage(),
        '/share': (context) => Share(),
        '/favorite_juz': (context) => FavoriteJuz(),
        '/favorite_surah': (context) => FavoriteSurah(),
        '/juz_detail_page': (context) => JuzDetailPage(),
        '/lesson_detail_page': (context) => LessonDetailPage(),
        '/hadith': (context) => Hadith(),
        '/fauz_pdf': (context) => AlFauzPDF(),
      },

      //using materialApp -- instantitiing widgets and passing parameters
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          color: Colors.white,
          iconTheme: IconThemeData(color: Colors.black),
        ),
      ),
      home: HomePage(),
    );
  }
}
