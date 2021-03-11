import 'package:arrahma_mobile_app/core/utils.dart';
import 'package:arrahma_mobile_app/features/common/themed_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_framework/flutter_framework.dart';
import 'package:photo_view/photo_view.dart';

class SimpleImageView extends StatefulWidget {
  const SimpleImageView({Key key, this.title, this.url}) : super(key: key);
  final String url;
  final String title;

  @override
  _SimpleImageViewState createState() => _SimpleImageViewState();
}

class _SimpleImageViewState extends State<SimpleImageView> {
  Future<String> _filePathFuture;

  @override
  void initState() {
    super.initState();
    _filePathFuture = _findPath(widget.url);
  }

  Future<String> _findPath(String imageUrl) async {
    final file = await DefaultCacheManager().getSingleFile(imageUrl);
    return file.path;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (widget.title != null)
          ThemedAppBar(
            title: widget.title,
            actions: [
              FutureBuilder<String>(
                future: _filePathFuture,
                builder: (_, s) => Utils.shareActionButton(
                  widget.title,
                  s.data != null ? [s.data] : null,
                ),
              )
            ],
          ),
        Expanded(
          child: PhotoView(
            imageProvider: ImageUtils.fromNetworkWithCached(widget.url),
            backgroundDecoration: const BoxDecoration(
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
