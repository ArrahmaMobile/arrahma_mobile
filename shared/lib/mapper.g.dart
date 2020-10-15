// GENERATED CODE - DO NOT MODIFY BY HAND
// Generated and consumed by 'simple_json' 

import 'package:simple_json_mapper/simple_json_mapper.dart';
import 'package:arrahma_shared/src/models/scraped_data.dart';
import 'package:arrahma_shared/src/models/status/server_status_check.dart';
import 'package:arrahma_shared/src/app_metadata.dart';
import 'package:arrahma_shared/src/run_metadata.dart';
import 'package:arrahma_shared/src/models/heading_banner.dart';
import 'package:arrahma_shared/src/models/broadcast_item.dart';
import 'package:arrahma_shared/src/models/quran_course/quran_course.dart';
import 'package:arrahma_shared/src/models/social_media_item.dart';
import 'package:arrahma_shared/src/models/quran_course/quran_course_details.dart';
import 'package:arrahma_shared/src/models/quran_course/quran_course_content.dart';
import 'package:arrahma_shared/src/models/quran_course/quran_course_registration.dart';
import 'package:arrahma_shared/src/models/quran_course/quran_course_test.dart';
import 'package:arrahma_shared/src/models/surah.dart';

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
    isDataStale: mapper.applyFromJsonConverter(json['isDataStale']),
  ),
  (CustomJsonMapper mapper, ServerStatus instance) => <String, dynamic>{
    'status': mapper.applyFromInstanceConverter(instance.status?.toString()?.split('.')?.elementAt(1)),
    'isDataStale': mapper.applyFromInstanceConverter(instance.isDataStale),
  },
);


final _appdataMapper = JsonObjectMapper(
  (CustomJsonMapper mapper, Map<String, dynamic> json) => AppData(
    logoUrl: mapper.applyFromJsonConverter(json['logoUrl']),
    banners: (json['banners'] as List)?.cast<Map<String, dynamic>>()?.map((item) => mapper.deserialize<HeadingBanner>(item))?.toList(),
    broadcastItems: (json['broadcastItems'] as List)?.cast<Map<String, dynamic>>()?.map((item) => mapper.deserialize<BroadcastItem>(item))?.toList(),
    courses: (json['courses'] as List)?.cast<Map<String, dynamic>>()?.map((item) => mapper.deserialize<QuranCourse>(item))?.toList(),
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
    updateFrequency: mapper.applyFromJsonConverter(json['updateFrequency']),
  ),
  (CustomJsonMapper mapper, RunMetadata instance) => <String, dynamic>{
    'lastUpdate': mapper.applyFromInstanceConverter(instance.lastUpdate),
    'updateFrequency': mapper.applyFromInstanceConverter(instance.updateFrequency),
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
    'type': mapper.applyFromInstanceConverter(instance.type?.toString()?.split('.')?.elementAt(1)),
    'imageUrl': mapper.applyFromInstanceConverter(instance.imageUrl),
    'linkUrl': mapper.applyFromInstanceConverter(instance.linkUrl),
  },
);


