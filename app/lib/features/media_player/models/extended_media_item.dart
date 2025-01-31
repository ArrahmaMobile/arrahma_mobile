import 'package:audio_service/audio_service.dart';
import 'package:dart_json_mapper/dart_json_mapper.dart';

class ExtendedMediaItem extends MediaItem {
  ExtendedMediaItem({
    required super.id,
    required super.title,
    super.album,
    super.artist,
    super.genre,
    super.duration,
    super.artUri,
    super.displayTitle,
    super.displaySubtitle,
    super.displayDescription,
    required this.isCached,
  });

  static ExtendedMediaItem fromMediaItem(MediaItem mediaItem, bool isCached) {
    return ExtendedMediaItem(
      id: mediaItem.id,
      title: mediaItem.title,
      album: mediaItem.album,
      artist: mediaItem.artist,
      genre: mediaItem.genre,
      duration: mediaItem.duration,
      artUri: mediaItem.artUri,
      displayTitle: mediaItem.displayTitle,
      displaySubtitle: mediaItem.displaySubtitle,
      displayDescription: mediaItem.displayDescription,
      isCached: isCached,
    );
  }

  RawExtendedMediaItem toRawMediaItem() {
    return RawExtendedMediaItem(
      id: id,
      title: title,
      album: album,
      artist: artist,
      genre: genre,
      duration: duration,
      artUri: artUri,
      displayTitle: displayTitle,
      displaySubtitle: displaySubtitle,
      displayDescription: displayDescription,
      isCached: isCached,
    );
  }

  final bool isCached;
}

@jsonSerializable
class RawExtendedMediaItem {
  RawExtendedMediaItem({
    required this.id,
    required this.title,
    this.album,
    this.artist,
    this.genre,
    this.duration,
    this.artUri,
    this.displayTitle,
    this.displaySubtitle,
    this.displayDescription,
    required this.isCached,
  });
  final String id;
  final String title;
  final String? album;
  final String? artist;
  final String? genre;
  final Duration? duration;
  final Uri? artUri;
  final String? displayTitle;
  final String? displaySubtitle;
  final String? displayDescription;
  final bool isCached;

  ExtendedMediaItem toExtendedMediaItem() {
    return ExtendedMediaItem(
      id: id,
      title: title,
      album: album,
      artist: artist,
      genre: genre,
      duration: duration,
      artUri: artUri,
      displayTitle: displayTitle,
      displaySubtitle: displaySubtitle,
      displayDescription: displayDescription,
      isCached: isCached,
    );
  }
}
