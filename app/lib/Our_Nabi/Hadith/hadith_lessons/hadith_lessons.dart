import 'package:flutter/material.dart';

class HadithLessons extends StatefulWidget {
  @override
  _HadithLessonsState createState() => _HadithLessonsState();
}

class _HadithLessonsState extends State<HadithLessons> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 1,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          title: Text(
            'Hadith Review',
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: TabBarView(
          children: [
            Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 10),
                ),
                Expanded(
                  child: ListView.separated(
                    itemCount: 30,
                    itemBuilder: (_, index) => GestureDetector(
                      child: ListTile(
                        title: const Text('Usool-e-Hadith '),
                        subtitle: Text('اصول حدیث'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Image.asset(
                              'assets/images/multi_page_icons/arrow_down.png',
                              width: 15,
                            ),
                          ],
                        ),
                      ),
                      onTap: () {
                        Navigator.pushNamed(context, '/hadith_lesson_details');
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
