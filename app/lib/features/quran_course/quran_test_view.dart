import 'package:arrahma_mobile_app/core/utils.dart';
import 'package:arrahma_shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class QuranTestsView extends StatelessWidget {
  const QuranTestsView({
    Key key,
    this.tests,
  }) : super(key: key);

  final MediaContent tests;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: MarkdownBody(
              data: tests.description,
            ),
          ),
          ListView.builder(
            itemCount: tests.items.length,
            itemBuilder: (_, index) {
              final item = tests.items[index];
              final title = item.title;
              return ListTile(
                title: Text(title),
                onTap: item.item?.data != null
                    ? () {
                        Utils.openUrl(
                            context,
                            TitledItem(
                              title: title,
                              isDirectSource: item.item.isDirectSource,
                              type: item.item.type,
                              data: item.item.data,
                            ));
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
