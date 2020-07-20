import 'package:flutter/material.dart';

class Juz30Hifz extends StatefulWidget {
  @override
  _Juz30HifzState createState() => _Juz30HifzState();
}

class _Juz30HifzState extends State<Juz30Hifz> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 1,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          title: Text(
            'Juz 30 عمّ',
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
                    itemBuilder: (_, index) => ListTile(
                      title: const Text('An-Naba'),
                      subtitle: Text('The Great News'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          GestureDetector(
                            child: Image.asset(
                              'assets/images/multi_page_icons/arrow_down.png',
                              width: 15,
                            ),
                          ),
                          GestureDetector(
                            child: IconButton(
                              icon: Icon(Icons.volume_up),
                              onPressed: () {},
                            ),
                          )
                        ],
                      ),
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
