// GENERATED CODE - DO NOT MODIFY BY HAND
// Generated and consumed by 'simple_json' 

import 'package:simple_json_mapper/simple_json_mapper.dart';
import 'package:arrahma_mobile_app/services/models/api_response.dart';

final _jsonapiresponseMapper = JsonObjectMapper(
  (CustomJsonMapper mapper, Map<String, dynamic> json) => JsonApiResponse(
    errorData: mapper.applyFromJsonConverter<dynamic>(json['errorData']),
    errorMessage: mapper.applyFromJsonConverter(json['errorMessage']),
    fieldErrors: (json['fieldErrors'] as List)?.cast<Map<String, dynamic>>()?.map((item) => mapper.deserialize<FieldKeyValuePair>(item))?.toList(),
    data: mapper.applyFromJsonConverter<dynamic>(json['data']),
  ),
  (CustomJsonMapper mapper, JsonApiResponse instance) => <String, dynamic>{
    'errorData': mapper.applyFromInstanceConverter<dynamic>(instance.errorData),
    'errorMessage': mapper.applyFromInstanceConverter(instance.errorMessage),
    'fieldErrors': instance.fieldErrors?.map((item) => mapper.serializeToMap(item))?.toList(),
    'data': mapper.applyFromInstanceConverter<dynamic>(instance.data),
  },
);


final _fieldkeyvaluepairMapper = JsonObjectMapper(
  (CustomJsonMapper mapper, Map<String, dynamic> json) => FieldKeyValuePair(
    key: mapper.applyFromJsonConverter(json['key']),
    value: mapper.applyFromJsonConverter(json['value']),
  ),
  (CustomJsonMapper mapper, FieldKeyValuePair instance) => <String, dynamic>{
    'key': mapper.applyFromInstanceConverter(instance.key),
    'value': mapper.applyFromInstanceConverter(instance.value),
  },
);

void init() {
  JsonMapper.register(_jsonapiresponseMapper);
  JsonMapper.register(_fieldkeyvaluepairMapper); 

  JsonMapper.registerListCast((value) => value?.cast<JsonApiResponse>()?.toList());
  JsonMapper.registerListCast((value) => value?.cast<FieldKeyValuePair>()?.toList());
}
    