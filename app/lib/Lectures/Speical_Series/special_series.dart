import 'package:flutter/material.dart';

import 'model/speical_series.dart';

class SpecialSeries extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: const Color(0xff124570),
        centerTitle: true,
        title: Text(
          'Speical Series',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            _specialSeriesList(context),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  final _speicalSeries = [
    const SpecialSeriesItem(
      title: 'Gumnaam Ki Diary',
      pageRoute: '/gumnaam_ki_diary',
    ),
    const SpecialSeriesItem(
      title: 'Medan-Mehshar Me Meri Kahani',
      pageRoute: '/medan_mehshar_me_meriahani',
    ),
    const SpecialSeriesItem(
      title: 'Meri Aakhari',
      pageRoute: '/meri_aakhri',
    ),
    const SpecialSeriesItem(
      title: 'Asma ul Husna',
      pageRoute: '/asma_ul_husna',
    ),
  ];

  Widget _buildSpecialSeries(BuildContext context, SpecialSeriesItem item) {
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
                  fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }

  Widget _specialSeriesList(BuildContext context) {
    return GridView.count(
      crossAxisSpacing: 8,
      mainAxisSpacing: 8,
      crossAxisCount: 2,
      shrinkWrap: true,
      childAspectRatio: 1.2,
      children: _speicalSeries
          .map((item) => _buildSpecialSeries(context, item))
          .toList(),
    );
  }
}
