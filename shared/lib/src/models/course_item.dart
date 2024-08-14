import 'package:dart_json_mapper/dart_json_mapper.dart';

@jsonSerializable
class CourseLinkItem {
  const CourseLinkItem({required this.name, required this.links});
  final String name;
  final List<String> links;
}
