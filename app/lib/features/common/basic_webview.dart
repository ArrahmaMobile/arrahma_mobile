import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class BasicWebView extends StatefulWidget {
  const BasicWebView({
    required this.url,
    this.onLoad,
    this.onLinkTap,
    this.placeholder,
  });

  /// Url for the initial webview page.
  final String url;

  /// Called right after the widget is rendered.
  final Function(WebViewController controller)? onLoad;

  /// Called when a link pressed.
  final Function(WebViewController controller, String url)? onLinkTap;

  /// Render your own loading widget.
  final Widget? placeholder;

  @override
  _BasicWebViewState createState() => _BasicWebViewState();
}

class _BasicWebViewState extends State<BasicWebView> {
  late WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {
            widget.onLoad?.call(_controller);

            setState(() {
              _isLoading = false;
            });
          },
          onHttpError: (HttpResponseError error) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            widget.onLinkTap?.call(_controller, request.url);
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        WebViewWidget(
          controller: _controller,
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
