import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class ScreenGestures extends StatelessWidget {
  const ScreenGestures({super.key, this.detectScreenTap});

  final VoidCallback? detectScreenTap;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<YoutubeVideoState>(
      stream: context.ytController.videoStateStream,
      initialData: const YoutubeVideoState(),
      builder: (context, snapshot) {
        final position = snapshot.data?.position.inSeconds ?? 0;
        final duration = context.ytController.metadata.duration.inSeconds;
        final forwardSeek =
            (position + 10) <= duration ? (position + 10) : duration;
        final backwardSeek = (position - 10) >= 0 ? (position - 10) : 0;

        return YoutubeValueBuilder(builder: (context, value) {
          bool tappedForward = false;
          bool tappedBackward = false;
          bool tappedPlay = false;
          return StatefulBuilder(
            builder: (context, setState) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  if (tappedPlay)
                    Icon(
                      value.playerState == PlayerState.playing
                          ? Icons.play_circle_outline_rounded
                          : Icons.pause_circle_outline_rounded,
                      size: 40,
                      color: Colors.white38,
                    ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onDoubleTap: () {
                            context.ytController.seekTo(
                              seconds: backwardSeek.toDouble(),
                              allowSeekAhead: true,
                            );
                            setState(() => tappedBackward = true);
                            Future.delayed(
                              const Duration(milliseconds: 400),
                              () => setState(() => tappedBackward = false),
                            );
                          },
                          onTap: () {
                            value.playerState == PlayerState.playing
                                ? context.ytController.pauseVideo()
                                : context.ytController.playVideo();
                            setState(() => tappedPlay = true);
                            Future.delayed(
                              const Duration(milliseconds: 600),
                              () => setState(() => tappedPlay = false),
                            );
                            detectScreenTap?.call();
                          },
                          child: Container(
                            color: Colors.transparent,
                            child: tappedBackward
                                ? Center(
                                    child: Transform.flip(
                                      flipX: true,
                                      child: const Icon(
                                        Icons.fast_forward,
                                        color: Colors.white,
                                      ),
                                    ),
                                  )
                                : null,
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onDoubleTap: () {
                            context.ytController.seekTo(
                              seconds: forwardSeek.toDouble(),
                              allowSeekAhead: true,
                            );
                            setState(() => tappedForward = true);
                            Future.delayed(
                              const Duration(milliseconds: 600),
                              () => setState(() => tappedForward = false),
                            );
                          },
                          onTap: () {
                            value.playerState == PlayerState.playing
                                ? context.ytController.pauseVideo()
                                : context.ytController.playVideo();
                            setState(() => tappedPlay = true);
                            Future.delayed(
                              const Duration(milliseconds: 1000),
                              () => setState(() => tappedPlay = false),
                            );
                            detectScreenTap?.call();
                          },
                          child: Container(
                            color: Colors.transparent,
                            child: tappedForward
                                ? const Center(
                                    child: Icon(
                                      Icons.fast_forward,
                                      color: Colors.white,
                                    ),
                                  )
                                : null,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          );
        });
      },
    );
  }
}
