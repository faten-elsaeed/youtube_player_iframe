import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class PositionSlider extends StatelessWidget {
  const PositionSlider({super.key, required this.ytController});

  final YoutubePlayerController ytController;

  @override
  Widget build(BuildContext context) {
    var value = 0.0;
    return StreamBuilder<YoutubeVideoState>(
      stream: ytController.videoStateStream,
      initialData: const YoutubeVideoState(),
      builder: (context, snapshot) {
        final position = snapshot.data?.position.inSeconds ?? 0;
        final duration = ytController.metadata.duration.inSeconds;
        value = position == 0 || duration == 0 ? 0 : position / duration;
        return StatefulBuilder(
          builder: (context, setState) {
            return Slider(
              activeColor: Colors.red,
              thumbColor: Colors.white,
              inactiveColor: Colors.white38,
              padding: EdgeInsets.zero,
              value: value,
              onChanged: (positionFraction) {
                value = positionFraction;
                setState(() {});
                ytController.seekTo(
                  seconds: (value * duration).toDouble(),
                  allowSeekAhead: true,
                );
              },
              min: 0,
              max: 1,
            );
          },
        );
      },
    );
  }
}
