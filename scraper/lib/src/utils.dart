import 'package:arrahma_shared/shared.dart';

class Utils {
  static String cleanText(String text) {
    return text.replaceAll(RegExp(r'\s+'), ' ').trim();
  }

  static String toAlphaNumeric(String text) {
    return text.replaceAll(RegExp('[^\\w-.&\\/\\s\'()]'), '').trim();
  }

  static String cleanUrl(String url) {
    return url.toLowerCase().startsWith('.http') ? url.substring(1) : url;
  }

  static bool isExternalLink(String urlString, {Uri? url}) {
    url ??= Uri.parse(urlString);
    return !url.host.contains('arrahma.org');
  }

  static String enumToString(Object enumVal) {
    final description = enumVal.toString();
    final indexOfDot = description.indexOf('.');
    return description.substring(indexOfDot + 1);
  }

  static Item? getItemByUrl(String? url) {
    if (url == null) return null;
    final parsedUri = Uri.parse(url);
    final isDirectSource = parsedUri.pathSegments.isNotEmpty &&
        parsedUri.pathSegments.last.contains('.');
    ItemType? type;
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
      } else if (['.php', '.html', '.htm', '.aspx']
          .any((ext) => lastSegment.endsWith(ext))) {
        type = ItemType.WebPage;
      }
      type ??= ItemType.File;
    } else {
      if (['video', 'watch']
              .any((partial) => parsedUri.path.contains(partial)) ||
          ['youtu.be'].any((host) => parsedUri.host.endsWith(host))) {
        type = ItemType.Video;
      }
      type ??= ItemType.WebPage;
    }
    return Item(
      data: url,
      type: type,
      isDirectSource: isDirectSource,
      isExternal: Utils.isExternalLink(url, url: parsedUri),
    );
  }
}

extension StringUtils on String {
  bool get isNullOrWhitespace => this.trim().isEmpty;
  String get cleanedText => Utils.cleanText(this);
  String get alphaNumeric => Utils.toAlphaNumeric(this);
  String get cleanedUrl => Utils.cleanUrl(this);
  List<String> get urlPathSegments => Uri.parse(this).pathSegments;
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

  String toAbsolute(String baseUrl) {
    final parsedUrl = Uri.parse(this);
    final parsedBaseUrl = Uri.parse(baseUrl);
    final host = parsedUrl.host.trim().isEmpty
        ? parsedBaseUrl.host
        : parsedUrl.host.substring(
            !Utils.isExternalLink(this, url: parsedUrl) &&
                    parsedUrl.host.startsWith('www')
                ? 4
                : 0);
    return parsedBaseUrl
        .resolve(this)
        .replace(scheme: 'https', host: host)
        .toString();
  }
}

extension IntUtils on int {}
