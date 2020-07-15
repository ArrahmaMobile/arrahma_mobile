import 'package:flutter/material.dart';

import 'model/speical_series.dart';

class SpecialSeries extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          'Speical Series',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(10.0),
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
    SpecialSeriesItem(
      title: 'Gumnaam Ki Diary',
      pageRoute: '/gumnaam_ki_diary',
    ),
    SpecialSeriesItem(
      title: 'Medan-Mehshar Me Meri Kahani',
      pageRoute: '/medan_mehshar_me_meriahani',
    ),
    SpecialSeriesItem(
      title: 'Meri Aakhari',
      pageRoute: '/meri_aakhri',
    ),
    SpecialSeriesItem(
      title: 'Asma ul Husna',
      pageRoute: '/asma_ul_husna',
    ),
  ];

  Widget _buildSpecialSeries(BuildContext context, SpecialSeriesItem item) {
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

  Widget _specialSeriesList(BuildContext context) {
    return GridView.count(
      crossAxisSpacing: 8,
      mainAxisSpacing: 8,
      crossAxisCount: 2,
      shrinkWrap: true,
      childAspectRatio: 1,
      children: _speicalSeries
          .map((item) => _buildSpecialSeries(context, item))
          .toList(),
    );
  }
}
