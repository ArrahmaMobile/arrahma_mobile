import 'package:arrahma_mobile_app/Tajweed/model/tajweed.dart';
import 'package:flutter/material.dart';

class TaleemulTajweedTab extends StatefulWidget {
  @override
  _TaleemulTajweedTabState createState() => _TaleemulTajweedTabState();
}

class _TaleemulTajweedTabState extends State<TaleemulTajweedTab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text(
          'Tajweed',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: _tajweedTab
              .map((item) => _buildTajweedTab(context, item))
              .toList(),
        ),
      ),
    );
  }

  final _tajweedTab = [
    TajweedItem(
      title: 'Introduction',
      pageRoute: '/media_player_screen',
    ),
    TajweedItem(
      title: 'Letter Practice',
      pageRoute: '/letter_practice',
    ),
    TajweedItem(
      title: 'Tajweed Rules',
      pageRoute: '/tajweed_rules',
    ),
    TajweedItem(
      title: 'Weekly Hifz',
      pageRoute: '/weekly_hifz',
    ),
  ];

  Widget _buildTajweedTab(BuildContext context, TajweedItem item) {
    return GestureDetector(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            item.title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
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
        ],
      ),
      onTap: () {
        Navigator.pushNamed(context, item.pageRoute);
      },
    );
  }
}
