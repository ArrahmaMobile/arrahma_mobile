import 'package:arrahma_shared/shared.dart';
import 'package:flutter_framework/flutter_framework.dart';

class DeviceStorageService extends BaseDeviceStorageService {
  const DeviceStorageService(IStorageService storage) : super(storage);

  static const APP_DATA_HASH_KEY = 'AppDataHash';

  Future<AppData?> loadAppData() async {
    return await storage.get<AppData>(defaultFn: () => getDefaultAppData());
  }

  AppData getDefaultAppData() {
    const banners = [
      HeadingBanner(
        imageUrl: 'assets/images/home_page_images/front_page_banner1.jpg',
        item: Item(
          type: ItemType.Audio,
          data: 'http://arrahma.org/taf2019mp3/juz3/june26_20-imran33-44.mp3',
          isDirectSource: true,
        ),
      ),
      HeadingBanner(
        imageUrl: 'assets/images/home_page_images/front_page_banner1.jpg',
        item: Item(
          type: ItemType.WebPage,
          data: 'http://www.arrahma.org/tazkeer_n/tazkeer.php',
          isDirectSource: false,
        ),
      ),
      HeadingBanner(
        imageUrl: 'assets/images/home_page_images/front_page_banner1.jpg',
        item: Item(
          type: ItemType.Audio,
          data:
              'https://filedn.com/lYVXaQXjsnDpmndt09ArOXz/tarbiyyatimp3/fastsofshawal.mp3',
          isDirectSource: true,
        ),
      ),
    ];

    const broadcasts = [
      BroadcastItem(
        imageUrl: 'assets/images/home_page_images/facebook.png',
        item: Item(
          type: ItemType.WebPage,
          data: 'https://www.facebook.com/arrahmah.islamic.institute/',
          isDirectSource: false,
        ),
      ),
      BroadcastItem(
        imageUrl: 'assets/images/home_page_images/mixlr_logo.png',
        item: Item(
          type: ItemType.WebPage,
          data: 'https://mixlr.com/arrahma-live/',
          isDirectSource: false,
        ),
      ),
      BroadcastItem(
        imageUrl: 'assets/images/home_page_images/youtube.png',
        item: Item(
          type: ItemType.WebPage,
          data: 'https://www.youtube.com/c/arrahmahislamicinstitute',
          isDirectSource: false,
        ),
      ),
      BroadcastItem(
        imageUrl: 'assets/images/home_page_images/contact_information.png',
        item: Item(
          type: ItemType.WebPage,
          data: 'tel:+1 712 432 1001#491760789',
          isDirectSource: false,
        ),
      ),
    ];

    const courses = [
      QuranCourse(
        title: 'Adv Taleemul Quran',
        imageUrl: 'assets/images/courses/adv_taleemul_quran.png',
        buttons: [],
        sections: [],
      ),
      QuranCourse(
        title: 'Taleemul Quran',
        imageUrl: 'assets/images/courses/taleemul_quran.png',
        buttons: [],
        sections: [],
      ),
      QuranCourse(
        title: 'Fehmul Quran',
        imageUrl: 'assets/images/courses/fehmul_quran.png',
        buttons: [],
        sections: [],
      ),
      QuranCourse(
        title: 'Course In Pashtu ',
        imageUrl: 'assets/images/courses/course_in_pashtu.png',
        buttons: [],
        sections: [],
      ),
      QuranCourse(
        title: 'Ilmul Yaqeen',
        imageUrl: 'assets/images/courses/ilmul_yaqeen.png',
        buttons: [],
        sections: [],
      ),
      QuranCourse(
        title: 'Ahsanul Bayan',
        imageUrl: 'assets/images/courses/ahsanul_bayan.png',
        buttons: [],
        sections: [],
      ),
      QuranCourse(
        title: 'Al Furqan',
        imageUrl: 'assets/images/courses/fehmul_quran.png',
        buttons: [],
        sections: [],
      ),
      QuranCourse(
        title: 'Seerah',
        imageUrl: 'assets/images/courses/seerah.png',
        buttons: [],
        sections: [],
      ),
      QuranCourse(
        title: 'Al Misbah (Whatsapp Program)',
        imageUrl: 'assets/images/courses/al_misbah.png',
        buttons: [],
        sections: [],
      ),
      QuranCourse(
        title: 'Weekly Gems',
        imageUrl: 'assets/images/courses/weekly_gems.png',
        buttons: [],
        sections: [],
      ),
      QuranCourse(
        title: 'Assorted Lectures',
        imageUrl: 'assets/images/courses/assorted_letures.png',
        buttons: [],
        sections: [],
      ),
      QuranCourse(
        title: 'Tazkeer',
        imageUrl: 'assets/images/courses/tazkeer.png',
        buttons: [],
        sections: [],
      ),
      QuranCourse(
        title: 'Weekly Reminder',
        imageUrl: 'assets/images/courses/weekly_dua_sunnat_zikr.png',
        buttons: [],
        sections: [],
      )
    ];

    const socialMediaItems = [
      SocialMediaItem(
        imageUrl: 'assets/images/social_media/youtube.png',
        item: Item(
          type: ItemType.WebPage,
          data: 'https://www.youtube.com/c/arrahmahislamicinstitute',
          isDirectSource: false,
        ),
      ),
      SocialMediaItem(
        imageUrl: 'assets/images/social_media/facebook.png',
        item: Item(
          type: ItemType.WebPage,
          data: 'https://www.facebook.com/arrahmah.islamic.institute',
          isDirectSource: false,
        ),
      ),
      SocialMediaItem(
        imageUrl: 'assets/images/social_media/whatsapp.png',
        item: Item(
          type: ItemType.WebPage,
          data: 'http://arrahma.org/images/whatsapp.png',
          isDirectSource: false,
        ),
      ),
      SocialMediaItem(
        imageUrl: 'assets/images/social_media/twitter.png',
        item: Item(
          type: ItemType.WebPage,
          data: 'https://twitter.com/ArrahmahIslamic',
          isDirectSource: false,
        ),
      ),
      SocialMediaItem(
        imageUrl: 'assets/images/social_media/instagram.png',
        item: Item(
          type: ItemType.WebPage,
          data: 'https://www.instagram.com/arrahmah_islamic_institute',
          isDirectSource: false,
        ),
      ),
    ];

    return const AppData(
      banners: banners,
      broadcastItems: broadcasts,
      quickLinks: [],
      courses: courses,
      socialMediaItems: socialMediaItems,
      logoUrl: '',
      aboutUsMarkdown: '',
      drawerItems: [],
      duaCategories: [],
    );
  }

  Future<String?> loadAppDataHash() async {
    return await storage.getWithKey(APP_DATA_HASH_KEY);
  }

  Future<bool> saveAppDataHash(String appDataHash) async {
    return storage.setWithKey(APP_DATA_HASH_KEY, appDataHash);
  }

  Future<bool> saveAppData(AppData appData) async {
    return storage.set<AppData>(appData);
  }
}
