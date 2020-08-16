import 'package:flutter/material.dart';

class LecturesOnNamaz extends StatefulWidget {
  @override
  _LecturesOnNamazState createState() => _LecturesOnNamazState();
}

class _LecturesOnNamazState extends State<LecturesOnNamaz> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 1,
      child: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: const Color(0xff124570),
          centerTitle: true,
          title: const Text(
            'Lectures on Namaz',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        body: TabBarView(
          children: [
            Column(
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 10),
                ),
                Expanded(
                  child: ListView.separated(
                    itemCount: 10,
                    itemBuilder: (_, index) => ListTile(
                      title: const Text(
                        'Namaz Ki Farziat, Fazilat Aur Ahmiyat Part 1',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          const SizedBox(width: 5),
                          IconButton(
                            icon: const Icon(
                              Icons.volume_up,
                              color: Colors.black,
                            ),
                            onPressed: () {
                              Navigator.pushNamed(
                                  context, '/media_player_screen');
                            },
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