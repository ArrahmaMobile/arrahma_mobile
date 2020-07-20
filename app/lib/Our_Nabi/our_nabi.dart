import 'package:flutter/material.dart';
import 'model/our_nabi.dart';

class OurNabi extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          'Our Nabi',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: [
            _ourNabiList(context),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  final _ourNabi = [
    OurNabiItem(
      title: 'Hadith',
      pageRoute: '/hadith',
    ),
    OurNabiItem(
      title: 'Seerah',
      pageRoute: '/seerah',
    ),
    OurNabiItem(
      title: 'Raiz us Saliheen',
      pageRoute: '/riza_us_saliheen',
    ),
  ];

  Widget _ourNabiList(BuildContext context) {
    return GridView.count(
      crossAxisSpacing: 8,
      mainAxisSpacing: 8,
      crossAxisCount: 2,
      shrinkWrap: true,
      childAspectRatio: 1,
      children:
          _ourNabi.map((item) => _buildOurNabiItem(context, item)).toList(),
    );
  }

  Widget _buildOurNabiItem(context, OurNabiItem item) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, item.pageRoute);
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            item.title,
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ],
      ),
    );
  }
}
