import 'dart:async';
import 'dart:convert';

import 'package:aqueduct/aqueduct.dart';
import 'package:scraper_service/scraper_service.dart';
import 'package:simple_json_mapper/simple_json_mapper.dart';

class DataController extends ResourceController {
  DataController(this._scraperService);

  final ScraperService _scraperService;

  @Operation.get()
  Future<Response> getData() async {
    final data = _scraperService.data;
    final serializedData = JsonMapper.serializeToMap(data);
    print(json.encode(serializedData));
    return Response.ok(serializedData);
  }

  // @Operation.get('id')
  // Future<Response> getHeroByID(@Bind.path('id') int id) async {
  //   final heroQuery = Query<Hero>(context)..where((h) => h.id).equalTo(id);

  //   final hero = await heroQuery.fetchOne();

  //   if (hero == null) {
  //     return Response.notFound();
  //   }
  //   return Response.ok(hero);
  // }

  // @Operation.post()
  // Future<Response> createHero(@Bind.body() Hero inputHero) async {
  //   final query = Query<Hero>(context)..values = inputHero;

  //   final insertedHero = await query.insert();

  //   return Response.ok(insertedHero);
  // }
}