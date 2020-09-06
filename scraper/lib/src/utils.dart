class Utils {
  static String cleanText(String text) {
    return text?.replaceAll(RegExp(r'\s+'), ' ')?.trim();
  }
}

extension StringUtils on String {
  String get cleanedText => Utils.cleanText(this);
  String toAbsolute(String currentUrl) =>
      Uri.parse(currentUrl).resolve(this).toString();
}

extension IntUtils on int {}
