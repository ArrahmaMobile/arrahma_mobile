import 'package:flutter/material.dart';

class LectureTab extends StatefulWidget {
  @override
  _LectureTabState createState() => _LectureTabState();
}

class _LectureTabState extends State<LectureTab> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 1,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Tajalliyate Nabawi PED',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: const Color(0xff124570),
        ),
        body: TabBarView(
          children: [
            Column(
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 15),
                ),
                Expanded(
                  child: ListView.separated(
                    itemCount: 5,
                    itemBuilder: (_, index) => ListTile(
                      title: const Text(
                          'Family, upbringing and situation before Prophecy - part 1'),
                      subtitle: const Text(
                          'خاندان، نشونما اور نبوت سے پہلے کے حالات- حصّہ اول'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                      ),
                      onTap: () {
                        Navigator.pushNamed(context, '/seerah_detail');
                      },
                    ),
                    separatorBuilder: (_, __) => const Divider(thickness: 2),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
