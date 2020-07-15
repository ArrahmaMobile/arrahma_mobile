import 'package:flutter/material.dart';

import 'model/tajweed_tab.dart';

class AdvTaleemmulTajweedTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text(
          'Tajweed',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: _advTajweedTab
                .map((item) => _buildAdvTajweedTab(context, item))
                .toList()),
      ),
    );
  }

  final _advTajweedTab = [
    TajweedTabItem(
      title: 'Introduction',
      pageRoute: '/media_player_screen',
    ),
    TajweedTabItem(
      title: 'Letter Practice',
      pageRoute: '/letter_practice',
    ),
  ];

  Widget _buildAdvTajweedTab(BuildContext context, TajweedTabItem item) {
    return GestureDetector(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            item.title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              Icons.keyboard_arrow_right,
              color: Colors.black,
              size: 45,
            ),
          ),
        ],
      ),
      onTap: () {
        Navigator.pushNamed(context, item.pageRoute);
      },
    );
  }
}
