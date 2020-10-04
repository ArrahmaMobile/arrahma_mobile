import 'package:arrahma_shared/shared.dart' as shared;
import 'package:flutter_framework/flutter_framework.dart';
import '../../mapper.g.dart' as mapper;

class Mapper {
  static void init() {
    BaseMapper.init();
    mapper.init();
    shared.init();
  }
}
