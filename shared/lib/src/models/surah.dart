import 'package:dart_json_mapper/dart_json_mapper.dart';

@jsonSerializable
class Surah {
  const Surah(
      {this.name,
      this.arabicName,
      this.description,
      required this.groups,
      required this.lessons});
  final String? name;
  final String? arabicName;
  final String? description;
  final List<Group?> groups;

  final List<Lesson> lessons;

  Surah update({String? name}) {
    return Surah(
      name: name ?? this.name,
      arabicName: arabicName,
      description: description,
      groups: groups,
      lessons: lessons,
    );
  }
}

@jsonSerializable
class Lesson {
  const Lesson(
      {required this.title,
      this.ayahNum,
      this.lessonNum,
      this.uploadDate,
      required this.itemGroups});
  final String? title;
  final String? lessonNum;
  final String? ayahNum;
  final String? uploadDate;
  final List<GroupItem> itemGroups;
}

@jsonSerializable
class GroupItem {
  const GroupItem({required this.items});
  final List<Item> items;
}

@jsonSerializable
class TitledItem extends Item {
  const TitledItem({
    required this.title,
    required super.type,
    required super.data,
    required super.isDirectSource,
    required super.isExternal,
  });

  factory TitledItem.fromItem(String title, Item item) {
    return TitledItem(
      title: title,
      data: item.data,
      type: item.type,
      isDirectSource: item.isDirectSource,
      isExternal: item.isExternal,
    );
  }

  final String title;
}

@jsonSerializable
class Item {
  const Item({
    required this.type,
    required this.data,
    required this.isDirectSource,
    this.isExternal,
    this.imageUrl,
  });
  final bool isDirectSource;
  final bool? isExternal;
  final ItemType type;
  final String data;
  final String? imageUrl;

  Item copyWith({
    bool? isDirectSource,
    bool? isExternal,
    ItemType? type,
    String? data,
    String? imageUrl,
  }) {
    return Item(
      isDirectSource: isDirectSource ?? this.isDirectSource,
      isExternal: isExternal ?? this.isExternal,
      type: type ?? this.type,
      data: data ?? this.data,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}

@jsonSerializable
class MediaItem {
  const MediaItem({this.item, this.imageUrl, this.title});
  final Item? item;
  final String? imageUrl;
  final String? title;
}

@jsonSerializable
class MediaContent {
  const MediaContent({this.title, this.description, required this.items});
  final String? title;
  final String? description;
  final List<MediaItem>? items;
}

@jsonSerializable
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

@jsonSerializable
class Group {
  const Group({required this.name});
  final String name;
}
