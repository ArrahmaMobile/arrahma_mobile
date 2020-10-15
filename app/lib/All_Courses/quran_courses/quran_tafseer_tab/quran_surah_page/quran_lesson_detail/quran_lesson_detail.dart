import 'package:arrahma_mobile_app/Media_Player/media_player.dart';
import 'package:arrahma_mobile_app/features/media_player/models/media_data.dart';
import 'package:arrahma_shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_framework/flutter_framework.dart';

class QuranLessonAudioPage extends StatefulWidget {
  const QuranLessonAudioPage(
      {Key key, @required this.surah, @required this.lesson})
      : super(key: key);
  final Surah surah;
  final Lesson lesson;

  @override
  _QuranLessonAudioPageState createState() => _QuranLessonAudioPageState();
}

class _QuranLessonAudioPageState extends State<QuranLessonAudioPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              const SizedBox(height: 30),
              Container(
                alignment: Alignment.topLeft,
                margin: const EdgeInsets.only(left: 10),
                child: IconButton(
                  iconSize: 25,
                  icon: const Icon(Icons.arrow_back),
                  color: Colors.black,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    child: ClipRRect(
                      child: Image.asset(
                        'assets/images/media_player/media_player_icon.PNG',
                        width: MediaQuery.of(context).size.width * 0.4,
                        height: MediaQuery.of(context).size.width * 0.4,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Column(
                    children: <Widget>[
                      Text(
                        widget.surah.name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Column(
                    children: <Widget>[
                      Text(
                        widget.lesson.title,
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              ...widget.surah.groups
                  .asMap()
                  .entries
                  .map((itemEntry) => _buildQuranLessonDetail(
                        context,
                        itemEntry.value,
                        widget.lesson.itemGroups[itemEntry.key].items,
                      ))
                  .toList()
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuranLessonDetail(
      BuildContext context, Group group, List<Item> items) {
    if (items.isEmpty) return Container();
    return GestureDetector(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.only(left: 20),
              ),
              const SizedBox(width: 15),
              Text(
                group.name,
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Row(
              children: items
                  .asMap()
                  .entries
                  .map(
                    (entry) => IconButton(
                      icon: Icon(
                        GroupTypeIconMap[entry.value.type],
                        color: Colors.black,
                      ),
                      color: Colors.black,
                      onPressed: () {
                        if (entry.value.type == ItemType.Audio) {
                          final mediaItems = items
                              .asMap()
                              .entries
                              .map(
                                (urlEntry) => MediaData(
                                  title:
                                      '${widget.lesson.title} - ${widget.lesson.title.startsWith(group.name) ? '' : '${group.name} '}Pt. ${urlEntry.key + 1}',
                                  group: widget.surah.name,
                                  sourceUrl: urlEntry.value.url,
                                ),
                              )
                              .toList();
                          Navigator.push<dynamic>(
                            context,
                            MaterialPageRoute<dynamic>(
                              builder: (_) => MediaPlayerScreen(
                                mediaItems: mediaItems,
                                initialAudioIndex: entry.key,
                              ),
                            ),
                          );
                          return;
                        }
                        Launch.url(entry.value.url);
                      },
                    ),
                  )
                  .toList())
        ],
      ),
      onTap: () {},
    );
  }

  static const GroupTypeIconMap = <ItemType, IconData>{
    ItemType.Audio: Icons.volume_up,
    ItemType.Pdf: Icons.notes,
    ItemType.Image: Icons.image,
    ItemType.Video: Icons.ondemand_video,
    ItemType.File: Icons.file_download,
    ItemType.Website: Icons.web,
  };
}
