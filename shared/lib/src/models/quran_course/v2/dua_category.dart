import 'package:dart_json_mapper/dart_json_mapper.dart';

@jsonSerializable
class DuaCategory {
  const DuaCategory({
    required this.title,
    required this.titleUrdu,
    this.imageUrl,
    this.notes,
    required this.duas,
    this.categories,
  });

  final String title;
  final String titleUrdu;
  final String? imageUrl;
  final String? notes;

  final List<Dua> duas;
  final List<DuaCategory>? categories;

  DuaCategory copyWith({
    String? title,
    String? titleUrdu,
    String? imageUrl,
    String? notes,
    List<Dua>? duas,
    List<DuaCategory>? categories,
  }) {
    return DuaCategory(
      title: title ?? this.title,
      titleUrdu: titleUrdu ?? this.titleUrdu,
      imageUrl: imageUrl ?? this.imageUrl,
      notes: notes ?? this.notes,
      duas: duas ?? this.duas,
      categories: categories ?? this.categories,
    );
  }
}

@jsonSerializable
class Dua {
  const Dua({
    required this.id,
    this.title,
    this.titleUrdu,
    required this.dua,
    this.duaEnglish,
    this.duaUrdu,
    this.notes,
  });

  final String id;
  final String? title;
  final String? titleUrdu;
  final String dua;
  final String? duaEnglish;
  final String? duaUrdu;
  final String? notes;
}
