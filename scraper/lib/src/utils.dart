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
