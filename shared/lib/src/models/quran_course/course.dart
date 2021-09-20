abstract class Course {
  const Course({this.title, this.imageUrl});
  final String title;
  final String imageUrl;
}

class StaticQuranCourse extends Course {
  const StaticQuranCourse({String title, String imageUrl, this.onTap})
      : super(title: title, imageUrl: imageUrl);

  final void Function() onTap;
}
