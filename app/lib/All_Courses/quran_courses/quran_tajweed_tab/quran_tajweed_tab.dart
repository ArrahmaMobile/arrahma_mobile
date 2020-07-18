import 'package:flutter/material.dart';
import 'model/quran_course_tajweed.dart';

class QuranTajweedTab extends StatelessWidget {
  QuranTajweedTab({
    Key key,
    this.title,
    this.items,
  }) : super(key: key);
  final String title;
  final List<QuranCourseTajweed> items;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: items
                .map((item) => _buildAdvTajweedTab(context, item))
                .toList()),
      ),
    );
  }

  Widget _buildAdvTajweedTab(BuildContext context, QuranCourseTajweed item) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, item.pageRoute, arguments: item.data);
      },
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
    );
  }
}
