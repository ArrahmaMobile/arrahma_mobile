abstract class Course {
  const Course({required this.title, required this.imageUrl});
  final String title;
  final String imageUrl;
}

class StaticQuranCourse extends Course {
  const StaticQuranCourse({required String title, required String imageUrl, required this.onTap})
      : super(title: title, imageUrl: imageUrl);

  final void Function() onTap;
}
