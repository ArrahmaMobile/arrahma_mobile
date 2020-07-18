class Course<T> {
  const Course({this.title, this.imageUrl, this.pageRoute, this.data});
  final String title;
  final String imageUrl;
  final String pageRoute;
  final T data;
}
