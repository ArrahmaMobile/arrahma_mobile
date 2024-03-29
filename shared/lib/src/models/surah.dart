class Surah {
  const Surah(
      {this.name,
      this.arabicName,
      this.description,
      this.groups,
      this.lessons});
  final String name;
  final String arabicName;
  final String description;
  final List<Group> groups;

  final List<Lesson> lessons;

  Surah update({String name}) {
    return Surah(
      name: name ?? this.name,
      arabicName: arabicName,
      description: description,
      groups: groups,
      lessons: lessons,
    );
  }
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
  final List<GroupItem> itemGroups;
}

class GroupItem {
  const GroupItem({this.items});
  final List<Item> items;
}

class TitledItem extends Item {
  const TitledItem({
    this.title,
    ItemType type,
    String data,
    bool isDirectSource,
  }) : super(data: data, isDirectSource: isDirectSource, type: type);

  factory TitledItem.fromItem(String title, Item item) {
    return TitledItem(
      title: title,
      data: item.data,
      type: item.type,
      isDirectSource: item.isDirectSource,
    );
  }

  final String title;
}

class Item {
  const Item({
    this.type,
    this.data,
    this.isDirectSource,
    this.isExternal,
  });
  final bool isDirectSource;
  final bool isExternal;
  final ItemType type;
  final String data;
}

class MediaItem {
  const MediaItem({this.item, this.imageUrl, this.title});
  final Item item;
  final String imageUrl;
  final String title;
}

class MediaContent {
  const MediaContent({this.title, this.description, this.items});
  final String title;
  final String description;
  final List<MediaItem> items;
}

enum ItemType {
  Audio,
  Video,
  Pdf,
  Image,
  WebPage,
  File,
  Title,
  Markdown,
  Other
}

class Group {
  const Group({this.name});
  final String name;
}
