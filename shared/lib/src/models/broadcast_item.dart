import 'package:dart_json_mapper/dart_json_mapper.dart';

import 'models.dart';

@jsonSerializable
enum BroadcastType { Phone, Facebook, Youtube, Mixlr, Other }

@jsonSerializable
class BroadcastItem {
  const BroadcastItem({this.type, required this.imageUrl, required this.item});
  final BroadcastType? type;
  final String imageUrl;
  final Item item;
}
