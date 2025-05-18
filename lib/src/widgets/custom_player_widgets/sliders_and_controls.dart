import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/src/controller/youtube_player_controller.dart';
import 'full_screen_button.dart';
import 'play_pause_buttons.dart';
import 'position_slider.dart';
import 'speed_button.dart';
import 'video_durations.dart';

class SlidersAndControls extends StatelessWidget {
  const SlidersAndControls({super.key, required this.ytController});

  final YoutubePlayerController ytController;

  @override
  Widget build(BuildContext context) {
    if (!ytController.showControls) return const SizedBox();
    return Material(
      type: MaterialType.transparency,
      child: Container(
        height: 70,
        color: Colors.black.withValues(alpha: 0.6),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              PositionSlider(ytController: ytController),
              Row(
                children: [
                  PlayPauseButtons(ytController: ytController),
                  VideoDuration(ytController: ytController),
                  const Spacer(),
                  SpeedButton(ytController: ytController),
                  FullScreenButton(ytController: ytController),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
