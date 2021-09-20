import 'package:arrahma_mobile_app/core/utils.dart';
import 'package:arrahma_shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_framework/flutter_framework.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class MediaContentView extends StatelessWidget {
  const MediaContentView({
    Key key,
    this.content,
  }) : super(key: key);

  final MediaContent content;

  @override
  Widget build(BuildContext context) {
    if (content.items.length == 1)
      return Utils.getItemView(
        TitledItem.fromItem(
          content.items.first.title,
          content.items.first.item,
        ),
      );
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (content.description != null)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: MarkdownBody(
                data: content.description,
              ),
            ),
          ListView.builder(
            itemCount: content.items?.length ?? 0,
            itemBuilder: (_, index) {
              final item = content.items[index];
              final title = item.title ??
                  '${EnumUtils.enumToString(item.item.type)} ${index + 1}';
              return ListTile(
                title: Text(title),
                onTap: item.item?.data != null
                    ? () {
                        Utils.openUrl(
                          context,
                          TitledItem.fromItem(
                            title,
                            item.item,
                          ),
                          useWebView: true,
                        );
                      }
                    : null,
              );
            },
            primary: false,
            shrinkWrap: true,
          ),
        ],
      ),
    );
  }
}
