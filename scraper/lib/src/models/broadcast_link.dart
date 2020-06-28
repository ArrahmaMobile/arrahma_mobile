enum BroadcastType { Phone, Facebook, Youtube, Mixlr, Other }

class BroadcastLink {
  const BroadcastLink({this.type, this.image, this.link});
  final BroadcastType type;
  final String image;
  final String link;
}
