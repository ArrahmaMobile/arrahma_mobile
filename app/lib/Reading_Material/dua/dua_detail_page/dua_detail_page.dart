import 'package:flutter/material.dart';

class DuaDetailPage extends StatefulWidget {
  @override
  _DuaDetailPageState createState() => _DuaDetailPageState();
}

class _DuaDetailPageState extends State<DuaDetailPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 1,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.white,
          title: Text(
            'Dua Name',
            style: TextStyle(
                color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        body: TabBarView(
          children: [
            Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    itemCount: 15,
                    itemBuilder: (_, index) => GestureDetector(
                      onTap: () {},
                      child: ListTile(
                        leading: Icon(Icons.branding_watermark),
                        title: const Text('Supplications for travel'),
                        subtitle: Text('گھروالوں کی مسافر کے ليے دعائيں'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text(
                                'أَسۡتَوۡدِعُ اللّٰهَ دِيۡنَكُمۡ وَأَمَانَتَكُمۡ وَخَوَاتِيۡمَ عَمَلِكُمۡ'),
                          ],
                        ),
                        onTap: () {},
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
