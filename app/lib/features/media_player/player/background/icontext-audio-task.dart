import 'package:audio_service/audio_service.dart';

import 'audio-context.dart';

/// A [BackgroundAudioTask] which exposes lots of information about the playback.
/// This may or may note be a case of super leaky abstraction.
abstract class IContextAudioTask extends BackgroundAudioTask {
  AudioContext get context;
}
