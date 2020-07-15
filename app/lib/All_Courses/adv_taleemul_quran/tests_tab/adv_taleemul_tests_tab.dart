import 'package:flutter/material.dart';

class AdvTaleemmulTestsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          'Tests & Assignment',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ConstrainedBox(
            constraints: BoxConstraints(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'IMPORTANT INSTRUCTIONS:',
                  style:
                      new TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                Text(
                  '1. Please DO NOT DISCUSS the test at all, with anyone whosoever, in the class until she has already attempted it. \n'
                  '2. Once you open the test, you are not allowed to open any Quran or notes and are required to complete the test in one sitting \n'
                  '3. Last but not least, REMEMBER Allah (swt) is watching you. \n'
                  '4. Passing marks for Juz test is 16. If you score less than that you have to re-attempt the test. \n',
                ),
                SizedBox(height: 10),
                Text(
                  "DIRECTIONS",
                  style:
                      new TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                Text(
                    '1. Print out a hard copy of PDF test. Complete the test in the time frame designated on the test itself and attempt it very neatly. \n'
                    '2. Take a picture of it and send it to the provided Email address. \n'
                    '3. Please revise the test before sending it. Please verify the Email address again, where you need to email the test. \n'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
