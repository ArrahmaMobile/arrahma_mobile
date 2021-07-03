import 'package:arrahma_mobile_app/core/utils.dart';
import 'package:arrahma_shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_framework/flutter_framework.dart';
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
  void initState() {
    super.initState();
    if (widget.lesson.itemGroups.length == 1 &&
        widget.lesson.itemGroups.first.items.length == 1)
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.maybePop(context);
        onTap(
          context,
          widget.surah.groups.first,
          MapEntry(0, widget.lesson.itemGroups.first.items.first),
          widget.lesson.itemGroups.first.items,
        );
      });
  }

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
              if (widget.surah.name != null)
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Text(
                    widget.surah.name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              if (widget.lesson.title != null)
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Text(
                    widget.lesson.title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
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
                    itemEntry.key < widget.lesson.itemGroups.length
                        ? widget.lesson.itemGroups[itemEntry.key].items
                        : [],
                  ))
              .toList()
        ],
      ),
    );
  }

  String _getTitle(String groupName, int index, bool hasMore) {
    return '${widget.lesson.title != null ? '${widget.lesson.title} - ' : ''}${widget.lesson?.title?.startsWith(groupName) ?? false ? '' : '$groupName '}${hasMore ? 'Pt. ${index + 1}' : ''}';
  }

  Widget _buildQuranLessonDetail(
      BuildContext context, Group group, List<Item> items) {
    if (items.isEmpty) return Container();
    return items.length == 1 && items.first.type == ItemType.Title
        ? Text(
            items.first.data,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          )
        : GestureDetector(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Text(
                    group.name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
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
                            ),
                            onPressed: () =>
                                onTap(context, group, entry, items),
                          ),
                        )
                        .toList())
              ],
            ),
            onTap: () {},
          );
  }

  void onTap(BuildContext context, Group group, MapEntry<int, Item> entry,
      List<Item> items) {
    if (entry.value.type == ItemType.Audio) {
      Utils.openAudio(
          context,
          Utils.itemToMediaItem(
              items
                  .asMap()
                  .entries
                  .map(
                    (entry) => TitledItem.fromItem(
                      _getTitle(group.name, entry.key, items.length > 1),
                      entry.value,
                    ),
                  )
                  .toList(),
              widget.surah.name),
          entry.key);
      return;
    }
    Utils.openUrl(
        context,
        TitledItem.fromItem(
          _getTitle(group.name, entry.key, items.length > 1),
          entry.value,
        ));
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
