import 'dart:convert';

import 'package:test/test.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:scraper/scraper.dart';

void main() {
  MockClient client;

  test('calling initiate(client) returns a list of storylinks', () async {
    // Arrange
    client = MockClient((req) => Future(() => Response('''
      <body>
        <table><tbody><tr>
        <td class="title">
          <a class="storylink" href="https://google.com">Story title</a>
        </td>
        </tr></tbody></table>
      </body>
    ''', 200)));

    // Act
    var response = await Scraper(client).initiate();

    // Assert
    expect(
        response,
        equals(json.encode([
          {
            'title': 'Story title',
            'href': 'https://google.com',
          }
        ])));
  });

  test('calling initiate(client) should silently fail', () async {
    // Arrange
    client = MockClient((req) => Future(() => Response('Failed', 400)));

    // Act
    var response = await Scraper(client).initiate();

    // Assert
    expect(response, equals('Failed'));
  });
}
