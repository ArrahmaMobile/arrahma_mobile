import 'package:arrahma_shared/shared.dart';

/// Registry for quick content lookup by URL or ID
///
/// This registry is built from AppData and allows the app to:
/// - Recognize when a URL points to content already loaded in memory
/// - Navigate directly to in-app content instead of opening webview
/// - Perform O(1) lookups instead of traversing the drawer tree
class ContentRegistry {
  /// Map from normalized URL to DrawerItem with QuranCourseContent
  final Map<String, DrawerItem> _urlToContent = {};

  /// Map from course ID to DrawerItem with QuranCourseContent
  final Map<String, DrawerItem> _idToContent = {};

  /// Map from normalized URL to DrawerItem with MediaContent
  final Map<String, DrawerItem> _urlToMedia = {};

  /// Build registry from AppData
  void buildFromAppData(AppData appData) {
    _urlToContent.clear();
    _idToContent.clear();
    _urlToMedia.clear();

    // Index all drawer items recursively
    for (final item in appData.drawerItems) {
      _indexDrawerItem(item);
    }
  }

  /// Recursively index a drawer item and its children
  void _indexDrawerItem(DrawerItem item) {
    // Index QuranCourseContent
    if (item.content != null) {
      final content = item.content!;

      // Index by ID
      _idToContent[content.id] = item;

      // Index by URL (if item has a link)
      if (item.link != null) {
        final normalizedUrl = _normalizeUrl(item.link!.data);
        _urlToContent[normalizedUrl] = item;
      }
    }

    // Index MediaContent
    if (item.media != null && item.link != null) {
      final normalizedUrl = _normalizeUrl(item.link!.data);
      _urlToMedia[normalizedUrl] = item;
    }

    // Recursively index children
    if (item.children != null) {
      for (final child in item.children!) {
        _indexDrawerItem(child);
      }
    }
  }

  /// Normalize URL for consistent matching
  /// - Converts to lowercase
  /// - Removes trailing slashes
  /// - Removes http/https protocol differences
  /// - Removes www prefix
  String _normalizeUrl(String url) {
    var normalized = url.toLowerCase().trim();

    // Remove protocol
    normalized = normalized
        .replaceFirst('https://', '')
        .replaceFirst('http://', '');

    // Remove www
    normalized = normalized.replaceFirst('www.', '');

    // Remove trailing slash
    if (normalized.endsWith('/')) {
      normalized = normalized.substring(0, normalized.length - 1);
    }

    return normalized;
  }

  /// Look up QuranCourseContent by URL
  /// Returns the DrawerItem containing the content, or null if not found
  DrawerItem? findContentByUrl(String url) {
    final normalized = _normalizeUrl(url);
    return _urlToContent[normalized];
  }

  /// Look up QuranCourseContent by ID
  /// Returns the DrawerItem containing the content, or null if not found
  DrawerItem? findContentById(String id) {
    return _idToContent[id];
  }

  /// Look up MediaContent by URL
  /// Returns the DrawerItem containing the media, or null if not found
  DrawerItem? findMediaByUrl(String url) {
    final normalized = _normalizeUrl(url);
    return _urlToMedia[normalized];
  }

  /// Check if a URL points to content we have loaded
  bool hasContentForUrl(String url) {
    final normalized = _normalizeUrl(url);
    return _urlToContent.containsKey(normalized) ||
           _urlToMedia.containsKey(normalized);
  }

  /// Get stats for debugging
  Map<String, int> get stats => {
    'courseContentItems': _urlToContent.length,
    'mediaContentItems': _urlToMedia.length,
    'totalContentIds': _idToContent.length,
  };
}
