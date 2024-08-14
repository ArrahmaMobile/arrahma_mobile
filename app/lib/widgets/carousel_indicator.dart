import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_framework/flutter_framework.dart';

class CarouselIndicator extends StatefulWidget {
  const CarouselIndicator({
    super.key,
    required this.items,
    this.showIndicator = true,
    this.aspectRatio,
    this.autoPlayInterval,
  });
  final List<Widget> items;
  final bool showIndicator;
  final double? aspectRatio;
  final Duration? autoPlayInterval;

  @override
  State<StatefulWidget> createState() {
    return CarouselIndicatorState();
  }
}

class CarouselIndicatorState extends State<CarouselIndicator> {
  int _current = 0;

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);
    final screenUtils = ScreenUtils.getInstance(context)!;
    return Column(
      children: [
        CarouselSlider(
          items: widget?.items ?? [],
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
            children: widget.items?.map(
                  (url) {
                    final index = widget.items.indexOf(url);
                    return Container(
                      width: screenUtils.getWidth(8.0),
                      height: screenUtils.getWidth(8.0),
                      margin: EdgeInsets.symmetric(
                        vertical: 8.0,
                        horizontal: screenUtils.getWidth(2.0),
                      ),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: appTheme.theme!.textTheme.bodyMedium?.color
                              ?.withOpacity(_current == index ? .9 : .4)),
                    );
                  },
                )?.toList() ??
                [],
          ),
      ],
    );
  }
}
