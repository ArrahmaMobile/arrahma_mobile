import 'package:arrahma_mobile_app/Reading_Material/assorted_topic/model/assorted_topic_item.dart';
import 'package:flutter/material.dart';

class AssortedTopic extends StatefulWidget {
  @override
  _AssortedTopicState createState() => _AssortedTopicState();
}

class _AssortedTopicState extends State<AssortedTopic> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: const Color(0xff124570),
        title: Text(
          'Assorted Topics',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
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
          ..._assortedTopic
              .map((item) => _buildAssprtedTopic(context, item))
              .toList(),
        ],
      ),
    );
  }

  final _assortedTopic = [
    const AssortedTopicItems(
      title: '**NEW** Important things about Hajj',
      topicPdf: '',
    ),
    const AssortedTopicItems(
      title: 'Masnoon Darood',
      topicPdf: '',
    ),
    const AssortedTopicItems(
      title: 'Blindness of Heart',
      topicPdf: '',
    ),
  ];

  Widget _buildAssprtedTopic(BuildContext context, AssortedTopicItems item) {
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
                  Navigator.pushNamed(context, item.topicPdf);
                },
                child: Image.asset(
                  'assets/images/multi_page_icons/arrow_down.png',
                  width: 20,
                  color: Colors.black,
                ),
              ),
              const SizedBox(width: 30, height: 40),
            ],
          ),
        ],
      ),
    );
  }
}
