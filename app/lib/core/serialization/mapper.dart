import 'package:arrahma_mobile_app/main.mapper.g.dart';
import 'package:arrahma_shared/shared.dart' as shared;
import 'package:flutter_framework/flutter_framework.dart';
class Mapper {
  static void init() {
    BaseMapper.init();
    initializeJsonMapper();
    shared.main();
  }
}
