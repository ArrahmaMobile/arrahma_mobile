import 'package:arrahma_mobile_app/Media_Player/media_player.dart';
import 'package:arrahma_mobile_app/features/media_player/models/media_data.dart';
import 'package:arrahma_shared/shared.dart';
import 'package:flutter/material.dart';

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
              ...widget.surah.groupNames
                  .asMap()
                  .entries
                  .map((itemEntry) => _buildQuranLessonDetail(
                        context,
                        itemEntry.value,
                        widget.surah.groupNames[itemEntry.key],
                        widget.lesson.itemGroups[itemEntry.key].items,
                      ))
                  .toList()
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuranLessonDetail(BuildContext context, String title,
      String groupName, List<String> groupUrls) {
    if (groupUrls.isEmpty) return Container();
    final mediaItems = groupUrls
        .asMap()
        .entries
        .map(
          (urlEntry) => MediaData(
            title:
                '${widget.lesson.title} - ${widget.lesson.title.startsWith(groupName) ? '' : '$groupName '}Pt. ${urlEntry.key + 1}',
            group: widget.surah.name,
            sourceUrl: urlEntry.value,
          ),
        )
        .toList();
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
                title,
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Row(
              children: groupUrls
                  .asMap()
                  .entries
                  .map(
                    (entry) => IconButton(
                      icon: const Icon(
                        Icons.volume_up,
                        color: Colors.black,
                      ),
                      color: Colors.black,
                      onPressed: () {
                        Navigator.push<dynamic>(
                          context,
                          MaterialPageRoute<dynamic>(
                            builder: (_) => MediaPlayerScreen(
                              mediaItems: mediaItems,
                              initialAudioIndex: entry.key,
                            ),
                          ),
                        );
                      },
                    ),
                  )
                  .toList())
        ],
      ),
      onTap: () {},
    );
  }
}
