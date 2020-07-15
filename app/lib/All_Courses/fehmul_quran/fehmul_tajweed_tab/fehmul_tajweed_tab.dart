import 'package:arrahma_mobile_app/All_Courses/fehmul_quran/fehmul_tajweed_tab/model/fehmul_tajweed_tab.dart';
import 'package:flutter/material.dart';

class FemulTajweedTab extends StatefulWidget {
  @override
  _FemulTajweedTabState createState() => _FemulTajweedTabState();
}

class _FemulTajweedTabState extends State<FemulTajweedTab> {
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
            children: _fehmulTajweedTab
                .map((item) => _buildFehmulTajweedTab(context, item))
                .toList()),
      ),
    );
  }

  final _fehmulTajweedTab = [
    FehmulTajweedTab(
      title: 'Introduction',
      pageRoute: '/media_player_screen',
    ),
    FehmulTajweedTab(
      title: 'Letter Practice',
      pageRoute: '/letter_practice',
    ),
    FehmulTajweedTab(
      title: 'Tajweed Rules',
      pageRoute: '/tajweed_rules',
    )
  ];

  Widget _buildFehmulTajweedTab(BuildContext context, FehmulTajweedTab item) {
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
