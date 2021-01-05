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
            itemBuilder: (_, index) => ListTile(
              title: Text(tests.items[index].title),
              onTap: () {},
            ),
            primary: false,
            shrinkWrap: true,
          ),
        ],
      ),
    );
  }
}
