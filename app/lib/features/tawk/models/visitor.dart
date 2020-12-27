import 'package:simple_json_mapper/simple_json_mapper.dart';

@JObj()

/// Use [TawkVisitor] to set the visitor name and email.
class TawkVisitor {
  const TawkVisitor({
    this.name,
    this.email,
    this.hash,
  });

  /// Visitor's name.
  final String name;

  /// Visitor's email.
  final String email;

  /// [Secure mode](https://developer.tawk.to/jsapi/#SecureMode).
  final String hash;
}
