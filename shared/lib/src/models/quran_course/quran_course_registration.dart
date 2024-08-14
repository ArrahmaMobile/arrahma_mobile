import 'package:dart_json_mapper/dart_json_mapper.dart';

@jsonSerializable
class QuranCourseRegistration {
  const QuranCourseRegistration({required this.type, required this.url});
  final RegistrationType type;
  final String url;
}

@jsonSerializable
enum RegistrationType {
  WebForm,
}
