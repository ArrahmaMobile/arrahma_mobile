import 'package:arrahma_mobile_app/core/utils.dart';
import 'package:arrahma_shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_framework/flutter_framework.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import 'basic_webview.dart';

class MediaContentView extends StatelessWidget {
  const MediaContentView({
    Key key,
    this.content,
  }) : super(key: key);

  final MediaContent content;

  @override
  Widget build(BuildContext context) {
    final showForm = content.items?.length == 1 &&
        content.items.first.item?.type == ItemType.WebForm;
    final child = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (content.description != null)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: MarkdownBody(
              data: content.description,
            ),
          ),
        if (showForm)
          Flexible(
            child: BasicWebView(
              url: content.items.first.item.data,
              whitelistedDomains: const ['arrahma.org'],
            ),
          )
        else
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
                            ));
                      }
                    : null,
              );
            },
            primary: false,
            shrinkWrap: true,
          ),
      ],
    );
    return showForm
        ? child
        : SingleChildScrollView(
            child: child,
          );
  }
}
