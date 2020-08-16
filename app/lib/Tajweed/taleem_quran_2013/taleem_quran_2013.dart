import 'package:flutter/material.dart';

class TaleemQuran2013 extends StatefulWidget {
  @override
  TaleemQuran2013State createState() => TaleemQuran2013State();
}

class TaleemQuran2013State extends State<TaleemQuran2013> {
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
            'Surah',
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
                        'Surah An-Naba النبإ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: const Text('Tajweedc 1-40'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          const SizedBox(width: 5),
                          IconButton(
                            icon: const Icon(
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
