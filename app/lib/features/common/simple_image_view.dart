import 'package:arrahma_mobile_app/core/utils.dart';
import 'package:arrahma_mobile_app/features/common/models/saved_file.dart';
import 'package:arrahma_mobile_app/features/common/themed_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_framework/flutter_framework.dart';
import 'package:path/path.dart' as path;
import 'package:photo_view/photo_view.dart';

class SimpleImageView extends StatefulWidget {
  const SimpleImageView({super.key, this.title, required this.url});
  final String url;
  final String? title;

  @override
  _SimpleImageViewState createState() => _SimpleImageViewState();
}

class _SimpleImageViewState extends State<SimpleImageView> {
  late Future<SavedFile> _filePathFuture;

  @override
  void initState() {
    super.initState();
    _filePathFuture = _findPath(widget.url);
  }

  Future<SavedFile> _findPath(String imageUrl) async {
    final fileExtension = path.extension(imageUrl);
    final normalizedFileExtension = !StringUtils.isNullOrEmpty(fileExtension)
        ? fileExtension.substring(1)
        : 'jpg';
    final file = await DefaultCacheManager().getSingleFile(imageUrl);
    final fileName = widget.title ?? path.basenameWithoutExtension(imageUrl);

    final tempFile = await FileUtils.copyFileToTempPath(
        file, fileName, normalizedFileExtension);
    return SavedFile(path: tempFile.path);
  }

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);
    return Column(
      children: [
        if (widget.title != null)
          ThemedAppBar(
            title: widget.title!,
            actions: [
              FutureBuilder<SavedFile>(
                future: _filePathFuture,
                builder: (_, s) => Utils.shareActionButton(
                  widget.title!,
                  s.data?.path != null ? [s.data!.path] : null,
                ),
              )
            ],
          ),
        Expanded(
          child: PhotoView(
            imageProvider: ImageUtils.fromNetworkWithCached(widget.url),
            backgroundDecoration: BoxDecoration(
              color: appTheme.theme!.colorScheme.surface,
            ),
          ),
        ),
      ],
    );
  }
}
