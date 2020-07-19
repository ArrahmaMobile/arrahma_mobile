import 'package:arrahma_mobile_app/About_Us/about_us.dart';
import 'package:arrahma_mobile_app/All_Courses/quran_courses/quran_tafseer_tab/quran_tafseer_favorite_juz/quran_tafseer_favorite_juz.dart';
import 'package:arrahma_mobile_app/All_Courses/quran_courses/quran_tafseer_tab/quran_tafseer_juz_detail_page/quran_juz_detail_page.dart';
import 'package:arrahma_mobile_app/All_Courses/ahsanul_bayan/ahsanul_bayan.dart';
import 'package:arrahma_mobile_app/All_Courses/al_furqan/al_furqan.dart';
import 'package:arrahma_mobile_app/All_Courses/all_courses.dart';
import 'package:arrahma_mobile_app/All_Courses/ilmul_taqeen/ilmul_taqeen.dart';
import 'package:arrahma_mobile_app/All_Courses/quran_courses/quran_course_page.dart';
import 'package:arrahma_mobile_app/All_Courses/quran_courses/quran_tafseer_tab/quran_tafseer_juz_detail_page/quran_lesson_detail/quran_lesson_detail.dart';
import 'package:arrahma_mobile_app/All_Courses/quran_courses/quran_tafseer_tab/quran_tafseer_juz_detail_page/quran_surah_page/quran_favorite_surah/quran_favorite_surah.dart';
import 'package:arrahma_mobile_app/All_Courses/quran_courses/quran_tafseer_tab/quran_tafseer_juz_detail_page/quran_surah_page/quran_surah_detail_page.dart';
import 'package:arrahma_mobile_app/All_Courses/quran_courses/quran_tafseer_tab/quran_tafseer_tab.dart';
import 'package:arrahma_mobile_app/All_Courses/seerah/seerah.dart';
import 'package:arrahma_mobile_app/All_Courses/weekly_gems/weekly_gems.dart';
import 'package:arrahma_mobile_app/Contact_Us/contact_us.dart';
import 'package:arrahma_mobile_app/Drawer/main_drawer.dart';
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
import 'package:arrahma_mobile_app/Tajweed/english_qaida/english_qaida.dart';
import 'package:arrahma_mobile_app/Tajweed/tajweed.dart';
import 'package:arrahma_mobile_app/arabic_grammer/arabic_grammers.dart';
import 'package:flutter/material.dart';
import 'package:arrahma_mobile_app/All_Courses/al_misbah/al_misbah.dart';
import 'package:arrahma_mobile_app/All_Courses/al_misbah/misbah_lecture_tab/misbah_fav_surah/misbah_fav_surah.dart';
import 'package:arrahma_mobile_app/All_Courses/al_misbah/misbah_lecture_tab/surah_seleted/surah_selected.dart';
import 'package:arrahma_mobile_app/All_Courses/assorted_lectures/assorted_lectures_course.dart';
import 'package:arrahma_mobile_app/All_Courses/assorted_lectures/assorted_lecture_page.dart';
import 'package:arrahma_mobile_app/All_Courses/assorted_lectures/new_lectures/new_lectures.dart';
import 'package:arrahma_mobile_app/All_Courses/dua_sunnah_zirk/dua_sunnah_zirk.dart';
import 'package:arrahma_mobile_app/All_Courses/fehmul_quran/fehmul_tajweed_tab/fehmul_tajweed_tab.dart';
import 'package:arrahma_mobile_app/All_Courses/seerah/lecture_tab/lecture_detail/lecture_detail.dart';
import 'package:arrahma_mobile_app/All_Courses/taleemul_quran/tajweed_tab/introduction/introduction.dart';
import 'package:arrahma_mobile_app/All_Courses/taleemul_quran/tajweed_tab/tajweed_rules/tajweed_rules.dart';
import 'package:arrahma_mobile_app/All_Courses/taleemul_quran/tajweed_tab/tajweed_tab.dart';
import 'package:arrahma_mobile_app/All_Courses/taleemul_quran/tajweed_tab/weekly_hifz/weekly_hifz.dart';
import 'package:arrahma_mobile_app/Home_Page/home_page.dart';
import 'package:arrahma_mobile_app/Lectures/Lectures_on_Death/lectures_on_deaths.dart';
import 'package:arrahma_mobile_app/Lectures/Quran_Tafseer/quran_tafseer.dart';
import 'package:arrahma_mobile_app/Lectures/Ramadan_Speical/ramadan_special.dart';
import 'package:arrahma_mobile_app/Lectures/Speical_Series/asma_ul_husna/asma_ul_husna.dart';
import 'package:arrahma_mobile_app/Lectures/Speical_Series/gumnaam_ki_diary/gumnaam_ki_diary.dart';
import 'package:arrahma_mobile_app/Lectures/Speical_Series/medan_mehshar_me_meriahani/medan_mehshar_me_meriahani.dart';
import 'package:arrahma_mobile_app/Lectures/Speical_Series/meri_aakhari/meri_aakhari.dart';
import 'package:arrahma_mobile_app/Lectures/Speical_Series/special_series.dart';
import 'package:arrahma_mobile_app/Lectures/Wirasat_Course/wirasat_course.dart';
import 'package:arrahma_mobile_app/Lectures/Youth_Course/youth_course.dart';
import 'package:arrahma_mobile_app/Lectures/lectures_on_namaz/lectures_on_namaz.dart';

