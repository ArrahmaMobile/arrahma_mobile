import 'package:flutter/material.dart';

class TafseerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TabBarView(
      children: [
        Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 10),
              child: const Text(
                "Continue to last Juz'",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
            Expanded(
              child: ListView.separated(
                itemCount: 5,
                itemBuilder: (_, index) => ListTile(
                  leading: Icon(Icons.branding_watermark),
                  title: const Text('Lesson 1: Ayah 1-3'),
                  subtitle: const Text('The Opening (7)'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.star_border),
                        onPressed: () {},
                      ),
                    ],
                  ),
                  onTap: () {},
                ),
                separatorBuilder: (_, __) => const Divider(thickness: 2),
              ),
            ),
          ],
        ),
        Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 10),
              child: const Text(
                "Continue to last Surah'",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
            Expanded(
              child: ListView.separated(
                itemCount: 5,
                itemBuilder: (_, index) => ListTile(
                  leading: Icon(Icons.branding_watermark),
                  title: const Text('Surah Al-Fatiha  الفاتحۃ'),
                  subtitle: const Text('Lesson 1: Ayah 1-3'),
                  trailing: Icon(Icons.star_border),
                  onTap: () {},
                ),
                separatorBuilder: (_, __) => const Divider(thickness: 2),
              ),
            ),
          ],
        )
      ],
    );
  }
}
