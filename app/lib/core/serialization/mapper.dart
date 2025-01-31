import 'package:arrahma_mobile_app/main.mapper.g.dart';
import 'package:arrahma_shared/shared.dart' as shared;
import 'package:dart_json_mapper/dart_json_mapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_framework/flutter_framework.dart' as framework;

class Mapper {
  static void init() {
    initializeJsonMapper(adapters: [
      shared.sharedGeneratedAdapter,
      framework.flutterFrameworkGeneratedAdapter,
      const JsonMapperAdapter(enumValues: {
        ThemeMode: ThemeMode.values,
      })
    ]);
  }
}
