import 'dart:math';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';

import 'models/position_data.dart';

class AudioPlayerSeekBar extends StatefulWidget {
  const AudioPlayerSeekBar(
      {super.key, required this.player, this.hideThumb = false});
  final AudioPlayer player;
  final bool hideThumb;

  @override
  State<AudioPlayerSeekBar> createState() => _AudioPlayerSeekBarState();
}

class _AudioPlayerSeekBarState extends State<AudioPlayerSeekBar> {
  Stream<PositionData> get _positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
          widget.player.positionStream,
          widget.player.bufferedPositionStream,
          widget.player.durationStream,
          (position, bufferedPosition, duration) => PositionData(
              position, bufferedPosition, duration ?? Duration.zero));
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<PositionData>(
      stream: _positionDataStream,
      builder: (context, snapshot) {
        final positionData = snapshot.data;
        return SeekBar(
          hideThumb: widget.hideThumb,
          duration: positionData?.duration ?? Duration.zero,
          position: positionData?.position ?? Duration.zero,
          bufferedPosition: positionData?.bufferedPosition ?? Duration.zero,
          onChangeEnd: (newPosition) {
            widget.player.seek(newPosition);
          },
        );
      },
    );
  }
}

class AudioPlayerRemainingTimer extends StatefulWidget {
  const AudioPlayerRemainingTimer(
      {super.key, required this.player, this.showCloseButton = false});
  final AudioPlayer player;
  final bool showCloseButton;

  @override
  State<AudioPlayerRemainingTimer> createState() =>
      _AudioPlayerRemainingTimerState();
}

class _AudioPlayerRemainingTimerState extends State<AudioPlayerRemainingTimer> {
  Stream<MapEntry<PositionData, PlayerState>> get _positionDataStream =>
      Rx.combineLatest4<Duration, Duration, Duration?, PlayerState,
              MapEntry<PositionData, PlayerState>>(
          widget.player.positionStream,
          widget.player.bufferedPositionStream,
          widget.player.durationStream,
          widget.player.playerStateStream,
          (position, bufferedPosition, duration, state) => MapEntry(
              PositionData(
                  position, bufferedPosition, duration ?? Duration.zero),
              state));
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<MapEntry<PositionData, PlayerState>>(
      stream: _positionDataStream,
      builder: (context, snapshot) {
        final positionData = snapshot.data?.key;
        final duration = positionData?.duration ?? Duration.zero;
        final position = positionData?.position ?? Duration.zero;
        return AnimatedCrossFade(
          crossFadeState: (!(snapshot.data?.value.playing ?? false)) && widget.showCloseButton
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 200),
          firstChild: RemainingTimer(
            remaining: duration - position,
          ),
          secondChild: widget.showCloseButton
              ? IconButton(
                  icon: const Icon(Icons.close),
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    widget.player.stop();
                  },
                )
              : const SizedBox(),
        );
      },
    );
  }
}

class SeekBar extends StatefulWidget {
  const SeekBar({
    Key? key,
    required this.duration,
    required this.position,
    required this.bufferedPosition,
    this.hideThumb = false,
    this.onChanged,
    this.onChangeEnd,
  }) : super(key: key);
  final Duration duration;
  final Duration position;
  final Duration bufferedPosition;
  final bool hideThumb;
  final ValueChanged<Duration>? onChanged;
  final ValueChanged<Duration>? onChangeEnd;

  @override
  SeekBarState createState() => SeekBarState();
}

class SeekBarState extends State<SeekBar> {
  double? _dragValue;
  late SliderThemeData _sliderThemeData;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _sliderThemeData = SliderTheme.of(context).copyWith(
      trackHeight: 2.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SliderTheme(
          data: _sliderThemeData.copyWith(
            thumbShape: HiddenThumbComponentShape(),
            activeTrackColor: Colors.blue.shade100,
            inactiveTrackColor: Colors.grey.shade300,
            overlayShape:
                widget.hideThumb ? SliderComponentShape.noThumb : null,
          ),
          child: ExcludeSemantics(
            child: Slider(
              min: 0.0,
              max: widget.duration.inMilliseconds.toDouble(),
              value: min(widget.bufferedPosition.inMilliseconds.toDouble(),
                  widget.duration.inMilliseconds.toDouble()),
              onChanged: (value) {
                setState(() {
                  _dragValue = value;
                });
                if (widget.onChanged != null) {
                  widget.onChanged!(Duration(milliseconds: value.round()));
                }
              },
              onChangeEnd: (value) {
                if (widget.onChangeEnd != null) {
                  widget.onChangeEnd!(Duration(milliseconds: value.round()));
                }
                _dragValue = null;
              },
            ),
          ),
        ),
        SliderTheme(
          data: _sliderThemeData.copyWith(
            inactiveTrackColor: Colors.transparent,
            thumbShape: widget.hideThumb ? HiddenThumbComponentShape() : null,
            overlayShape:
                widget.hideThumb ? SliderComponentShape.noThumb : null,
          ),
          child: Slider(
            min: 0.0,
            max: widget.duration.inMilliseconds.toDouble(),
            value: min(_dragValue ?? widget.position.inMilliseconds.toDouble(),
                widget.duration.inMilliseconds.toDouble()),
            onChanged: (value) {
              setState(() {
                _dragValue = value;
              });
              if (widget.onChanged != null) {
                widget.onChanged!(Duration(milliseconds: value.round()));
              }
            },
            onChangeEnd: (value) {
              if (widget.onChangeEnd != null) {
                widget.onChangeEnd!(Duration(milliseconds: value.round()));
              }
              _dragValue = null;
            },
          ),
        ),
        if (!widget.hideThumb)
          Positioned(
            right: 16.0,
            bottom: 0.0,
            child: RemainingTimer(remaining: _remaining),
          ),
      ],
    );
  }

  Duration get _remaining => widget.duration - widget.position;
}

class RemainingTimer extends StatelessWidget {
  const RemainingTimer({super.key, required this.remaining});

  final Duration remaining;

  @override
  Widget build(BuildContext context) {
    return Text(
        RegExp(r'((^0*[1-9]\d*:)?\d{2}:\d{2})\.\d+$')
                .firstMatch("$remaining")
                ?.group(1) ??
            '$remaining',
        style: Theme.of(context).textTheme.bodySmall);
  }
}

class HiddenThumbComponentShape extends SliderComponentShape {
  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) => Size.zero;

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {}
}
