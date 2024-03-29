import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class BasicWebView extends StatefulWidget {
  const BasicWebView({
    @required this.url,
    this.onLoad,
    this.onLinkTap,
    this.placeholder,
  });

  /// Url for the initial webview page.
  final String url;

  /// Called right after the widget is rendered.
  final Function(WebViewController controller) onLoad;

  /// Called when a link pressed.
  final Function(WebViewController controller, String url) onLinkTap;

  /// Render your own loading widget.
  final Widget placeholder;

  @override
  _BasicWebViewState createState() => _BasicWebViewState();
}

class _BasicWebViewState extends State<BasicWebView> {
  WebViewController _controller;
  bool _isLoading = true;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        WebView(
          initialUrl: widget.url,
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController webViewController) {
            setState(() {
              _controller = webViewController;
            });
          },
          navigationDelegate: (NavigationRequest request) {
            if (widget.onLinkTap != null) {
              widget.onLinkTap(_controller, request.url);
            }

            return NavigationDecision.navigate;
          },
          onPageFinished: (_) {
            if (widget.onLoad != null) {
              widget.onLoad(_controller);
            }

            setState(() {
              _isLoading = false;
            });
          },
        ),
        if (_isLoading)
          widget.placeholder ??
              const Center(
                child: CircularProgressIndicator(),
              )
        else
          Container(),
      ],
    );
  }
}
