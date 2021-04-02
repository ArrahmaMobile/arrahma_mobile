import 'package:arrahma_shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:inherited_state/inherited_state.dart';

class AboutUsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appData = context.on<AppData>();
    return Markdown(data: appData.aboutUsMarkdown);
  }
}
