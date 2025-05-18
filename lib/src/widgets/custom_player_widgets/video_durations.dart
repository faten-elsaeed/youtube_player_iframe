import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class VideoDuration extends StatefulWidget {
  const VideoDuration({super.key, required this.ytController});

  final YoutubePlayerController ytController;

  @override
  State<VideoDuration> createState() => _VideoDurationState();
}

class _VideoDurationState extends State<VideoDuration> with AutomaticKeepAliveClientMixin {
  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context)  {
    super.build(context);
    return StreamBuilder<YoutubeVideoState>(
      stream: widget.ytController.videoStateStream,
      initialData: const YoutubeVideoState(),
      builder: (context, snapshot) {
        final position = snapshot.data?.position ?? Duration.zero;
        final duration = widget.ytController.metadata.duration;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                formatDuration(position),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                ),
              ),
              const Text(
                ' / ',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                ),
              ),
              Text(
                formatDuration(duration),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
