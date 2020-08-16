// GENERATED CODE - DO NOT MODIFY BY HAND
// Generated and consumed by 'simple_json' 

import 'package:simple_json_mapper/simple_json_mapper.dart';
import 'package:arrahma_models/src/scraped_data.dart';
import 'package:arrahma_models/src/status/server_status_check.dart';
import 'package:arrahma_models/src/app_metadata.dart';
import 'package:arrahma_models/src/run_metadata.dart';
import 'package:arrahma_models/src/heading_banner.dart';
import 'package:arrahma_models/src/broadcast_item.dart';
import 'package:arrahma_models/src/quran_course.dart';
import 'package:arrahma_models/src/social_media_item.dart';

final _scrapeddataMapper = JsonObjectMapper(
  (CustomJsonMapper mapper, Map<String, dynamic> json) => ScrapedData(
    appData: mapper.deserialize<AppData>(json['appData'] as Map<String, dynamic>),
    runMetadata: mapper.deserialize<RunMetadata>(json['runMetadata'] as Map<String, dynamic>),
  ),
  (CustomJsonMapper mapper, ScrapedData instance) => <String, dynamic>{
    'appData': mapper.serializeToMap(instance.appData),
    'runMetadata': mapper.serializeToMap(instance.runMetadata),
  },
);


final _serverstatusMapper = JsonObjectMapper(
  (CustomJsonMapper mapper, Map<String, dynamic> json) => ServerStatus(
    status: mapper.applyFromJsonConverter(ServerConnectionStatus.values.firstWhere(
        (item) => item.toString().split('.')[1].toLowerCase() == json['status']?.toLowerCase(),
        orElse: () => null)),
  ),
  (CustomJsonMapper mapper, ServerStatus instance) => <String, dynamic>{
    'status': mapper.applyFromInstanceConverter(instance.status.toString().split('.')[1]),
  },
);


final _appdataMapper = JsonObjectMapper(
  (CustomJsonMapper mapper, Map<String, dynamic> json) => AppData(
    logoUrl: mapper.applyFromJsonConverter(json['logoUrl']),
    banners: (json['banners'] as List)?.cast<Map<String, dynamic>>()?.map((item) => mapper.deserialize<HeadingBanner>(item))?.toList(),
    broadcastItems: (json['broadcastItems'] as List)?.cast<Map<String, dynamic>>()?.map((item) => mapper.deserialize<BroadcastItem>(item))?.toList(),
    courses: (json['courses'] as List)?.cast<Map<String, dynamic>>()?.map((item) => mapper.deserialize<Course>(item))?.toList(),
    socialMediaItems: (json['socialMediaItems'] as List)?.cast<Map<String, dynamic>>()?.map((item) => mapper.deserialize<SocialMediaItem>(item))?.toList(),
  ),
  (CustomJsonMapper mapper, AppData instance) => <String, dynamic>{
    'logoUrl': mapper.applyFromInstanceConverter(instance.logoUrl),
    'banners': instance.banners?.map((item) => mapper.serializeToMap(item))?.toList(),
    'broadcastItems': instance.broadcastItems?.map((item) => mapper.serializeToMap(item))?.toList(),
    'courses': instance.courses?.map((item) => mapper.serializeToMap(item))?.toList(),
    'socialMediaItems': instance.socialMediaItems?.map((item) => mapper.serializeToMap(item))?.toList(),
  },
);


final _runmetadataMapper = JsonObjectMapper(
  (CustomJsonMapper mapper, Map<String, dynamic> json) => RunMetadata(
    lastUpdate: mapper.applyFromJsonConverter(json['lastUpdate']),
  ),
  (CustomJsonMapper mapper, RunMetadata instance) => <String, dynamic>{
    'lastUpdate': mapper.applyFromInstanceConverter(instance.lastUpdate),
  },
);



