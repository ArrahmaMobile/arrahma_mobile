import 'package:dart_json_mapper/dart_json_mapper.dart';

@jsonSerializable
class QuranCourseDetails {
  const QuranCourseDetails({required this.type, required this.details});
  final QuranCourseDetailsType type;
  final String details;
}

@jsonSerializable
enum QuranCourseDetailsType { Pdf, Markdown }
