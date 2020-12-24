import 'package:arrahma_mobile_app/features/common/themed_app_bar.dart';
import 'package:arrahma_shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:inherited_state/inherited_state.dart';

class AboutUsPage extends StatefulWidget {
  @override
  _AboutUsPageState createState() => _AboutUsPageState();
}

class _AboutUsPageState extends State<AboutUsPage> {
  @override
  Widget build(BuildContext context) {
    final appData = context.on<AppData>();
    return Scaffold(
      appBar: const ThemedAppBar(
        title: 'About Us',
      ),
      body: Markdown(data: appData.aboutUsMarkdown),
    );
  }
}
