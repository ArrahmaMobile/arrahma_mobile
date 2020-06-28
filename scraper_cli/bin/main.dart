import 'dart:io';

import 'package:http/http.dart';
import 'package:scraper/scraper.dart';
import 'package:simple_json_mapper/simple_json_mapper.dart';

import 'package:scraper_cli/mapper.g.dart' as mapper;

Future main(List<String> arguments) async {
  mapper.init();
  final outputDir = 'out';
  final result = await Scraper(Client()).initiate();

  await Directory(outputDir).create(recursive: true);
  final dataFile = File('${outputDir}/data.json');

  await dataFile.writeAsString(JsonMapper.serialize(result),
      mode: FileMode.write);
}
