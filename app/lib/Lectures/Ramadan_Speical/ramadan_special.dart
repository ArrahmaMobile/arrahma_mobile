import 'package:flutter/material.dart';

//////// SEE ARRAHMA WEBSITE TO SEE WHAT LEFT ON THIS PAGE!!!!!!!

class RamadanSpecial extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 1,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          title: Text(
            'Ramadan Speical',
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
                        'ہ رمضان .. تبدیلی کا رمضان',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text('Yeh Ramadan Change ka Ramadan'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                  context, '/media_player_screen');
                            },
                            child: Image.asset(
                              'assets/images/multi_page_icons/arrow_down.png',
                              width: 15,
                            ),
                          ),
                          SizedBox(width: 5),
                          IconButton(
                            icon: Icon(Icons.volume_up, color: Colors.black),
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
