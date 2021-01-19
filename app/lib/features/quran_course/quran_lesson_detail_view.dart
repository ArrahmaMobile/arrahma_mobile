import 'package:arrahma_mobile_app/core/utils.dart';
import 'package:arrahma_shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class QuranLessonDetailView extends StatefulWidget {
  const QuranLessonDetailView(
      {Key key, @required this.surah, @required this.lesson})
      : super(key: key);
  final Surah surah;
  final Lesson lesson;

  @override
  _QuranLessonDetailViewState createState() => _QuranLessonDetailViewState();
}

class _QuranLessonDetailViewState extends State<QuranLessonDetailView> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      child: Column(
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                child: ClipRRect(
                  child: Image.asset(
                    'assets/images/logo.png',
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
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Column(
                children: <Widget>[
                  Text(
                    widget.lesson.title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
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
    );
  }

  String _getTitle(String groupName, int index) {
    return '${widget.lesson.title} - ${widget.lesson.title.startsWith(groupName) ? '' : '$groupName '}Pt. ${index + 1}';
  }

  Widget _buildQuranLessonDetail(
      BuildContext context, Group group, List<Item> items) {
    if (items.isEmpty) return Container();
    return GestureDetector(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Text(
              group.name,
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Row(
              children: items
                  .asMap()
                  .entries
                  .map(
                    (entry) => IconButton(
                      icon: FaIcon(
                        GroupTypeIconMap[entry.value.type],
                        color: Colors.black,
                      ),
                      color: Colors.black,
                      onPressed: () {
                        if (entry.value.type == ItemType.Audio) {
                          Utils.openAudio(
                              context,
                              Utils.itemToMediaItem(
                                  items
                                      .asMap()
                                      .entries
                                      .map(
                                        (entry) => TitledItem(
                                          title:
                                              _getTitle(group.name, entry.key),
                                          type: entry.value.type,
                                          data: entry.value.data,
                                          isDirectSource:
                                              entry.value.isDirectSource,
                                        ),
                                      )
                                      .toList(),
                                  widget.surah.name),
                              entry.key);
                          return;
                        }
                        Utils.openUrl(
                            context,
                            TitledItem(
                              title: _getTitle(group.name, entry.key),
                              data: entry.value.data,
                              isDirectSource: entry.value.isDirectSource,
                              type: entry.value.type,
                            ));
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
    ItemType.Audio: FontAwesomeIcons.solidPlayCircle,
    ItemType.Pdf: FontAwesomeIcons.solidFilePdf,
    ItemType.Image: FontAwesomeIcons.solidImage,
    ItemType.Video: FontAwesomeIcons.solidFileVideo,
    ItemType.File: FontAwesomeIcons.solidFile,
    ItemType.WebPage: Icons.web,
  };
}
