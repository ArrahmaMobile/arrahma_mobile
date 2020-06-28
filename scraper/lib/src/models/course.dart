class Course {
  const Course({this.title, this.icon, this.items});
  final String title;
  final String icon;
  final List<CourseItem> items;
}

class CourseItem {
  const CourseItem({this.name, this.link});
  final String name;
  final String link;
}
