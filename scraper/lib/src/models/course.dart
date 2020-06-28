class Course {
  const Course({this.title, this.imageUrl, this.items});
  final String title;
  final String imageUrl;
  final List<CourseItem> items;
}

class CourseItem {
  const CourseItem({this.name, this.link});
  final String name;
  final String link;
}
