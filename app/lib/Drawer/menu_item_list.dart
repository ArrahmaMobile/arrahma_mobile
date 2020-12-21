import 'package:arrahma_mobile_app/About_Us/about_us.dart';
import 'package:arrahma_mobile_app/all_courses/quran_courses/quran_tafseer_tab/quran_surah_page/quran_surah_page.dart';
import 'package:arrahma_shared/shared.dart';
import 'package:flutter/material.dart';

class MenuItemList extends StatelessWidget {
  const MenuItemList({Key key, this.items}) : super(key: key);

  final List<DrawerItem> items;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: items?.map((item) => _buildItem(context, item))?.toList(),
    );
  }

  Widget _buildItem(BuildContext context, DrawerItem item) {
    return ListTile(
        title: Text(
          item.title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        onTap: () {
          final normalizedTitle = item.title.toLowerCase();
          Widget page;
          switch (normalizedTitle) {
            case 'home':
              Navigator.pop(context);
              return;
            case 'about us':
              page = AboutUs();
              break;
          }
          Navigator.push<dynamic>(
            context,
            MaterialPageRoute<dynamic>(
              builder: (_) =>
                  page ??
                  ((item.children?.isNotEmpty ?? false)
                      ? Scaffold(
                          appBar: AppBar(
                            iconTheme: const IconThemeData(color: Colors.white),
                            backgroundColor: const Color(0xff124570),
                            centerTitle: true,
                            title: const Text(
                              'About us',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          body: MenuItemList(
                            items: item.children,
                          ),
                        )
                      : QuranSurahPage(
                          surahs: item.content.surahs,
                        )),
            ),
          );
        });
  }
}
