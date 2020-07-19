import 'package:flutter/material.dart';

class MedanMehsharMeMeriahani extends StatefulWidget {
  @override
  _MedanMehsharMeMeriahaniState createState() =>
      _MedanMehsharMeMeriahaniState();
}

class _MedanMehsharMeMeriahaniState extends State<MedanMehsharMeMeriahani> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 1,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          title: Text(
            'Medan Mehshar Me Meriahani',
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
                        'Episode 1',
                        style: TextStyle(fontWeight: FontWeight.bold),
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
