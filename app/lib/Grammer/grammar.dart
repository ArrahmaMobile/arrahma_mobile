import 'package:flutter/material.dart';
import 'models/grammer.dart';

class Grammer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: Text(
          'Grammer',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: [
            _grammarList(context),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  final _grammer = [
    GrammerItem(
      title: 'Basic Grammar',
      icon: Icons.access_alarm,
      pageRoute: '',
    ),
    GrammerItem(
      title: 'Arabic',
      icon: Icons.access_alarm,
    )
  ];

  Widget _grammarList(BuildContext context) {
    return GridView.count(
      crossAxisSpacing: 8,
      mainAxisSpacing: 8,
      crossAxisCount: 2,
      shrinkWrap: true,
      childAspectRatio: 1.9,
      children: _grammer
          .map((course) => _buildGrammerItem(course, course.pageRoute))
          .toList(),
    );
  }

  Widget _buildGrammerItem(item, pageRoute) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(item, item.pageRoute);
      },
      child: Container(
        color: Color(0xffdedbdb),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              item.title,
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
            ),
            Icon(
              item.icon,
              size: 50,
            ),
          ],
        ),
      ),
    );
  }
}
