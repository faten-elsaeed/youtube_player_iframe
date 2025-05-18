import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class SpeedButton extends StatelessWidget {
  const SpeedButton({super.key, required this.ytController});

  final YoutubePlayerController ytController;

  @override
  Widget build(BuildContext context) {
    return YoutubeValueBuilder(
      buildWhen: (o, n) {
        return o.metaData != n.metaData ||
            o.playbackQuality != n.playbackQuality;
      },
      builder: (context, value) {
        return YoutubeValueBuilder(
          builder: (context, value) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButton(
                  value: value.playbackRate,
                  isDense: true,
                  icon: const Icon(
                    Icons.speed,
                    color: Colors.white,
                    size: 20,
                  ),
                  underline: const SizedBox(),
                  items: PlaybackRate.all
                      .map(
                        (rate) => DropdownMenuItem(
                          value: rate,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 3),
                            child: Text(
                              '${rate}x',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (double? newValue) {
                    if (newValue != null) {
                      ytController.setPlaybackRate(newValue);
                    }
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}
