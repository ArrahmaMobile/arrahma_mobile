import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CarouselIndicator extends StatefulWidget {
  const CarouselIndicator({
    Key key,
    @required this.items,
    this.showIndicator = true,
    this.aspectRatio,
    this.autoPlayInterval,
  }) : super(key: key);
  final List<Widget> items;
  final bool showIndicator;
  final double aspectRatio;
  final Duration autoPlayInterval;

  @override
  State<StatefulWidget> createState() {
    return CarouselIndicatorState();
  }
}

class CarouselIndicatorState extends State<CarouselIndicator> {
  int _current = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider(
          items: widget.items,
          options: CarouselOptions(
              autoPlayInterval:
                  widget.autoPlayInterval ?? const Duration(seconds: 4),
              autoPlay: true,
              enlargeCenterPage: true,
              aspectRatio: widget.aspectRatio ?? 2.77,
              onPageChanged: (index, reason) {
                setState(() {
                  _current = index;
                });
              }),
        ),
        if (widget.showIndicator)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: widget.items?.map((url) {
                  int index = widget.items.indexOf(url);
                  return Container(
                    width: 8.0,
                    height: 8.0,
                    margin:
                        EdgeInsets.symmetric(vertical: 8.0, horizontal: 2.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _current == index
                          ? Color.fromRGBO(0, 0, 0, 0.9)
                          : Color.fromRGBO(0, 0, 0, 0.4),
                    ),
                  );
                })?.toList() ??
                [],
          ),
      ],
    );
  }
}
