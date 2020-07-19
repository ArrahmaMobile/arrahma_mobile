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
          backgroundColor: Colors.white,
          centerTitle: true,
          title: Text(
            'Lectures on Namaz',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
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
                          SizedBox(width: 5),
                          IconButton(
                            icon: Icon(
                              Icons.volume_up,
                              color: Colors.black,
                            ),
                            onPressed: () {},
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
