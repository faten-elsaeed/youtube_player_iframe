import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class FullScreenButton extends StatelessWidget {
  const FullScreenButton({super.key, required this.ytController});

  final YoutubePlayerController ytController;

  @override
  Widget build(BuildContext context) {
    return YoutubeValueBuilder(
      builder: (context, value) {
        return InkWell(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Icon(
              value.fullScreenOption.enabled
                  ? Icons.fullscreen_exit
                  : Icons.fullscreen,
              color: Colors.white,
              size: 22,
            ),
          ),
          onTap: () {
            value.fullScreenOption.enabled
                ? context.ytController.exitFullScreen()
                : context.ytController.enterFullScreen();
          },
        );
      },
    );
  }
}
