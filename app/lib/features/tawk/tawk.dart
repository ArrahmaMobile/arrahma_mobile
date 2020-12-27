import 'dart:io';

import 'package:arrahma_mobile_app/features/common/basic_webview.dart';
import 'package:flutter/material.dart';
import 'package:simple_json_mapper/simple_json_mapper.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'models/visitor.dart';

/// [Tawk] Widget.
class Tawk extends StatefulWidget {
  const Tawk({
    @required this.directChatLink,
    this.visitor,
  });

  /// Tawk direct chat link.
  final String directChatLink;

  /// Object used to set the visitor name and email.
  final TawkVisitor visitor;

  @override
  _TawkState createState() => _TawkState();
}

class _TawkState extends State<Tawk> {
  void _setUser(WebViewController controller, TawkVisitor visitor) {
    final json = JsonMapper.serialize(visitor);
    String javascriptString;

    if (Platform.isIOS) {
      javascriptString = '''
        Tawk_API = Tawk_API || {};
        Tawk_API.setAttributes($json);
      ''';
    } else {
      javascriptString = '''
        Tawk_API = Tawk_API || {};
        Tawk_API.onLoad = function() {
          Tawk_API.setAttributes($json);
        };
      ''';
    }

    controller.evaluateJavascript(javascriptString);
  }

  @override
  Widget build(BuildContext context) {
    return BasicWebView(
      url: widget.directChatLink,
      whitelistedDomains: const ['tawk.to'],
      onLoad: (controller) {
        if (widget.visitor != null) {
          _setUser(controller, widget.visitor);
        }
      },
    );
  }
}
