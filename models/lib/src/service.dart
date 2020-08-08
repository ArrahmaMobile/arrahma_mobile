import 'package:simple_json_mapper/simple_json_mapper.dart';

import '../models.dart';

class ModelService {
  static AppMetadata deserializeAppData(dynamic data) {
    return JsonMapper.deserialize<AppMetadata>(data);
  }

  static ScrapedData deserializeScrapedData(dynamic data) {
    return JsonMapper.deserialize<ScrapedData>(data);
  }

  static String serializeAppData(AppMetadata data) {
    return JsonMapper.serialize(data);
  }

  static String serializeScrapedData(ScrapedData data) {
    return JsonMapper.serialize(data);
  }
}
