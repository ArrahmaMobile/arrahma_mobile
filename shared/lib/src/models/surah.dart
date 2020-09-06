class Surah {
  const Surah(
      {this.name,
      this.arabicName,
      this.description,
      this.groupNames,
      this.lessons});
  final String name;
  final String arabicName;
  final String description;
  final List<String> groupNames;

  final List<Lesson> lessons;
}

class Lesson {
  const Lesson(
      {this.title,
      this.ayahNum,
      this.lessonNum,
      this.uploadDate,
      this.itemGroups});
  final String title;
  final String lessonNum;
  final String ayahNum;
  final String uploadDate;
  final List<ItemGroup> itemGroups;
}

class ItemGroup {
  const ItemGroup({this.items});
  final List<String> items;
}
