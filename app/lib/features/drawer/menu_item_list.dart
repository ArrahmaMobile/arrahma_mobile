import 'package:arrahma_mobile_app/core/utils.dart';
import 'package:arrahma_mobile_app/features/common/media_content_view.dart';
import 'package:arrahma_mobile_app/features/quran_course/quran_surah_view.dart';
import 'package:arrahma_mobile_app/views/about_us_view.dart';
import 'package:arrahma_mobile_app/views/contact_us_view.dart';
import 'package:arrahma_mobile_app/views/settings_view.dart';
import 'package:arrahma_shared/shared.dart';
import 'package:flutter/material.dart';

class MenuItemList extends StatelessWidget {
  const MenuItemList({super.key, this.isDrawer = false, required this.items});

  final bool isDrawer;
  final List<DrawerItem> items;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (_, i) => _buildItem(context, items[i]),
    );
  }

  Widget _buildItem(BuildContext context, DrawerItem item) {
    return ListTile(
        title: Text(
          item.title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: isDrawer ? Colors.white : null,
          ),
        ),
        onTap: () {
          final normalizedTitle = item.title.toLowerCase();
          Widget? view;
          switch (normalizedTitle) {
            case 'home':
              Navigator.maybePop(context);
              return;
            case 'about us':
              view = AboutUsView();
              break;
            case 'contact us':
              view = ContactUsView();
              break;
            case 'settings':
              view = SettingsView();
              break;
          }
          final itemView = view ??
              ((item.children?.isNotEmpty ?? false)
                  ? MenuItemList(
                      items: item.children!,
                    )
                  : item.content?.surahs.isNotEmpty ?? false
                      ? QuranSurahView(
                          content: item.content!,
                          referrerTitle: item.title,
                        )
                      : item.media != null
                          ? MediaContentView(
                              content: item.media!,
                            )
                          : null);
          if (itemView != null)
            Utils.pushView(
              context,
              itemView,
              title: item.title,
            );
          else if (item.link != null)
            Utils.openUrl(context, TitledItem.fromItem(item.title, item.link!),
                useWebView: true);
        });
  }
}
