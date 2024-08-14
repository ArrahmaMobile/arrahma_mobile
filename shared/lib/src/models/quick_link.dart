import 'package:dart_json_mapper/dart_json_mapper.dart';

import 'models.dart';

@jsonSerializable
class QuickLink {
  const QuickLink({required this.title, required this.link});
  final String title;
  final Item? link;
}
