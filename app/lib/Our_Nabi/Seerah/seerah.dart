import 'package:arrahma_mobile_app/our_nabi/seerah/model/seerah.dart';
import 'package:flutter/material.dart';

class Seerah extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color(0xff124570),
        centerTitle: true,
        title: const Text(
          'Seerah',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            _seerahList(context),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _seerahList(BuildContext context) {
    return GridView.count(
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        crossAxisCount: 2,
        shrinkWrap: true,
        childAspectRatio: 1.5,
        children:
            _seerah.map((seerah) => _buildSeerah(context, seerah)).toList());
  }

  final _seerah = [
    const SeerahItems(
      title: 'Seerah Lessons',
      pageRoute: '/lecture_tab',
    )
  ];

  Widget _buildSeerah(BuildContext context, SeerahItems seerah) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, seerah.pageRoute);
      },
      child: Container(
        color: const Color(0xff124570),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              seerah.title,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
