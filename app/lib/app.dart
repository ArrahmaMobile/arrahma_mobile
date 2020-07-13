import 'package:arrahma_mobile_app/About_Us/about_us.dart';
import 'package:arrahma_mobile_app/All_Courses/adv_taleemul_quran/adv_taleemmul_quran.dart';
import 'package:arrahma_mobile_app/All_Courses/adv_taleemul_quran/tafseer_tab/adv_taleemul_favorite_juz/favorite_juz.dart';
import 'package:arrahma_mobile_app/All_Courses/adv_taleemul_quran/tafseer_tab/adv_taleemul_juz_detail_page/adv_taleemul_favorite_surah/adv_taleemul_favorite_surah.dart';
import 'package:arrahma_mobile_app/All_Courses/adv_taleemul_quran/tafseer_tab/adv_taleemul_juz_detail_page/adv_taleemul_juz_detail_page.dart';
import 'package:arrahma_mobile_app/All_Courses/adv_taleemul_quran/tafseer_tab/adv_taleemul_juz_detail_page/adv_taleemul_surah_detail_page/adv_taleemul_surah_detail_page.dart';
import 'package:arrahma_mobile_app/All_Courses/ahsanul_bayan/ahsanul_bayan.dart';
import 'package:arrahma_mobile_app/All_Courses/al_furqan/al_furqan.dart';
import 'package:arrahma_mobile_app/All_Courses/all_courses.dart';
import 'package:arrahma_mobile_app/All_Courses/course_in_pashtu/course_in_pashtu.dart';
import 'package:arrahma_mobile_app/All_Courses/fehmul_quran/fehmul_quran.dart';
import 'package:arrahma_mobile_app/All_Courses/ilmul_taqeen/ilmul_taqeen.dart';
import 'package:arrahma_mobile_app/All_Courses/seerah/seerah.dart';
import 'package:arrahma_mobile_app/All_Courses/taleemul_quran/taleemul_quran.dart';
import 'package:arrahma_mobile_app/All_Courses/weekly_gems/weekly_gems.dart';
import 'package:arrahma_mobile_app/Contact_Us/contact_us.dart';
import 'package:arrahma_mobile_app/Drawer/main_drawer.dart';
import 'package:arrahma_mobile_app/Grammer/grammar.dart';
import 'package:arrahma_mobile_app/Lectures/Assorted_Lectures/assorted_lectures.dart';
import 'package:arrahma_mobile_app/Lectures/Pashto_Course/pashto_course.dart';
import 'package:arrahma_mobile_app/Lectures/Tazkeer/tazkeer.dart';
import 'package:arrahma_mobile_app/Lectures/Weekly_Gems/weekly_gems.dart';
import 'package:arrahma_mobile_app/Lectures/letures.dart';
import 'package:arrahma_mobile_app/Media_Player/media_player.dart';
import 'package:arrahma_mobile_app/Media_Player/share.dart';
import 'package:arrahma_mobile_app/Our_Nabi/Hadith/hadith.dart';
import 'package:arrahma_mobile_app/Our_Nabi/Seerah/seerah.dart';
import 'package:arrahma_mobile_app/Our_Nabi/our_nabi.dart';
import 'package:arrahma_mobile_app/Reading_Material/reading_material.dart';
import 'package:arrahma_mobile_app/Student_Corner/Al_Fauz_PDF/al_fauz_pdf.dart';
import 'package:arrahma_mobile_app/Student_Corner/student_corner.dart';
import 'package:arrahma_mobile_app/Tajweed/tajweed.dart';
import 'package:flutter/material.dart';
import 'All_Courses/adv_taleemul_quran/tafseer_tab/adv_taleemul_juz_detail_page/adv_taleemul_lesson_detail_page/adv_taleemul_lesson_detail_page.dart';
import 'All_Courses/al_misbah/al_misbah.dart';
import 'All_Courses/assorted_lectures/assorted_lectures.dart';
import 'All_Courses/dua_sunnah_zirk/dua_sunnah_zirk.dart';
import 'All_Courses/seerah/lecture_tab/lecture_detail/lecture_detail.dart';
import 'All_Courses/taleemul_quran/tajweed_tab/introduction/introduction.dart';
import 'All_Courses/taleemul_quran/tajweed_tab/letter_practice/letter_practice.dart';
import 'All_Courses/taleemul_quran/tajweed_tab/tajweed_rules/tajweed_rules.dart';
import 'All_Courses/taleemul_quran/tajweed_tab/tajweed_tab.dart';
import 'All_Courses/taleemul_quran/tajweed_tab/weekly_hifz/weekly_hifz.dart';
import 'Home_Page/home_page.dart';
import 'Lectures/Lectures_on_Death/lectures_on_deaths.dart';
import 'Lectures/Quran_Tafseer/quran_tafseer.dart';
import 'Lectures/Ramadan_Speical/ramadan_special.dart';
import 'Lectures/Speical_Series/asma_ul_husna/asma_ul_husna.dart';
import 'Lectures/Speical_Series/gumnaam_ki_diary/gumnaam_ki_diary.dart';
import 'Lectures/Speical_Series/medan_mehshar_me_meriahani/medan_mehshar_me_meriahani.dart';
import 'Lectures/Speical_Series/meri_aakhari/meri_aakhari.dart';
import 'Lectures/Speical_Series/special_series.dart';
import 'Lectures/Wirasat_Course/wirasat_course.dart';
import 'Lectures/Youth_Course/youth_course.dart';
import 'Lectures/lectures_on_namaz/lectures_on_namaz.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/home',
      routes: {
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
        '/share': (context) => Share(),
        '/favorite_juz': (context) => AdvTaleemmulFavoriteJuz(),
        '/favorite_surah': (context) => AdvTaleemmulFavoriteSurah(),
        '/juz_detail_page': (context) => AdvTaleemmulJuzDetailPage(),
        '/lesson_detail_page': (context) => AdvTaleemmulLessonDetailPage(),
        '/hadith': (context) => Hadith(),
        '/fauz_pdf': (context) => AlFauzPDF(),
        '/surah_detail_page': (context) => AdvTaleemmulSurahDetailPage(),
        '/taleemul_quran': (context) => TaleemmulQuran(),
        '/adv_taleemmul_quran': (context) => AdvTaleemmulQuran(),
        '/ahsanul_bayan': (context) => AhsanulBayan(),
        '/al_furqan': (context) => AlFurqan(),
        '/assorted_lectures': (context) => AssortedLectures(),
        '/course_in_pashtu': (context) => CourseInPashtu(),
        '/fehmul_quran': (context) => FehmulQuran(),
        '/ilmul_taqeen': (context) => IlmulTaqeen(),
        '/seerah': (context) => Seerah(),
        '/seerah_course': (context) => SeerahCourse(),
        '/tazkeer': (context) => Tazkeer(),
        '/weekly_gems': (context) => WeeklyGems(),
        '/weekly_gems_course': (context) => WeeklyGemsCourse(),
        '/assorted_lectures_course': (context) => AssortedLecturesCourse(),
        '/al_misbah': (context) => AlMisbah(),
        '/taleemul_tajweed_tab': (context) => TaleemulTajweedTab(),
        '/introduction': (context) => Introduction(),
        '/letter_practice': (context) => LetterPractice(),
        '/lecture_detail': (context) => LectureDetail(),
        '/weekly_hifz': (context) => WeeklyHifz(),
        '/dua_sunnah_zikr': (context) => WeeklyDuaSunnahZikr(),
        '/tajweed_rules': (context) => TajweedRules(),
        '/quran_tafseer': (context) => QuranTafseer(),
        '/youth_course': (context) => YouthCourse(),
        '/wirasat_course': (context) => WirasatCourse(),
        '/ramadan_special': (context) => RamadanSpecial(),
        '/speical_series': (context) => SpecialSeries(),
        '/pashto_course': (context) => PashtoCourse(),
        '/lectures_on_death': (context) => LecturesOnDeath(),
        '/lecture_on_namaz': (context) => LecturesOnNamaz(),
        '/asma_ul_husna': (context) => AsmaUlHusna(),
        '/medan_mehshar_me_meriahani': (context) => MedanMehsharMeMeriahani(),
        '/meri_aakhri': (context) => MeriAakhri(),
        '/gumnaam_ki_diary': (context) => GumnaamKiDiary(),
      },
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
