import 'package:arrahma_mobile_app/About_Us/about_us.dart';
import 'package:arrahma_mobile_app/all_courses/assorted_lectures/model/assorted_lectures.dart';
import 'package:arrahma_mobile_app/all_courses/quran_courses/quran_tafseer_tab/quran_surah_page/quran_lesson_page/quran_favorite_surah/quran_favorite_surah.dart';
import 'package:arrahma_mobile_app/all_courses/quran_courses/quran_tafseer_tab/quran_surah_page/quran_lesson_page/quran_lesson_page.dart';
import 'package:arrahma_mobile_app/all_courses/quran_courses/quran_tafseer_tab/quran_surah_page/quran_lesson_detail/quran_lesson_detail.dart';
import 'package:arrahma_mobile_app/all_courses/quran_courses/quran_tafseer_tab/quran_surah_page/quran_surah_page.dart';
import 'package:arrahma_mobile_app/all_courses/all_courses.dart';
import 'package:arrahma_mobile_app/all_courses/quran_courses/quran_course_page.dart';
import 'package:arrahma_mobile_app/all_courses/quran_courses/quran_test_page/quran_test_page.dart';
import 'package:arrahma_mobile_app/all_courses/supplementary_courses/supplementary_course.dart';
import 'package:arrahma_mobile_app/all_courses/weekly_gems/weekly_gems.dart';
import 'package:arrahma_mobile_app/Contact_Us/contact_us.dart';
import 'package:arrahma_mobile_app/Lectures/Pashto_Course/pashto_course.dart';
import 'package:arrahma_mobile_app/Lectures/Tazkeer/tazkeer.dart';
import 'package:arrahma_mobile_app/Lectures/Weekly_Gems/weekly_gems.dart';
import 'package:arrahma_mobile_app/Lectures/letures.dart';
import 'package:arrahma_mobile_app/Media_Player/media_player.dart';
import 'package:arrahma_mobile_app/Media_Player/share.dart';
import 'package:arrahma_mobile_app/Our_Nabi/Hadith/hadith.dart';
import 'package:arrahma_mobile_app/Our_Nabi/Hadith/hadith_lessons/hadith_lesson_details/hadith_lesson_details.dart';
import 'package:arrahma_mobile_app/Our_Nabi/Hadith/hadith_lessons/hadith_lessons.dart';
import 'package:arrahma_mobile_app/Our_Nabi/Riaz_us_Saliheen/riaz_us_saliheen.dart';
import 'package:arrahma_mobile_app/Our_Nabi/Seerah/seerah.dart';
import 'package:arrahma_mobile_app/Our_Nabi/our_nabi.dart';
import 'package:arrahma_mobile_app/Reading_Material/assorted_topic/assorted_topic.dart';
import 'package:arrahma_mobile_app/Reading_Material/dua/dua.dart';
import 'package:arrahma_mobile_app/Reading_Material/dua/dua_detail_page/dua_detail_page.dart';
import 'package:arrahma_mobile_app/Reading_Material/juz_transaltion/juz_transaltion.dart';
import 'package:arrahma_mobile_app/Reading_Material/quran_dictionary/quran_dictionary.dart';
import 'package:arrahma_mobile_app/Reading_Material/reading_material.dart';
import 'package:arrahma_mobile_app/Reading_Material/vocabulary_words/vocabulary_word.dart';
import 'package:arrahma_mobile_app/Reading_Material/worksheet/worksheet.dart';
import 'package:arrahma_mobile_app/Student_Corner/Al_Fauz_PDF/al_fauz_pdf.dart';
import 'package:arrahma_mobile_app/Student_Corner/student_corner.dart';
import 'package:arrahma_mobile_app/Tajweed/english_qaida/english_qaida.dart';
import 'package:arrahma_mobile_app/Tajweed/juz_30_hifz/juz_30_hifz.dart';
import 'package:arrahma_mobile_app/Tajweed/tajweed.dart';
import 'package:arrahma_mobile_app/Tajweed/taleem_quran_2013/taleem_quran_2013.dart';
import 'package:arrahma_mobile_app/arabic_grammer/arabic_grammers.dart';
import 'package:arrahma_mobile_app/drawer/main_drawer.dart';
import 'package:arrahma_mobile_app/lectures/quranic_tafseer/quran_tafseer.dart';
import 'package:arrahma_models/models.dart';
import 'package:flutter/material.dart';
import 'package:arrahma_mobile_app/all_courses/assorted_lectures/assorted_lectures_course.dart';
import 'package:arrahma_mobile_app/all_courses/assorted_lectures/assorted_lecture_page.dart';
import 'package:arrahma_mobile_app/all_courses/assorted_lectures/new_lectures/new_lectures.dart';
import 'package:arrahma_mobile_app/all_courses/dua_sunnah_zirk/dua_sunnah_zirk.dart';
import 'package:arrahma_mobile_app/Home_Page/home_page.dart';
import 'package:arrahma_mobile_app/Lectures/Lectures_on_Death/lectures_on_deaths.dart';
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
    '/juz_detail_page': (context, args) => const QuranSurahPage(
          surahs: [],
        ),
    '/lesson_audio_page': (context, args) => QuranLessonAudioPage(),
    '/hadith': (context, args) => Hadith(),
    '/favorite_surah': (context, args) => QuranFavoriteSurah(),

    '/fauz_pdf': (context, args) => AlFauzPDF(),
    '/quran_course_page': (context, args) => QuranCoursePage(
          course: args as QuranCourse,
          title: '',
        ),
    '/supplementary_course': (context, args) => SupplementaryCourse(
          course: args as QuranCourse,
          title: args as String,
        ),
    // '/ilmul_taqeen': (context, args) => IlmulTaqeen(),
    '/tazkeer': (context, args) => Tazkeer(),
    '/surah_detail_page': (context, args) => const QuranLessonPage(
          lessons: [],
        ),
    '/seerah': (context, args) => Seerah(),
    '/quran_test_page': (context, args) => QuranTestsPage(
          title: args as String,
        ),
    '/weekly_gems': (context, args) => WeeklyGems(),
    '/weekly_gems_course': (context, args) => WeeklyGemsCourse(),
    '/assorted_lectures': (context, args) => AssortedLectures(),
    '/riza_us_saliheen': (context, args) => RiazUsSaliheen(),
    '/taleem_quran_2013': (context, args) => TaleemQuran2013(),
    // '/taleemul_tajweed_tab': (context, args) => TaleemulTajweedTab(),
    // '/introduction': (context, args) => Introduction(),
    // '/letter_practice': (context, args) => LetterPractice(
    //       course: args,
    //     ),
    // '/weekly_hifz': (context, args) => WeeklyHifz(),
    '/dua_sunnah_zikr': (context, args) => WeeklyDuaSunnahZikr(),
    // '/tajweed_rules': (context, args) => TajweedRules(),
    '/quran_tafseer': (context, args) => QuranTafseer(),
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
    // '/femul_tajweed_tab': (context, args) => FemulTajweedTab(),
    '/new_lectures': (context, args) => NewLectures(),
    '/english_qaida': (context, args) => EnglishQaida(),
    '/juz_30_hifz': (context, args) => Juz30Hifz(),
    '/dua': (context, args) => Dua(),
    '/quran_dictionary': (context, args) => QuranDictionary(),
    '/dua_detail_page': (context, args) => DuaDetailPage(),
    '/assorted_topic': (context, args) => AssortedTopic(),
    '/imp_vocabulary_words': (context, args) => VocabularyWords(),
    '/worksheet': (context, args) => WorkSheet(),
    '/juz_Translation': (context, args) => JuzTranslation(),
    '/hadith_lessons': (context, args) => HadithLessons(),
    '/hadith_lesson_details': (context, args) => HadithLessonDetails(),
    '/gumnaam_ki_diary': (context, args) => GumnaamKiDiary(),
    '/assorted_lecture_page': (context, args) =>
        AssortedLecturePage(item: args as AssortedLectureCategoryItem),
  };

  static Route<dynamic> generateRoute(RouteSettings settings) {
    return MaterialPageRoute<dynamic>(
        builder: (context) =>
            _routeBuilderMap[settings.name](context, settings.arguments));
  }
}