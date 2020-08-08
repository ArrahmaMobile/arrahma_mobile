class UrlUtils {
  static bool isAbsoluteUrl(String url) {
    return url.indexOf('://') > 0 || url.indexOf('//') == 0;
  }
}
