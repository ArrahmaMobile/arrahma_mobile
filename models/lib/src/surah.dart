class Surah {
  const Surah({this.name, this.arabicName, this.description, this.lessons});
  final String name;
  final String arabicName;
  final String description;
  final List<Lesson> lessons;
}

class Lesson {
  const Lesson(
      {this.title,
      this.ayahNum,
      this.lessonNum,
      this.uploadDate,
      this.rootWordPdfUrls,
      this.translationAudioUrls,
      this.tafseerAudioUrls,
      this.refMaterials,
      this.lessonAudio});
  final String title;
  final String lessonNum;
  final String ayahNum;
  final String uploadDate;
  final List<String> rootWordPdfUrls;
  final List<String> translationAudioUrls;
  final List<String> tafseerAudioUrls;
  final List<String> refMaterials;
  final List<QuranLessonAudioItem> lessonAudio;
}

class QuranLessonAudioItem {
  const QuranLessonAudioItem(
      {this.title,
      this.rootWordPdf,
      this.translationAudio,
      this.tafseerAudio,
      this.refMaterialAudio});
  final String title;
  final String rootWordPdf;
  final String translationAudio;
  final String tafseerAudio;
  final String refMaterialAudio;
}
