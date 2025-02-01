import 'package:arrahma_mobile_app/services/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_framework/flutter_framework.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:inherited_state/inherited_state.dart';

class DataLoadingBanner extends StatefulWidget {
  const DataLoadingBanner({super.key});

  @override
  State<DataLoadingBanner> createState() => _DataLoadingBannerState();
}

class _DataLoadingBannerState extends State<DataLoadingBanner> {
  final appService = SL.get<AppService>()!;

  @override
  void initState() {
    super.initState();
    appService.dataLoadingListenable.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!appService.dataLoadingListenable.value) {
      return const SizedBox();
    }
    return const NoticeView(
      type: MessageType.Info,
      title: Text('Data is updating...'),
      icon: FontAwesomeIcons.arrowsRotate,
    );
  }
}
