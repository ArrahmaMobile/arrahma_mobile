import 'package:dart_json_mapper/dart_json_mapper.dart';

import 'models.dart';

@jsonSerializable
class HeadingBanner {
  const HeadingBanner({required this.imageUrl, required this.item});
  final String imageUrl;
  final Item item;
}
