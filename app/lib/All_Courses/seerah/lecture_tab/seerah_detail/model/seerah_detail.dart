import 'package:flutter/cupertino.dart';

class SeerahTextDetailItem {
  const SeerahTextDetailItem({this.englishTitle, this.arabicTitle});
  final String englishTitle;
  final String arabicTitle;
}

class LectureAudioPDFDetail {
  const LectureAudioPDFDetail(
      {this.pdfIcon, this.audioIcon, this.pdfRoute, this.audioRoute});
  final IconData pdfIcon;
  final IconData audioIcon;
  final String pdfRoute;
  final String audioRoute;
}
