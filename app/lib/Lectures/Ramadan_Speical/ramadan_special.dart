import 'package:flutter/material.dart';

//////// SEE ARRAHMA WEBSITE TO SEE WHAT LEFT ON THIS PAGE!!!!!!!

class RamadanSpecial extends StatelessWidget {
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
            'Ramadan Speical',
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
                      leading: const Icon(
                        Icons.branding_watermark,
                        color: Colors.black,
                      ),
                      title: const Text(
                        'ہ رمضان .. تبدیلی کا رمضان',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: const Text('Yeh Ramadan Change ka Ramadan'),
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
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(width: 5),
                          IconButton(
                            icon: const Icon(Icons.volume_up,
                                color: Colors.black),
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
