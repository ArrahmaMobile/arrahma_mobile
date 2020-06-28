enum BroadcastType { Phone, Facebook, Youtube, Mixlr, Other }

class BroadcastLink {
  const BroadcastLink({this.type, this.imageUrl, this.link});
  final BroadcastType type;
  final String imageUrl;
  final String link;
}
