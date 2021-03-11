import 'package:arrahma_mobile_app/core/utils.dart';
import 'package:arrahma_mobile_app/features/common/media_content_view.dart';
import 'package:arrahma_mobile_app/features/common/themed_app_bar.dart';
import 'package:arrahma_mobile_app/features/quran_course/quran_surah_view.dart';
import 'package:arrahma_mobile_app/pages/about_us_view.dart';
import 'package:arrahma_mobile_app/pages/contact_us_view.dart';
import 'package:arrahma_shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_framework/flutter_framework.dart';

class MenuItemList extends StatelessWidget {
  const MenuItemList({Key key, this.items}) : super(key: key);

  final List<DrawerItem> items;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: items.length,
      itemBuilder: (_, i) => _buildItem(context, items[i]),
      separatorBuilder: (_, i) => const Divider(height: 2, thickness: 2),
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
          Widget view;
          switch (normalizedTitle) {
            case 'home':
              Navigator.pop(context);
              return;
            case 'about us':
              view = AboutUsView();
              break;
            case 'contact us':
              view = ContactUsView();
              break;
          }
          final itemView = view ??
              ((item.children?.isNotEmpty ?? false)
                  ? MenuItemList(
                      items: item.children,
                    )
                  : item.content?.surahs?.isNotEmpty ?? false
                      ? QuranSurahView(
                          content: item.content,
                          referrerTitle: item.title,
                        )
                      : item.media != null
                          ? MediaContentView(
                              content: item.media,
                            )
                          : null);
          if (itemView != null)
            Utils.pushView(context, itemView, title: item.title);
          else
            Utils.openUrl(context, TitledItem.fromItem(item.title, item.link),
                fromMenu: true);
        });
  }
}
