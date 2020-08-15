import 'package:flutter/material.dart';

class Dua extends StatefulWidget {
  @override
  _DuaState createState() => _DuaState();
}

class _DuaState extends State<Dua> {
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
            'Reading Material',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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
                    itemCount: 4,
                    itemBuilder: (_, index) => GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/dua_detail_page');
                      },
                      child: ListTile(
                        title: const Text('Supplications for Traveling'),
                        subtitle: const Text('سفر کی دعائيں'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Image.asset(
                              'assets/images/multi_page_icons/arrow_down.png',
                              width: 15,
                              color: Colors.black,
                            )
                          ],
                        ),
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
