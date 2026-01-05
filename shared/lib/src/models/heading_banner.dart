import 'package:dart_json_mapper/dart_json_mapper.dart';

import 'models.dart';

@jsonSerializable
class HeadingBanner {
  const HeadingBanner({
    required this.imageUrl,
    required this.item,
    this.heading,
    this.title,
  });
  final String imageUrl;
  final Item item;
  final String? heading;
  final String? title;
}
