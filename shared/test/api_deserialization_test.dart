import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:test/test.dart';
import 'package:dart_json_mapper/dart_json_mapper.dart';
import 'package:arrahma_shared/shared.dart';

void main() {
  setUpAll(() {
    initializeJsonMapper();
  });

  test('Deserialize live API data from arrahmah.sasid.me', () async {
    print('Fetching data from API...');

    final response = await http.get(
      Uri.parse('https://arrahmah.sasid.me/api/data'),
      headers: {
        'Accept': 'application/json',
      },
    );

    print('Response status: ${response.statusCode}');
    print('Response headers: ${response.headers}');
    print('Response body length: ${response.body.length} bytes');

    expect(response.statusCode, 200, reason: 'API should return 200 OK');

    // Print first 500 characters of response
    print('Response preview: ${response.body.substring(0, 500.clamp(0, response.body.length))}...');

    try {
      // First, try to parse as JSON to ensure it's valid
      print('\n--- Parsing JSON ---');
      final jsonData = jsonDecode(response.body);
      print('JSON parsed successfully');
      print('Top-level keys: ${(jsonData as Map).keys.join(', ')}');

      // Check structure
      print('\nChecking structure:');
        print('  - logoUrl: ${jsonData['logoUrl']?.runtimeType}');
        print('  - quickLinks: ${jsonData['quickLinks']?.runtimeType} (length: ${(jsonData['quickLinks'] as List?)?.length})');
        print('  - courses: ${jsonData['courses']?.runtimeType} (length: ${(jsonData['courses'] as List?)?.length})');
        print('  - duaCategories: ${jsonData['duaCategories']?.runtimeType} (length: ${(jsonData['duaCategories'] as List?)?.length})');

        // Check first course structure if available
        if (jsonData['courses'] != null && (jsonData['courses'] as List).isNotEmpty) {
          final firstCourse = (jsonData['courses'] as List)[0];
          print('\nFirst course structure:');
          print('  - title: ${firstCourse['title']}');
          print('  - imageUrl: ${firstCourse['imageUrl']}');
          print('  - courseDetails: ${firstCourse['courseDetails']}');
          print('  - tests: ${firstCourse['tests']}');

          if (firstCourse['tests'] != null) {
            print('\nTests structure:');
            print('  - tests type: ${firstCourse['tests'].runtimeType}');
            print('  - tests keys: ${(firstCourse['tests'] as Map?)?.keys.join(', ')}');
            if (firstCourse['tests']['items'] != null && (firstCourse['tests']['items'] as List).isNotEmpty) {
              print('  - first test item: ${firstCourse['tests']['items'][0]}');
            }
          }
        }

      // Check first dua category if available
      if (jsonData['duaCategories'] != null && (jsonData['duaCategories'] as List).isNotEmpty) {
        final firstDua = (jsonData['duaCategories'] as List)[0];
        print('\nFirst dua category structure:');
        print('  - title: ${firstDua['title']}');
        print('  - titleUrdu: ${firstDua['titleUrdu']}');
        print('  - duas length: ${(firstDua['duas'] as List?)?.length}');
      }

      // Now try to deserialize with dart_json_mapper
      print('\n--- Deserializing with dart_json_mapper ---');
      final appData = JsonMapper.deserialize<AppData>(response.body);

      if (appData == null) {
        print('ERROR: Deserialization returned null!');
        fail('AppData deserialization returned null');
      }

      print('SUCCESS: AppData deserialized!');
      print('  - Logo URL: ${appData.logoUrl}');
      print('  - Quick Links count: ${appData.quickLinks.length}');
      print('  - Courses count: ${appData.courses.length}');
      print('  - Dua Categories count: ${appData.duaCategories?.length ?? 0}');

      // Validate some required fields
      expect(appData.logoUrl, isNotEmpty, reason: 'logoUrl should not be empty');
      expect(appData.quickLinks, isNotEmpty, reason: 'quickLinks should not be empty');
      expect(appData.courses, isNotEmpty, reason: 'courses should not be empty');

      print('\n--- Test PASSED ---');
    } catch (e, stackTrace) {
      print('\n!!! DESERIALIZATION ERROR !!!');
      print('Error: $e');
      print('Stack trace:');
      print(stackTrace);

      // Try to identify which field is causing the issue
      print('\n--- Attempting to identify problematic field ---');
      try {
        final jsonData = jsonDecode(response.body) as Map<String, dynamic>;

        // Try deserializing individual top-level arrays
        print('\nTesting individual components:');

        // Test quick links
        try {
          final quickLinks = JsonMapper.deserialize<List<QuickLink>>(jsonEncode(jsonData['quickLinks']));
          print('  ✓ QuickLinks: ${quickLinks?.length ?? 0} items');
        } catch (e) {
          print('  ✗ QuickLinks failed: $e');
        }

        // Test courses
        try {
          final courses = JsonMapper.deserialize<List<QuranCourse>>(jsonEncode(jsonData['courses']));
          print('  ✓ Courses: ${courses?.length ?? 0} items');
        } catch (e) {
          print('  ✗ Courses failed: $e');
        }

        // Test dua categories
        try {
          final duaCategories = JsonMapper.deserialize<List<DuaCategory>>(jsonEncode(jsonData['duaCategories']));
          print('  ✓ DuaCategories: ${duaCategories?.length ?? 0} items');
        } catch (e) {
          print('  ✗ DuaCategories failed: $e');
        }

        // Test drawer items
        try {
          final drawerItems = JsonMapper.deserialize<List<DrawerItem>>(jsonEncode(jsonData['drawerItems']));
          print('  ✓ DrawerItems: ${drawerItems?.length ?? 0} items');
        } catch (e) {
          print('  ✗ DrawerItems failed: $e');
        }

      } catch (identifyError) {
        print('Could not identify specific field: $identifyError');
      }

      rethrow;
    }
  });

  test('Test MediaContent deserialization specifically', () async {
    print('Testing MediaContent structure...');

    final testMediaContent = '''
    {
      "title": "Test",
      "description": "Test description",
      "items": [
        {
          "item": {
            "isDirectSource": true,
            "isExternal": false,
            "type": "WebPage",
            "data": "https://example.com",
            "imageUrl": null
          },
          "imageUrl": null,
          "title": null
        }
      ]
    }
    ''';

    try {
      final mediaContent = JsonMapper.deserialize<MediaContent>(testMediaContent);
      print('MediaContent deserialized: $mediaContent');
      expect(mediaContent, isNotNull);
      expect(mediaContent?.items?.length, 1);
    } catch (e, stackTrace) {
      print('ERROR deserializing MediaContent: $e');
      print(stackTrace);
      rethrow;
    }
  });
}