final _headingbannerMapper = JsonObjectMapper(
  (CustomJsonMapper mapper, Map<String, dynamic> json) => HeadingBanner(
    imageUrl: mapper.applyFromJsonConverter(json['imageUrl']),
    linkUrl: mapper.applyFromJsonConverter(json['linkUrl']),
  ),
  (CustomJsonMapper mapper, HeadingBanner instance) => <String, dynamic>{
    'imageUrl': mapper.applyFromInstanceConverter(instance.imageUrl),
    'linkUrl': mapper.applyFromInstanceConverter(instance.linkUrl),
  },
);


final _broadcastitemMapper = JsonObjectMapper(
  (CustomJsonMapper mapper, Map<String, dynamic> json) => BroadcastItem(
    type: mapper.applyFromJsonConverter(BroadcastType.values.firstWhere(
        (item) => item.toString().split('.')[1].toLowerCase() == json['type']?.toLowerCase(),
        orElse: () => null)),
    imageUrl: mapper.applyFromJsonConverter(json['imageUrl']),
    linkUrl: mapper.applyFromJsonConverter(json['linkUrl']),
  ),
  (CustomJsonMapper mapper, BroadcastItem instance) => <String, dynamic>{
    'type': mapper.applyFromInstanceConverter(instance.type.toString().split('.')[1]),
    'imageUrl': mapper.applyFromInstanceConverter(instance.imageUrl),
    'linkUrl': mapper.applyFromInstanceConverter(instance.linkUrl),
  },
);


final _courseMapper = JsonObjectMapper(
  (CustomJsonMapper mapper, Map<String, dynamic> json) => Course(
    title: mapper.applyFromJsonConverter(json['title']),
    imageUrl: mapper.applyFromJsonConverter(json['imageUrl']),
    pageRoute: mapper.applyFromJsonConverter(json['pageRoute']),
  ),
  (CustomJsonMapper mapper, Course instance) => <String, dynamic>{
    'title': mapper.applyFromInstanceConverter(instance.title),
    'imageUrl': mapper.applyFromInstanceConverter(instance.imageUrl),
    'pageRoute': mapper.applyFromInstanceConverter(instance.pageRoute),
  },
);


final _socialmediaitemMapper = JsonObjectMapper(
  (CustomJsonMapper mapper, Map<String, dynamic> json) => SocialMediaItem(
    imageUrl: mapper.applyFromJsonConverter(json['imageUrl']),
    linkUrl: mapper.applyFromJsonConverter(json['linkUrl']),
  ),
  (CustomJsonMapper mapper, SocialMediaItem instance) => <String, dynamic>{
    'imageUrl': mapper.applyFromInstanceConverter(instance.imageUrl),
    'linkUrl': mapper.applyFromInstanceConverter(instance.linkUrl),
  },
);


void init() {
  JsonMapper.register(_scrapeddataMapper);
  JsonMapper.register(_serverstatusMapper);
  JsonMapper.register(_appdataMapper);
  JsonMapper.register(_runmetadataMapper);
  JsonMapper.register(_headingbannerMapper);
  JsonMapper.register(_broadcastitemMapper);
  JsonMapper.register(_courseMapper);
  JsonMapper.register(_socialmediaitemMapper); 

  JsonMapper.registerListCast((value) => value?.cast<ScrapedData>()?.toList());
  JsonMapper.registerListCast((value) => value?.cast<ServerStatus>()?.toList());
  JsonMapper.registerListCast((value) => value?.cast<AppData>()?.toList());
  JsonMapper.registerListCast((value) => value?.cast<RunMetadata>()?.toList());
  JsonMapper.registerListCast((value) => value?.cast<ServerConnectionStatus>()?.toList());
  JsonMapper.registerListCast((value) => value?.cast<HeadingBanner>()?.toList());
  JsonMapper.registerListCast((value) => value?.cast<BroadcastItem>()?.toList());
  JsonMapper.registerListCast((value) => value?.cast<Course>()?.toList());
  JsonMapper.registerListCast((value) => value?.cast<SocialMediaItem>()?.toList());
  JsonMapper.registerListCast((value) => value?.cast<BroadcastType>()?.toList());
}
    