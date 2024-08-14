import 'package:dart_json_mapper/dart_json_mapper.dart';

@jsonSerializable

/// Use [TawkVisitor] to set the visitor name and email.
class TawkVisitor {
  const TawkVisitor({
    required this.name,
    required this.email,
    this.hash,
  });

  /// Visitor's name.
  final String name;

  /// Visitor's email.
  final String email;

  /// [Secure mode](https://developer.tawk.to/jsapi/#SecureMode).
  final String? hash;
}
