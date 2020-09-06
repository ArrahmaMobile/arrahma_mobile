enum BroadcastType { Phone, Facebook, Youtube, Mixlr, Other }

class BroadcastItem {
  const BroadcastItem({this.type, this.imageUrl, this.linkUrl});
  final BroadcastType type;
  final String imageUrl;
  final String linkUrl;
}
