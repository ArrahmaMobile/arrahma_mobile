import 'package:simple_json_mapper/simple_json_mapper.dart';

import '../models/models.dart';

class SerializationService {
  static ScrapedData deserializeScrapedData(dynamic data) {
    return JsonMapper.deserialize<ScrapedData>(data);
  }

  static String serializeScrapedData(ScrapedData data) {
    return JsonMapper.serialize(data);
  }
}
