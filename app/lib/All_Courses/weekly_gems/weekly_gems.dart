import 'package:arrahma_mobile_app/All_Courses/assorted_lectures/assorted_lecture.dart';
import 'package:arrahma_mobile_app/All_Courses/assorted_lectures/assorted_lecture_page.dart';
import 'package:arrahma_mobile_app/All_Courses/assorted_lectures/model/assorted_lectures.dart';
import 'package:flutter/material.dart';

class WeeklyGemsCourse extends StatefulWidget {
  @override
  _WeeklyGemsCourseState createState() => _WeeklyGemsCourseState();
}

class _WeeklyGemsCourseState extends State<WeeklyGemsCourse> {
  @override
  Widget build(BuildContext context) {
    return AssortedLecturePage(
      item: AssortedLectureCategoryItem(
        title: 'Weekly Gems',
        lectures: [
          AssortedLecture(
            title: 'Ek Naik aurat ki anokhi nazar',
            subtitle: 'سورہٴ ال عمران ٣٥  ایک نیک عورت کی انوکھی نظر',
            audioLength: '12:14',
          )
        ],
      ),
    );
    // return DefaultTabController(
    //   length: 1,
    //   child: Scaffold(
    //     appBar: AppBar(
    //       backgroundColor: Colors.white,
    //       centerTitle: true,
    //       title: Text(
    //         'Quran ki kirnein',
    //         style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
    //       ),
    //     ),
    //     body: TabBarView(
    //       children: [
    //         Column(
    //           children: [
    //             Padding(
    //               padding: EdgeInsets.only(top: 10),
    //             ),
    //             Expanded(
    //               child: ListView.separated(
    //                 itemCount: 10,
    //                 itemBuilder: (_, index) => ListTile(
    //                   leading: Icon(
    //                     Icons.branding_watermark,
    //                     color: Colors.black,
    //                   ),
    //                   title: const Text('Ek Naik aurat ki anokhi nazar',
    //                       style: TextStyle(
    //                           color: Colors.black,
    //                           fontWeight: FontWeight.bold)),
    //                   subtitle: const Text(
    //                     'سورہٴ ال عمران ٣٥  ایک نیک عورت کی انوکھی نظر',
    //                     style: TextStyle(
    //                         color: Colors.lightBlue,
    //                         fontWeight: FontWeight.bold),
    //                   ),
    //                   trailing: Row(
    //                     mainAxisSize: MainAxisSize.min,
    //                     children: <Widget>[
    //                       GestureDetector(
    //                         onTap: () {
    //                           Navigator.pushNamed(
    //                               context, '/media_player_screen');
    //                         },
    //                         child: Icon(
    //                           Icons.volume_up,
    //                           color: Colors.lightBlue,
    //                         ),
    //                       ),
    //                       SizedBox(width: 2),
    //                       Text(
    //                         '12:14',
    //                         style: TextStyle(
    //                             color: Colors.black,
    //                             fontWeight: FontWeight.bold),
    //                       ),
    //                     ],
    //                   ),
    //                 ),
    //                 separatorBuilder: (_, __) => const Divider(thickness: 2),
    //               ),
    //             ),
    //           ],
    //         ),
    //       ],
    //     ),
    //   ),
    // );
  }
}
