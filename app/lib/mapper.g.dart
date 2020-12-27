// GENERATED CODE - DO NOT MODIFY BY HAND
// Generated and consumed by 'simple_json' 

import 'package:simple_json_mapper/simple_json_mapper.dart';
import 'package:arrahma_mobile_app/features/tawk/models/visitor.dart';

final _tawkvisitorMapper = JsonObjectMapper(
  (CustomJsonMapper mapper, Map<String, dynamic> json) => TawkVisitor(
    name: mapper.applyFromJsonConverter(json['name']),
    email: mapper.applyFromJsonConverter(json['email']),
    hash: mapper.applyFromJsonConverter(json['hash']),
  ),
  (CustomJsonMapper mapper, TawkVisitor instance) => <String, dynamic>{
    'name': mapper.applyFromInstanceConverter(instance.name),
    'email': mapper.applyFromInstanceConverter(instance.email),
    'hash': mapper.applyFromInstanceConverter(instance.hash),
  },
);

void init() {
  JsonMapper.register(_tawkvisitorMapper); 

  

  JsonMapper.registerListCast((value) => value?.cast<TawkVisitor>()?.toList());
}
    