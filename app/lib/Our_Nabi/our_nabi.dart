import 'package:flutter/material.dart';
import 'model/our_nabi.dart';

class OurNabi extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: const Color(0xff124570),
        centerTitle: true,
        title: Text(
          'Our Nabi',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
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
    const OurNabiItem(
      title: 'Hadith',
      pageRoute: '/hadith',
    ),
    const OurNabiItem(
      title: 'Seerah',
      pageRoute: '/seerah',
    ),
    const OurNabiItem(
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
      childAspectRatio: 1.5,
      children:
          _ourNabi.map((item) => _buildOurNabiItem(context, item)).toList(),
    );
  }

  Widget _buildOurNabiItem(BuildContext context, OurNabiItem item) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, item.pageRoute);
      },
      child: Container(
        color: const Color(0xff124570),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              item.title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
