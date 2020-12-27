class QuranCourseRegistration {
  const QuranCourseRegistration({this.type, this.url});
  final RegistrationType type;
  final String url;
}

enum RegistrationType {
  WebForm,
}
