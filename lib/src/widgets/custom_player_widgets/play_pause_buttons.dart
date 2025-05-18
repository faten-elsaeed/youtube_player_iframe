import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class PlayPauseButtons extends StatelessWidget {
  PlayPauseButtons({super.key, required this.ytController});

  final YoutubePlayerController ytController;

  final ValueNotifier<bool> _isMuted = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        YoutubeValueBuilder(
          builder: (context, value) {
            return InkWell(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  value.playerState == PlayerState.playing
                      ? Icons.pause
                      : Icons.play_arrow,
                ),
              ),
              onTap: () {
                value.playerState == PlayerState.playing
                    ? ytController.pauseVideo()
                    : ytController.playVideo();
              },
            );
          },
        ),
        ValueListenableBuilder<bool>(
          valueListenable: _isMuted,
          builder: (context, isMuted, _) {
            return InkWell(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(isMuted ? Icons.volume_off : Icons.volume_up),
              ),
              onTap: () {
                _isMuted.value = !isMuted;
                isMuted ? ytController.unMute() : ytController.mute();
              },
            );
          },
        ),
      ],
    );
  }
}
