import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';

class AudioPlayerDisplay extends StatelessWidget {
  const AudioPlayerDisplay({
    Key key,
    @required this.item,
    this.dense = false,
    this.onClose,
  }) : super(key: key);
  final MediaItem item;
  final bool dense;
  final VoidCallback onClose;

  bool get showCloseButton => onClose != null;

  @override
  Widget build(BuildContext context) {
    return _buildDisplay(item);
  }

  Widget _buildDisplay(MediaItem item, [bool isLoading = false]) {
    return Column(
      children: [
        if (item?.album != null)
          Row(
            mainAxisAlignment: showCloseButton
                ? MainAxisAlignment.spaceBetween
                : MainAxisAlignment.center,
            children: [
              Container(),
              Text(
                item?.album,
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: dense ? 16 : 18),
                textAlign: TextAlign.center,
              ),
              if (showCloseButton)
                GestureDetector(
                  onTap: onClose,
                  child: const Icon(
                    Icons.close,
                    size: 15,
                  ),
                ),
            ],
          ),
        const SizedBox(height: 10),
        Text(
          item?.title ?? (isLoading ? 'Loading...' : 'Unknown'),
          style:
              TextStyle(fontWeight: FontWeight.bold, fontSize: dense ? 16 : 18),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
