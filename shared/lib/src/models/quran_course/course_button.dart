import 'package:dart_json_mapper/dart_json_mapper.dart';

@jsonSerializable
enum CourseButtonType {
  details,
  register,
  join,
  link,
}

@jsonSerializable
class CourseButton {
  const CourseButton({
    required this.label,
    required this.type,
    required this.isActive,
    required this.url,
  });

  final String label;
  final CourseButtonType type;
  final bool isActive; // true if clickable/open, false if closed/disabled
  final String url;
}
