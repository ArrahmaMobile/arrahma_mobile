class CourseItem {
  const CourseItem({this.title, this.imageUrl, this.items});
  final String title;
  final String imageUrl;
  final List<CourseSubItem> items;
}

class CourseSubItem {
  const CourseSubItem({this.name, this.link});
  final String name;
  final String link;
}