class Router {
  static final _routeBuilderMap =
      <String, Widget Function(BuildContext, Object)>{
    '/home': (context, args) => HomePage(),
    '/about_us': (context, args) => AboutUs(),
    '/all_courses': (context, args) => AllCourses(),
    '/lectures': (context, args) => Lectures(),
    '/arabic_grammer': (context, args) => ArabicGrammer(),
    '/tajweed': (context, args) => Tajweed(),
    '/our_nabi': (context, args) => OurNabi(),
    '/student_corner': (context, args) => StudentCorner(),
    '/reading_material': (context, args) => ReadingMaterial(),
    '/media_player_screen': (context, args) => MediaPlayerScreen(),
    '/contact_us': (context, args) => ContactUs(),
    '/drawer': (context, args) => MainDrawer(),
    '/share': (context, args) => Share(),
    '/favorite_juz': (context, args) => AdvTaleemmulFavoriteJuz(),
    '/favorite_surah': (context, args) => QuranFavoriteSurah(),
    '/juz_detail_page': (context, args) => QuranJuzDetailPage(),
    '/lesson_detail_page': (context, args) => QuranLessonDetailPage(),
    '/hadith': (context, args) => Hadith(),
    '/fauz_pdf': (context, args) => AlFauzPDF(),
    '/surah_detail_page': (context, args) => QuranSurahDetailPage(),
    '/quran_course_page': (context, args) => QuranCoursePage(course: args),
    '/ahsanul_bayan': (context, args) => AhsanulBayan(),
    '/al_furqan': (context, args) => AlFurqan(),
    '/ilmul_taqeen': (context, args) => IlmulTaqeen(),
    '/seerah': (context, args) => Seerah(),
    '/seerah_course': (context, args) => SeerahCourse(),
    '/tazkeer': (context, args) => Tazkeer(),
    '/weekly_gems': (context, args) => WeeklyGems(),
    '/weekly_gems_course': (context, args) => WeeklyGemsCourse(),
    '/assorted_lectures': (context, args) => AssortedLectures(),
    '/al_misbah': (context, args) => AlMisbah(),
    '/taleemul_tajweed_tab': (context, args) => TaleemulTajweedTab(),
    '/introduction': (context, args) => Introduction(),
    // '/letter_practice': (context, args) => LetterPractice(
    //       course: args,
    //     ),
    '/lecture_detail': (context, args) => LectureDetail(),
    '/weekly_hifz': (context, args) => WeeklyHifz(),
    '/dua_sunnah_zikr': (context, args) => WeeklyDuaSunnahZikr(),
    '/tajweed_rules': (context, args) => TajweedRules(),
    '/quran_tafseer': (context, args) => QuranTafseer(),
    '/quran_tafseer_tab': (context, args) => QuranTafseerTab(),
    '/youth_course': (context, args) => YouthCourse(),
    '/wirasat_course': (context, args) => WirasatCourse(),
    '/ramadan_special': (context, args) => RamadanSpecial(),
    '/speical_series': (context, args) => SpecialSeries(),
    '/pashto_course': (context, args) => PashtoCourse(),
    '/lectures_on_death': (context, args) => LecturesOnDeath(),
    '/lecture_on_namaz': (context, args) => LecturesOnNamaz(),
    '/asma_ul_husna': (context, args) => AsmaUlHusna(),
    '/medan_mehshar_me_meriahani': (context, args) => MedanMehsharMeMeriahani(),
    '/meri_aakhri': (context, args) => MeriAakhri(),
    '/femul_tajweed_tab': (context, args) => FemulTajweedTab(),
    '/misbah_surah_selected': (context, args) => MisbahSurahSelected(),
    '/misbah_fav_surah': (context, args) => MisbahFavSurah(),
    '/new_lectures': (context, args) => NewLectures(),
    '/english_qaida': (context, args) => EnglishQaida(),
    '/gumnaam_ki_diary': (context, args) => GumnaamKiDiary(),
    '/assorted_lecture_page': (context, args) =>
        AssortedLecturePage(item: args),
  };

  static Route<dynamic> generateRoute(RouteSettings settings) {
    return MaterialPageRoute(
        builder: (context) =>
            _routeBuilderMap[settings.name](context, settings.arguments));
  }
}
