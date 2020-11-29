import 'models.dart';

enum BroadcastType { Phone, Facebook, Youtube, Mixlr, Other }

class BroadcastItem {
  const BroadcastItem({this.type, this.imageUrl, this.item});
  final BroadcastType type;
  final String imageUrl;
  final Item item;
}
