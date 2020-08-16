import 'package:arrahma_mobile_app/utils/models/device_config.dart';
import 'package:arrahma_models/models.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import 'logger.dart';
import 'models/app_config.dart';
import 'storage/storage_provider.dart';

class DeviceStorageService {
  const DeviceStorageService(this._storage);

  final IStorageService _storage;

  Future<AppConfig> loadAppConfigPreferences() async {
    return _storage.get<AppConfig>(
      defaultFn: () =>
          const AppConfig(themeMode: ThemeMode.system, environmentName: null),
    );
  }

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

    const courses = <Course>[
      QuranCourse(
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
      QuranCourse(
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
      QuranCourse(
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
      QuranCourse(
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
      QuranCourse(
        title: 'Ilmul Yaqeen',
        imageUrl: 'assets/images/courses/ilmul_yaqeen.png',
      ),
      QuranCourse(
        title: 'Ahsanul Bayan',
        imageUrl: 'assets/images/courses/ahsanul_bayan.png',
        courseDetailPdfUrl: '',
      ),
      QuranCourse(
        title: 'Al Furqan',
        imageUrl: 'assets/images/courses/fehmul_quran.png',
        courseDetailPdfUrl: '',
      ),
      QuranCourse(
        title: 'Seerah',
        imageUrl: 'assets/images/courses/seerah.png',
        courseDetailPdfUrl: '',
      ),
      QuranCourse(
        title: 'Al Misbah (Whatsapp Program)',
        imageUrl: 'assets/images/courses/al_misbah.png',
        courseDetailPdfUrl: '',
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

    return await _storage.get<AppData>(
      defaultFn: () => const AppData(
        banners: banners,
        broadcastItems: broadcasts,
        courses: courses,
        socialMediaItems: socialMediaItems,
      ),
    );
  }

  Future<bool> saveAppData(AppData appData) async {
    return _storage.set<AppData>(appData);
  }

  static const String DEVICE_ID = 'DEVICE_ID';

  Future<DeviceConfig> loadDeviceConfig() async {
    final deviceId = await _storage
        .getString(DEVICE_ID, private: true)
        .catchError((dynamic e) => resetDeviceId());
    final freshInstall = deviceId == null;
    return DeviceConfig(
      deviceId: deviceId ?? await resetDeviceId(),
      isFreshInstall: freshInstall,
    );
  }

  Future<String> resetDeviceId() async {
    final newDeviceId = Uuid().v4();
    await _storage.setString(DEVICE_ID, newDeviceId, private: true);
    logger.info('New Device ID: $newDeviceId');
    return newDeviceId;
  }

  // Future<bool> saveThemeMode(ThemeMode value) {
  //   return _storage.setString(
  //       AppConfig.THEME_MODE_STORAGE_KEY, EnumUtils.enumToString(value, false));
  // }

  // Future<bool> saveBannerVisibility(bool isVisible) {
  //   return _storage.setBool(AppConfig.BANNER_STORAGE_KEY, isVisible);
  // }

  Future<bool> saveAppConfig(AppConfig appConfig) {
    return _storage.set<AppConfig>(appConfig);
  }
}
