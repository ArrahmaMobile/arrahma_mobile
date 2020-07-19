import 'package:flutter/material.dart';

class Akhirah extends StatefulWidget {
  @override
  _AkhirahState createState() => _AkhirahState();
}

class _AkhirahState extends State<Akhirah> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 1,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          title: Text(
            'Akhirah',
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
                      leading: Icon(
                        Icons.branding_watermark,
                        color: Colors.black,
                      ),
                      title: const Text(
                        'Kamyab Shadi Ke Sunehre Asool',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: const Text(
                        'کامیاب شادی کے سنہرے اصول',
                        style: TextStyle(
                            color: Colors.lightBlue,
                            fontWeight: FontWeight.bold),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                  context, '/media_player_screen');
                            },
                            child: Icon(
                              Icons.volume_up,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(width: 2),
                          Text(
                            '12:14',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
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
