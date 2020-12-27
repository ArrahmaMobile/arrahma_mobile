import 'package:arrahma_mobile_app/features/common/basic_webview.dart';
import 'package:arrahma_shared/shared.dart';
import 'package:flutter/material.dart';

class QuranRegistrationView extends StatelessWidget {
  const QuranRegistrationView({
    Key key,
    @required this.registration,
  }) : super(key: key);
  final QuranCourseRegistration registration;

  @override
  Widget build(BuildContext context) {
    return BasicWebView(
      url: registration.url,
      whitelistedDomains: const ['arrahma.org'],
    );
  }
}
