import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class PlayerPage extends StatefulWidget {
  const PlayerPage({super.key});

  @override
  State<PlayerPage> createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> {
  late YoutubePlayerController _controller;
  final vId = 'lEiaAwYZTfU';

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      params: const YoutubePlayerParams(
        mute: false,
        loop: false,
        enableCaption: true,
      ),
      showControls: true,
    );

    _controller.setFullScreenListener(
      (isFullScreen) {
        log('${isFullScreen ? 'Entered' : 'Exited'} Fullscreen.');
      },
    );

    _controller.loadVideoById(videoId: vId);
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerScaffold(
      controller: _controller,
      brandLogo: const SizedBox(),
      builder: (context, player) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Youtube Player IFrame Demo'),
          ),
          body: LayoutBuilder(
            builder: (context, constraints) {
              return Column(
                children: [
                  player,
                ],
              );
            },
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }
}
