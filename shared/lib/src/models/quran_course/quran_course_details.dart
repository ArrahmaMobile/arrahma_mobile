class QuranCourseDetails {
  const QuranCourseDetails({this.type, this.details});
  final QuranCourseDetailsType type;
  final String details;
}

enum QuranCourseDetailsType { Pdf, Markdown }
