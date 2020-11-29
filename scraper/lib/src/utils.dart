import 'package:arrahma_shared/shared.dart';

class Utils {
  static String cleanText(String text) {
    return text?.replaceAll(RegExp(r'\s+'), ' ')?.trim();
  }

  static String cleanUrl(String url) {
    return (url?.toLowerCase()?.startsWith('.http') ?? false)
        ? url.substring(1)
        : url;
  }

  static String enumToString(Object enumVal) {
    final description = enumVal.toString();
    final indexOfDot = description.indexOf('.');
    return description.substring(indexOfDot + 1);
  }

  static Item getItemByUrl(String url) {
    final parsedUri = Uri.parse(url);
    final isDirectSource = parsedUri.pathSegments.isNotEmpty &&
        parsedUri.pathSegments.last.contains('.');
    ItemType type;
    if (isDirectSource) {
      final lastSegment = parsedUri.pathSegments.last.toLowerCase();
      if (lastSegment.endsWith('.pdf')) {
        type = ItemType.Pdf;
      } else if (['.mp3', '.wav'].any((ext) => lastSegment.endsWith(ext))) {
        type = ItemType.Audio;
      } else if (['.mp4'].any((ext) => lastSegment.endsWith(ext))) {
        type = ItemType.Video;
      } else if (['.jpg', '.png', '.jpeg', '.gif']
          .any((ext) => lastSegment.endsWith(ext))) {
        type = ItemType.Image;
      }
      type ??= ItemType.File;
    } else {
      if (['video', 'watch']
          .any((partial) => parsedUri.path.contains(partial))) {
        type = ItemType.Video;
      }
      type ??= ItemType.Website;
    }
    return Item(url: url, type: type, isDirectSource: isDirectSource);
  }
}

extension StringUtils on String {
  bool get isNullOrWhitespace => this?.trim()?.isEmpty ?? true;
  String get cleanedText => Utils.cleanText(this);
  String get cleanedUrl => Utils.cleanUrl(this);
  String removeQueryString() {
    final uri = Uri.parse(this);
    return Uri(
            scheme: uri.scheme,
            userInfo: uri.userInfo,
            host: uri.host,
            port: uri.port,
            pathSegments: uri.pathSegments)
        .toString();
  }

  String toAbsolute(String currentUrl) =>
      Uri.parse(currentUrl).resolve(this).replace(scheme: 'https').toString();
}

extension IntUtils on int {}
