import 'package:flutter/foundation.dart';
import 'dart:async';

class Debouncer {
  Debouncer({this.milliseconds});

  final int milliseconds;
  Timer _timer;

  void run(VoidCallback action) {
    if (_timer != null) {
      _timer.cancel();
    }
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}
