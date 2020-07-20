import 'package:arrahma_mobile_app/Reading_Material/worksheet/model/worksheet_item.dart';
import 'package:flutter/material.dart';

class WorkSheet extends StatefulWidget {
  @override
  _WorkSheetState createState() => _WorkSheetState();
}

class _WorkSheetState extends State<WorkSheet> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text(
          'Worksheets',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(25.0),
            child: Container(
              child: Padding(
                padding: const EdgeInsets.only(right: 0.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                ),
              ),
            ),
          ),
          ..._worksheet.map((item) => _buildWorksheet(context, item)).toList(),
        ],
      ),
    );
  }

  final _worksheet = [
    WorkSheetItem(
      title: 'Worksheet 1',
      worksheetPdf: '',
    ),
    WorkSheetItem(
      title: 'Worksheet 1',
      worksheetPdf: '',
    ),
    WorkSheetItem(
      title: 'Worksheet 1',
      worksheetPdf: '',
    ),
  ];

  Widget _buildWorksheet(BuildContext context, WorkSheetItem item) {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Flexible(
            child: Text(
              item.title,
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 15),
            ),
          ),
          Row(
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, item.worksheetPdf);
                },
                child: Image.asset(
                  'assets/images/multi_page_icons/arrow_down.png',
                  width: 20,
                ),
              ),
              SizedBox(width: 30, height: 40),
            ],
          ),
        ],
      ),
    );
  }
}
