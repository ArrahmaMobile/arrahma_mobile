import 'package:flutter/material.dart';

class AsmaUlHusna extends StatefulWidget {
  @override
  AasmUlHusnaState createState() => AasmUlHusnaState();
}

class AasmUlHusnaState extends State<AsmaUlHusna> {
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
            'Asmu ul Hasna',
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
                        'للہ کی معرفت',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: const Text('Allah ki Maarfat'),
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
