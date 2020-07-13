// GENERATED CODE - DO NOT MODIFY BY HAND
// Generated and consumed by 'simple_json' 

import 'package:simple_json_mapper/simple_json_mapper.dart';
import 'package:scraper_service/src/models/run_metadata.dart';
import 'package:scraper_service/src/models/scraped_data.dart';
import 'package:scraper/src/models/app_metadata.dart';
import 'package:scraper/src/models/banner.dart';
import 'package:scraper/src/models/broadcast_link.dart';
import 'package:scraper/src/models/course.dart';

final _runmetadataMapper = JsonObjectMapper(
  (CustomJsonMapper mapper, Map<String, dynamic> json) => RunMetadata(
    lastUpdate: mapper.applyFromJsonConverter(json['lastUpdate']),
  ),
  (CustomJsonMapper mapper, RunMetadata instance) => <String, dynamic>{
    'lastUpdate': mapper.applyFromInstanceConverter(instance.lastUpdate),
  },
);


final _scrapeddataMapper = JsonObjectMapper(
  (CustomJsonMapper mapper, Map<String, dynamic> json) => ScrapedData(
    appMetadata: mapper.deserialize<AppMetadata>(json['appMetadata'] as Map<String, dynamic>),
    runMetadata: mapper.deserialize<RunMetadata>(json['runMetadata'] as Map<String, dynamic>),
  ),
  (CustomJsonMapper mapper, ScrapedData instance) => <String, dynamic>{
    'appMetadata': mapper.serializeToMap(instance.appMetadata),
    'runMetadata': mapper.serializeToMap(instance.runMetadata),
  },
);


final _appmetadataMapper = JsonObjectMapper(
  (CustomJsonMapper mapper, Map<String, dynamic> json) => AppMetadata(
    logoUrl: mapper.applyFromJsonConverter(json['logoUrl']),
    banners: (json['banners'] as List)?.cast<Map<String, dynamic>>()?.map((item) => mapper.deserialize<Banner>(item))?.toList(),
    broadcastLinks: (json['broadcastLinks'] as List)?.cast<Map<String, dynamic>>()?.map((item) => mapper.deserialize<BroadcastLink>(item))?.toList(),
    courses: (json['courses'] as List)?.cast<Map<String, dynamic>>()?.map((item) => mapper.deserialize<Course>(item))?.toList(),
  ),
  (CustomJsonMapper mapper, AppMetadata instance) => <String, dynamic>{
    'logoUrl': mapper.applyFromInstanceConverter(instance.logoUrl),
    'banners': instance.banners?.map((item) => mapper.serializeToMap(item))?.toList(),
    'broadcastLinks': instance.broadcastLinks?.map((item) => mapper.serializeToMap(item))?.toList(),
    'courses': instance.courses?.map((item) => mapper.serializeToMap(item))?.toList(),
  },
);


final _bannerMapper = JsonObjectMapper(
  (CustomJsonMapper mapper, Map<String, dynamic> json) => Banner(
    imageUrl: mapper.applyFromJsonConverter(json['imageUrl']),
    link: mapper.applyFromJsonConverter(json['link']),
  ),
  (CustomJsonMapper mapper, Banner instance) => <String, dynamic>{
    'imageUrl': mapper.applyFromInstanceConverter(instance.imageUrl),
    'link': mapper.applyFromInstanceConverter(instance.link),
  },
);


final _broadcastlinkMapper = JsonObjectMapper(
  (CustomJsonMapper mapper, Map<String, dynamic> json) => BroadcastLink(
    type: mapper.applyFromJsonConverter(BroadcastType.values.firstWhere(
        (item) => item.toString().split('.')[1].toLowerCase() == json['type']?.toLowerCase(),
        orElse: () => null)),
    imageUrl: mapper.applyFromJsonConverter(json['imageUrl']),
    link: mapper.applyFromJsonConverter(json['link']),
  ),
  (CustomJsonMapper mapper, BroadcastLink instance) => <String, dynamic>{
    'type': mapper.applyFromInstanceConverter(instance.type.toString().split('.')[1]),
    'imageUrl': mapper.applyFromInstanceConverter(instance.imageUrl),
    'link': mapper.applyFromInstanceConverter(instance.link),
  },
);


final _courseMapper = JsonObjectMapper(
  (CustomJsonMapper mapper, Map<String, dynamic> json) => Course(
    title: mapper.applyFromJsonConverter(json['title']),
    imageUrl: mapper.applyFromJsonConverter(json['imageUrl']),
    items: (json['items'] as List)?.cast<Map<String, dynamic>>()?.map((item) => mapper.deserialize<CourseItem>(item))?.toList(),
  ),
  (CustomJsonMapper mapper, Course instance) => <String, dynamic>{
    'title': mapper.applyFromInstanceConverter(instance.title),
    'imageUrl': mapper.applyFromInstanceConverter(instance.imageUrl),
    'items': instance.items?.map((item) => mapper.serializeToMap(item))?.toList(),
  },
);



final _courseitemMapper = JsonObjectMapper(
  (CustomJsonMapper mapper, Map<String, dynamic> json) => CourseItem(
    name: mapper.applyFromJsonConverter(json['name']),
    link: mapper.applyFromJsonConverter(json['link']),
  ),
  (CustomJsonMapper mapper, CourseItem instance) => <String, dynamic>{
    'name': mapper.applyFromInstanceConverter(instance.name),
    'link': mapper.applyFromInstanceConverter(instance.link),
  },
);

void init() {
  JsonMapper.register(_runmetadataMapper);
  JsonMapper.register(_scrapeddataMapper);
  JsonMapper.register(_appmetadataMapper);
  JsonMapper.register(_bannerMapper);
  JsonMapper.register(_broadcastlinkMapper);
  JsonMapper.register(_courseMapper);
  JsonMapper.register(_courseitemMapper); 

  JsonMapper.registerListCast((value) => value?.cast<RunMetadata>()?.toList());
  JsonMapper.registerListCast((value) => value?.cast<ScrapedData>()?.toList());
  JsonMapper.registerListCast((value) => value?.cast<AppMetadata>()?.toList());
  JsonMapper.registerListCast((value) => value?.cast<Banner>()?.toList());
  JsonMapper.registerListCast((value) => value?.cast<BroadcastLink>()?.toList());
  JsonMapper.registerListCast((value) => value?.cast<Course>()?.toList());
  JsonMapper.registerListCast((value) => value?.cast<BroadcastType>()?.toList());
  JsonMapper.registerListCast((value) => value?.cast<CourseItem>()?.toList());
}
    