final _qurancourseMapper = JsonObjectMapper(
  (CustomJsonMapper mapper, Map<String, dynamic> json) => QuranCourse(
    title: mapper.applyFromJsonConverter(json['title']),
    imageUrl: mapper.applyFromJsonConverter(json['imageUrl']),
    courseDetails: mapper.deserialize<QuranCourseDetails>(json['courseDetails'] as Map<String, dynamic>),
    lectures: mapper.deserialize<QuranCourseContent>(json['lectures'] as Map<String, dynamic>),
    registration: mapper.deserialize<QuranCourseRegistration>(json['registration'] as Map<String, dynamic>),
    tafseer: mapper.deserialize<QuranCourseContent>(json['tafseer'] as Map<String, dynamic>),
    tajweed: mapper.deserialize<QuranCourseContent>(json['tajweed'] as Map<String, dynamic>),
    tests: (json['tests'] as List)?.cast<Map<String, dynamic>>()?.map((item) => mapper.deserialize<QuranCourseTest>(item))?.toList(),
  ),
  (CustomJsonMapper mapper, QuranCourse instance) => <String, dynamic>{
    'title': mapper.applyFromInstanceConverter(instance.title),
    'imageUrl': mapper.applyFromInstanceConverter(instance.imageUrl),
    'courseDetails': mapper.serializeToMap(instance.courseDetails),
    'lectures': mapper.serializeToMap(instance.lectures),
    'registration': mapper.serializeToMap(instance.registration),
    'tafseer': mapper.serializeToMap(instance.tafseer),
    'tajweed': mapper.serializeToMap(instance.tajweed),
    'tests': instance.tests?.map((item) => mapper.serializeToMap(item))?.toList(),
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



final _qurancoursedetailsMapper = JsonObjectMapper(
  (CustomJsonMapper mapper, Map<String, dynamic> json) => QuranCourseDetails(
    type: mapper.applyFromJsonConverter(QuranCourseDetailsType.values.firstWhere(
        (item) => item.toString().split('.')[1].toLowerCase() == json['type']?.toLowerCase(),
        orElse: () => null)),
    details: mapper.applyFromJsonConverter(json['details']),
  ),
  (CustomJsonMapper mapper, QuranCourseDetails instance) => <String, dynamic>{
    'type': mapper.applyFromInstanceConverter(instance.type?.toString()?.split('.')?.elementAt(1)),
    'details': mapper.applyFromInstanceConverter(instance.details),
  },
);


final _qurancoursecontentMapper = JsonObjectMapper(
  (CustomJsonMapper mapper, Map<String, dynamic> json) => QuranCourseContent(
    title: mapper.applyFromJsonConverter(json['title']),
    surahs: (json['surahs'] as List)?.cast<Map<String, dynamic>>()?.map((item) => mapper.deserialize<Surah>(item))?.toList(),
  ),
  (CustomJsonMapper mapper, QuranCourseContent instance) => <String, dynamic>{
    'title': mapper.applyFromInstanceConverter(instance.title),
    'surahs': instance.surahs?.map((item) => mapper.serializeToMap(item))?.toList(),
  },
);


final _qurancourseregistrationMapper = JsonObjectMapper(
  (CustomJsonMapper mapper, Map<String, dynamic> json) => QuranCourseRegistration(
    courseRegistration: mapper.applyFromJsonConverter(json['courseRegistration']),
  ),
  (CustomJsonMapper mapper, QuranCourseRegistration instance) => <String, dynamic>{
    'courseRegistration': mapper.applyFromInstanceConverter(instance.courseRegistration),
  },
);


final _qurancoursetestMapper = JsonObjectMapper(
  (CustomJsonMapper mapper, Map<String, dynamic> json) => QuranCourseTest(
    title: mapper.applyFromJsonConverter(json['title']),
  ),
  (CustomJsonMapper mapper, QuranCourseTest instance) => <String, dynamic>{
    'title': mapper.applyFromInstanceConverter(instance.title),
  },
);



final _surahMapper = JsonObjectMapper(
  (CustomJsonMapper mapper, Map<String, dynamic> json) => Surah(
    name: mapper.applyFromJsonConverter(json['name']),
    arabicName: mapper.applyFromJsonConverter(json['arabicName']),
    description: mapper.applyFromJsonConverter(json['description']),
    groups: (json['groups'] as List)?.cast<Map<String, dynamic>>()?.map((item) => mapper.deserialize<Group>(item))?.toList(),
    lessons: (json['lessons'] as List)?.cast<Map<String, dynamic>>()?.map((item) => mapper.deserialize<Lesson>(item))?.toList(),
  ),
  (CustomJsonMapper mapper, Surah instance) => <String, dynamic>{
    'name': mapper.applyFromInstanceConverter(instance.name),
    'arabicName': mapper.applyFromInstanceConverter(instance.arabicName),
    'description': mapper.applyFromInstanceConverter(instance.description),
    'groups': instance.groups?.map((item) => mapper.serializeToMap(item))?.toList(),
    'lessons': instance.lessons?.map((item) => mapper.serializeToMap(item))?.toList(),
  },
);


final _groupMapper = JsonObjectMapper(
  (CustomJsonMapper mapper, Map<String, dynamic> json) => Group(
    name: mapper.applyFromJsonConverter(json['name']),
  ),
  (CustomJsonMapper mapper, Group instance) => <String, dynamic>{
    'name': mapper.applyFromInstanceConverter(instance.name),
  },
);


final _lessonMapper = JsonObjectMapper(
  (CustomJsonMapper mapper, Map<String, dynamic> json) => Lesson(
    title: mapper.applyFromJsonConverter(json['title']),
    ayahNum: mapper.applyFromJsonConverter(json['ayahNum']),
    lessonNum: mapper.applyFromJsonConverter(json['lessonNum']),
    uploadDate: mapper.applyFromJsonConverter(json['uploadDate']),
    itemGroups: (json['itemGroups'] as List)?.cast<Map<String, dynamic>>()?.map((item) => mapper.deserialize<GroupItem>(item))?.toList(),
  ),
  (CustomJsonMapper mapper, Lesson instance) => <String, dynamic>{
    'title': mapper.applyFromInstanceConverter(instance.title),
    'ayahNum': mapper.applyFromInstanceConverter(instance.ayahNum),
    'lessonNum': mapper.applyFromInstanceConverter(instance.lessonNum),
    'uploadDate': mapper.applyFromInstanceConverter(instance.uploadDate),
    'itemGroups': instance.itemGroups?.map((item) => mapper.serializeToMap(item))?.toList(),
  },
);


final _groupitemMapper = JsonObjectMapper(
  (CustomJsonMapper mapper, Map<String, dynamic> json) => GroupItem(
    items: (json['items'] as List)?.cast<Map<String, dynamic>>()?.map((item) => mapper.deserialize<Item>(item))?.toList(),
  ),
  (CustomJsonMapper mapper, GroupItem instance) => <String, dynamic>{
    'items': instance.items?.map((item) => mapper.serializeToMap(item))?.toList(),
  },
);


final _itemMapper = JsonObjectMapper(
  (CustomJsonMapper mapper, Map<String, dynamic> json) => Item(
    type: mapper.applyFromJsonConverter(ItemType.values.firstWhere(
        (item) => item.toString().split('.')[1].toLowerCase() == json['type']?.toLowerCase(),
        orElse: () => null)),
    url: mapper.applyFromJsonConverter(json['url']),
    isDirectSource: mapper.applyFromJsonConverter(json['isDirectSource']),
  ),
  (CustomJsonMapper mapper, Item instance) => <String, dynamic>{
    'type': mapper.applyFromInstanceConverter(instance.type?.toString()?.split('.')?.elementAt(1)),
    'url': mapper.applyFromInstanceConverter(instance.url),
    'isDirectSource': mapper.applyFromInstanceConverter(instance.isDirectSource),
  },
);


void init() {
  JsonMapper.register(_scrapeddataMapper);
  JsonMapper.register(_serverstatusMapper);
  JsonMapper.register(_appdataMapper);
  JsonMapper.register(_runmetadataMapper);
  JsonMapper.register(_headingbannerMapper);
  JsonMapper.register(_broadcastitemMapper);
  JsonMapper.register(_qurancourseMapper);
  JsonMapper.register(_socialmediaitemMapper);
  JsonMapper.register(_qurancoursedetailsMapper);
  JsonMapper.register(_qurancoursecontentMapper);
  JsonMapper.register(_qurancourseregistrationMapper);
  JsonMapper.register(_qurancoursetestMapper);
  JsonMapper.register(_surahMapper);
  JsonMapper.register(_groupMapper);
  JsonMapper.register(_lessonMapper);
  JsonMapper.register(_groupitemMapper);
  JsonMapper.register(_itemMapper); 

  

  JsonMapper.registerListCast((value) => value?.cast<ScrapedData>()?.toList());
  JsonMapper.registerListCast((value) => value?.cast<ServerStatus>()?.toList());
  JsonMapper.registerListCast((value) => value?.cast<AppData>()?.toList());
  JsonMapper.registerListCast((value) => value?.cast<RunMetadata>()?.toList());
  JsonMapper.registerListCast((value) => value?.cast<ServerConnectionStatus>()?.toList());
  JsonMapper.registerListCast((value) => value?.cast<HeadingBanner>()?.toList());
  JsonMapper.registerListCast((value) => value?.cast<BroadcastItem>()?.toList());
  JsonMapper.registerListCast((value) => value?.cast<QuranCourse>()?.toList());
  JsonMapper.registerListCast((value) => value?.cast<SocialMediaItem>()?.toList());
  JsonMapper.registerListCast((value) => value?.cast<BroadcastType>()?.toList());
  JsonMapper.registerListCast((value) => value?.cast<QuranCourseDetails>()?.toList());
  JsonMapper.registerListCast((value) => value?.cast<QuranCourseContent>()?.toList());
  JsonMapper.registerListCast((value) => value?.cast<QuranCourseRegistration>()?.toList());
  JsonMapper.registerListCast((value) => value?.cast<QuranCourseTest>()?.toList());
  JsonMapper.registerListCast((value) => value?.cast<QuranCourseDetailsType>()?.toList());
  JsonMapper.registerListCast((value) => value?.cast<Surah>()?.toList());
  JsonMapper.registerListCast((value) => value?.cast<Group>()?.toList());
  JsonMapper.registerListCast((value) => value?.cast<Lesson>()?.toList());
  JsonMapper.registerListCast((value) => value?.cast<GroupItem>()?.toList());
  JsonMapper.registerListCast((value) => value?.cast<Item>()?.toList());
  JsonMapper.registerListCast((value) => value?.cast<ItemType>()?.toList());
}
    