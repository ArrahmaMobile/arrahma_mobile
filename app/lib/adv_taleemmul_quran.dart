import 'package:flutter/material.dart';

class AdvTaleemmulQuran extends StatefulWidget {
  @override
  _AdvTaleemmulQuranState createState() => _AdvTaleemmulQuranState();
}

class _AdvTaleemmulQuranState extends State<AdvTaleemmulQuran> {
  int _currentIndex = 2;
  int selectSurah;
  int selectedJuz;

  Widget _buildHeadingTitle() => Container(
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: Colors.black, width: 3),
            bottom: BorderSide(color: Colors.black, width: 3),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Center(
            child: Text(
              'Tafseer',
              style: TextStyle(
                  color: Color(0xff808080),
                  fontWeight: FontWeight.bold,
                  fontSize: 50.0),
            ),
          ),
        ),
      );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Adv Taleemmul Quran',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Column(
        children: <Widget>[
          _buildHeadingTitle(),
          Padding(
            padding: EdgeInsets.only(left: 20),
            child: Align(
              alignment: Alignment.centerLeft,
              child: DropdownButton<int>(
                value: selectedJuz,
                onChanged: (val) => setState(() {
                  selectedJuz = val;
                }),
                items: juzs
                    .asMap()
                    .entries
                    .map((juzEntry) => DropdownMenuItem(
                        value: juzEntry.key + 1, child: Text(juzEntry.value)))
                    .toList(),
                hint: Text('Select by Juz'),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 20),
            child: Align(
              alignment: Alignment.centerLeft,
              child: DropdownButton<int>(
                value: selectSurah,
                onChanged: (val) => setState(() {
                  selectSurah = val;
                }),
                items: surah
                    .asMap()
                    .entries
                    .map(
                      (surahEntry) => DropdownMenuItem(
                        value: surahEntry.key + 1,
                        child: Text(surahEntry.value),
                      ),
                    )
                    .toList(),
                hint: Text('Select by Surah'),
              ),
            ),
          ),
          Table(
            columnWidths: {
              0: FlexColumnWidth(2),
              1: FlexColumnWidth(1),
              2: FlexColumnWidth(1),
              3: FlexColumnWidth(1),
              4: FlexColumnWidth(1),
            },
            children: [
              TableRow(
                children: [
                  Text(''),
                  Text(
                    'Root Word',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Translation',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Tafseer',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Ref. Material',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
          Container(
            color: Colors.grey,
            height: 22,
            child: Table(
              children: [
                TableRow(
                  children: [
                    Text(
                      "Juz' 1",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Table(
            columnWidths: {
              0: FlexColumnWidth(2),
              1: FlexColumnWidth(1),
              2: FlexColumnWidth(1),
              3: FlexColumnWidth(1),
              4: FlexColumnWidth(1),
            },
            children: [
              TableRow(
                children: [
                  Text(
                    'Al-Fatiha:  الفاتحۃ',
                    style: TextStyle(fontSize: 15),
                  ),
                  Icon(Icons.arrow_downward),
                  Icon(Icons.arrow_downward),
                  Icon(Icons.arrow_downward),
                  Icon(Icons.arrow_downward),
                ],
              ),
            ],
          ),
          Container(
            color: Colors.grey,
            height: 22,
            child: Table(
              children: [
                TableRow(
                  children: [
                    Text(
                      "Juz' 2",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.library_books),
            title: Text('Details'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            title: Text('Registration'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Tafseer'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Tajweed'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Tests'),
          ),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}

List<String> surah = [
  "Surah Al-Fatiha:  الفاتحۃ",
  "Surah Al-Baqarah: البقرۃ",
  "Surah Al-Imran  :  آل عمران ",
  "Surah An-Nisa:  النسآء  ",
];

List<String> juzs = [
  "Juz 1:  الم",
  "Juz 2:  سیقول",
  "Juz 3:  تلک الرسل",
  "Juz 4:  لن تنا لوا",
];
