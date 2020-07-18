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
      this.rootWordPdfUrls,
      this.translationAudioUrls,
      this.tafseerAudioUrls,
      this.refMaterials});
  final String title;
  final List<String> rootWordPdfUrls;
  final List<String> translationAudioUrls;
  final List<String> tafseerAudioUrls;
  final List<String> refMaterials;
}
