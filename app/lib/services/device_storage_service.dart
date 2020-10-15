import 'package:arrahma_shared/shared.dart';
import 'package:flutter_framework/flutter_framework.dart';

class DeviceStorageService extends BaseDeviceStorageService {
  const DeviceStorageService(IStorageService storage) : super(storage);

  static const APP_DATA_HASH_KEY = 'AppDataHash';

  Future<AppData> loadAppData() async {
    const banners = [
      HeadingBanner(
        imageUrl: 'assets/images/home_page_images/front_page_banner1.jpg',
        linkUrl: 'http://arrahma.org/taf2019mp3/juz3/june26_20-imran33-44.mp3',
      ),
      HeadingBanner(
        imageUrl: 'assets/images/home_page_images/front_page_banner1.jpg',
        linkUrl: 'http://www.arrahma.org/tazkeer_n/tazkeer.php',
      ),
      HeadingBanner(
        imageUrl: 'assets/images/home_page_images/front_page_banner1.jpg',
        linkUrl:
            'https://filedn.com/lYVXaQXjsnDpmndt09ArOXz/tarbiyyatimp3/fastsofshawal.mp3',
      ),
    ];

    const broadcasts = [
      BroadcastItem(
        imageUrl: 'assets/images/home_page_images/facebook.png',
        linkUrl: 'https://www.facebook.com/arrahmah.islamic.institute/',
      ),
      BroadcastItem(
        imageUrl: 'assets/images/home_page_images/mixlr_logo.png',
        linkUrl: 'https://mixlr.com/arrahma-live/',
      ),
      BroadcastItem(
        imageUrl: 'assets/images/home_page_images/youtube.png',
        linkUrl: 'https://www.youtube.com/c/arrahmahislamicinstitute',
      ),
      BroadcastItem(
        imageUrl: 'assets/images/home_page_images/contact_information.png',
        linkUrl: 'tel:+1 712 432 1001#491760789',
      ),
    ];

    const courses = [
      QuranCourse(
        title: 'Adv Taleemul Quran',
        imageUrl: 'assets/images/courses/adv_taleemul_quran.png',
        courseDetails: QuranCourseDetails(),
        registration: QuranCourseRegistration(
          courseRegistration: '',
        ),
        tajweed: QuranCourseContent(
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
                )
              ],
            ),
          ],
        ),
        tafseer: QuranCourseContent(
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
      QuranCourse(
        title: 'Taleemul Quran',
        imageUrl: 'assets/images/courses/taleemul_quran.png',
        courseDetails: QuranCourseDetails(),
        registration: QuranCourseRegistration(
          courseRegistration: '',
        ),
        tajweed: QuranCourseContent(
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
                )
              ],
            ),
          ],
        ),
        tafseer: QuranCourseContent(
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
      QuranCourse(
        title: 'Fehmul Quran',
        imageUrl: 'assets/images/courses/fehmul_quran.png',
        courseDetails: QuranCourseDetails(),
        registration: QuranCourseRegistration(
          courseRegistration: '',
        ),
        tajweed: QuranCourseContent(
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
                )
              ],
            ),
          ],
        ),
        tafseer: QuranCourseContent(
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
      QuranCourse(
        title: 'Course In Pashtu ',
        imageUrl: 'assets/images/courses/course_in_pashtu.png',
        courseDetails: QuranCourseDetails(),
        registration: QuranCourseRegistration(
          courseRegistration: '',
        ),
        tajweed: QuranCourseContent(
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
                )
              ],
            ),
          ],
        ),
        tafseer: QuranCourseContent(
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
      QuranCourse(
        title: 'Ilmul Yaqeen',
        imageUrl: 'assets/images/courses/ilmul_yaqeen.png',
      ),
      QuranCourse(
        title: 'Ahsanul Bayan',
        imageUrl: 'assets/images/courses/ahsanul_bayan.png',
        courseDetails: QuranCourseDetails(),
      ),
      QuranCourse(
        title: 'Al Furqan',
        imageUrl: 'assets/images/courses/fehmul_quran.png',
        courseDetails: QuranCourseDetails(),
      ),
      QuranCourse(
        title: 'Seerah',
        imageUrl: 'assets/images/courses/seerah.png',
        courseDetails: QuranCourseDetails(),
      ),
      QuranCourse(
        title: 'Al Misbah (Whatsapp Program)',
        imageUrl: 'assets/images/courses/al_misbah.png',
        courseDetails: QuranCourseDetails(),
      ),
      QuranCourse(
        title: 'Weekly Gems',
        imageUrl: 'assets/images/courses/weekly_gems.png',
      ),
      QuranCourse(
        title: 'Assorted Lectures',
        imageUrl: 'assets/images/courses/assorted_letures.png',
      ),
      QuranCourse(
        title: 'Tazkeer',
        imageUrl: 'assets/images/courses/tazkeer.png',
      ),
      QuranCourse(
        title: 'Weekly Dua, Sunnah & Zikr',
        imageUrl: 'assets/images/courses/weekly_dua_sunnat_zikr.png',
      )
    ];

    const socialMediaItems = [
      SocialMediaItem(
        imageUrl: 'assets/images/social_media/youtube.png',
        linkUrl: 'https://www.youtube.com/c/arrahmahislamicinstitute',
      ),
      SocialMediaItem(
        imageUrl: 'assets/images/social_media/facebook.png',
        linkUrl: 'https://www.facebook.com/arrahmah.islamic.institute',
      ),
      SocialMediaItem(
        imageUrl: 'assets/images/social_media/whatsapp.png',
        linkUrl: 'http://arrahma.org/images/whatsapp.png',
      ),
      SocialMediaItem(
        imageUrl: 'assets/images/social_media/twitter.png',
        linkUrl: 'https://twitter.com/ArrahmahIslamic',
      ),
      SocialMediaItem(
        imageUrl: 'assets/images/social_media/instagram.png',
        linkUrl: 'https://www.instagram.com/arrahmah_islamic_institute',
      ),
    ];

    return await storage.get<AppData>(
      defaultFn: () => const AppData(
        banners: banners,
        broadcastItems: broadcasts,
        courses: courses,
        socialMediaItems: socialMediaItems,
      ),
    );
  }

  Future<String> loadAppDataHash() async {
    return storage.getWithKey(APP_DATA_HASH_KEY);
  }

  Future<bool> saveAppDataHash(String appDataHash) async {
    return storage.setWithKey(APP_DATA_HASH_KEY, appDataHash);
  }

  Future<bool> saveAppData(AppData appData) async {
    return storage.set<AppData>(appData);
  }
}
