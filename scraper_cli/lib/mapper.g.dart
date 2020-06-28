// GENERATED CODE - DO NOT MODIFY BY HAND
// Generated and consumed by 'simple_json' 

import 'package:simple_json_mapper/simple_json_mapper.dart';
import 'package:scraper/src/models/arrahma.dart';
import 'package:scraper/src/models/banner.dart';
import 'package:scraper/src/models/broadcast_link.dart';
import 'package:scraper/src/models/course.dart';

final _arrahmaMapper = JsonObjectMapper(
  (CustomJsonMapper mapper, Map<String, dynamic> json) => Arrahma(
    logoUrl: mapper.applyFromJsonConverter(json['logoUrl']),
    banners: (json['banners'] as List).cast<Map<String, dynamic>>().map((item) => mapper.deserialize<Banner>(item)).toList(),
    broadcastLinks: (json['broadcastLinks'] as List).cast<Map<String, dynamic>>().map((item) => mapper.deserialize<BroadcastLink>(item)).toList(),
    courses: (json['courses'] as List).cast<Map<String, dynamic>>().map((item) => mapper.deserialize<Course>(item)).toList(),
  ),
  (CustomJsonMapper mapper, Arrahma instance) => <String, dynamic>{
    'logoUrl': mapper.applyFromInstanceConverter(instance.logoUrl),
    'banners': instance.banners.map((item) => mapper.serializeToMap(item)).toList(),
    'broadcastLinks': instance.broadcastLinks.map((item) => mapper.serializeToMap(item)).toList(),
    'courses': instance.courses.map((item) => mapper.serializeToMap(item)).toList(),
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
        (item) => item.toString().split('.')[1].toLowerCase() == json['type'].toLowerCase(),
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
    items: (json['items'] as List).cast<Map<String, dynamic>>().map((item) => mapper.deserialize<CourseItem>(item)).toList(),
  ),
  (CustomJsonMapper mapper, Course instance) => <String, dynamic>{
    'title': mapper.applyFromInstanceConverter(instance.title),
    'imageUrl': mapper.applyFromInstanceConverter(instance.imageUrl),
    'items': instance.items.map((item) => mapper.serializeToMap(item)).toList(),
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
  JsonMapper.register(_arrahmaMapper);
  JsonMapper.register(_bannerMapper);
  JsonMapper.register(_broadcastlinkMapper);
  JsonMapper.register(_courseMapper);
  JsonMapper.register(_courseitemMapper); 
}
    