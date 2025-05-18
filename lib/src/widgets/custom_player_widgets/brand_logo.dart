import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class BrandLogo extends StatelessWidget {
  const BrandLogo(
      {super.key, required this.width, this.logo, required this.ytController});

  final double width;
  final Widget? logo;
  final YoutubePlayerController ytController;

  @override
  Widget build(BuildContext context) {
    if (logo == null) return const SizedBox();
    return StreamBuilder<YoutubeVideoState>(
      stream: ytController.videoStateStream,
      initialData: const YoutubeVideoState(),
      builder: (context, snapshot) {
        final position = snapshot.data?.position ?? Duration.zero;
        final duration = ytController.metadata.duration;
        return YoutubeValueBuilder(
          builder: (context, value) {
            return position.inSeconds > 3 &&
                    value.playerState == PlayerState.playing
                ? const SizedBox()
                : Align(
                    alignment: Alignment.bottomRight,
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      color: Colors.transparent,
                      width: width,
                      height: 50,
                      child: logo,
                    ),
                  );
          },
        );
      },
    );
  }
}
