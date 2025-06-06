// Copyright 2022 Sarbagya Dhaubanjar. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_iframe/src/widgets/custom_player_widgets/brand_logo.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

import '../controller/youtube_player_controller.dart';
import '../helpers/youtube_value_builder.dart';
import '../helpers/youtube_value_provider.dart';
import '../player_value.dart';
import 'custom_player_widgets/screen_gestures.dart';
import 'custom_player_widgets/sliders_and_controls.dart';
import 'youtube_player.dart';

/// A widget the scaffolds the [YoutubePlayer] so that it can be moved around easily in the view
/// and handles the fullscreen functionality.
class YoutubePlayerScaffold extends StatefulWidget {
  /// Creates [YoutubePlayerScaffold].
  const YoutubePlayerScaffold({
    super.key,
    required this.builder,
    required this.controller,
    this.aspectRatio = 16 / 9,
    this.autoFullScreen = false,
    this.defaultOrientations = DeviceOrientation.values,
    this.gestureRecognizers = const <Factory<OneSequenceGestureRecognizer>>{},
    this.fullscreenOrientations = const [
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ],
    this.lockedOrientations = const [
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ],
    this.enableFullScreenOnVerticalDrag = true,
    this.backgroundColor,
    this.brandLogo,
  });

  final Widget? brandLogo;

  /// Builds the child widget.
  final Widget Function(BuildContext context, Widget player) builder;

  /// The player controller.
  final YoutubePlayerController controller;

  /// The aspect ratio of the player.
  ///
  /// The value is ignored on fullscreen mode.
  final double aspectRatio;

  /// Whether the player should be fullscreen on device orientation changes.
  final bool autoFullScreen;

  /// The default orientations for the device.
  final List<DeviceOrientation> defaultOrientations;

  /// The orientations that are used when in fullscreen.
  final List<DeviceOrientation> fullscreenOrientations;

  /// The orientations that are used when not in fullscreen and auto rotate is disabled.
  final List<DeviceOrientation> lockedOrientations;

  /// Enables switching full screen mode on vertical drag in the player.
  ///
  /// Default is true.
  final bool enableFullScreenOnVerticalDrag;

  /// Which gestures should be consumed by the youtube player.
  ///
  /// This property is ignored in web.
  final Set<Factory<OneSequenceGestureRecognizer>> gestureRecognizers;

  /// The background color of the [WebView].
  final Color? backgroundColor;

  /// The value used for the HTTP User-Agent: request header.
  ///
  /// When null the platform's webview default is used for the User-Agent header.
  ///

  @override
  State<YoutubePlayerScaffold> createState() => _YoutubePlayerScaffoldState();
}

class _YoutubePlayerScaffoldState extends State<YoutubePlayerScaffold> {
  late final GlobalObjectKey _playerKey;

  @override
  void initState() {
    super.initState();

    _playerKey = GlobalObjectKey(widget.controller);

    _toggleScreen();
  }

  void _toggleScreen() {
    if (_showControlsNotifier.value) {
      _showControlsNotifier.value = false;
    } else {
      _showControlsNotifier.value = true;
      Future.delayed(const Duration(seconds: 5), () async {
        final state = await widget.controller.playerState;
        if (state == PlayerState.playing) _showControlsNotifier.value = false;
      });
    }
  }

  final ValueNotifier<bool> _showControlsNotifier = ValueNotifier(true);

  @override
  Widget build(BuildContext context) {
    final player = KeyedSubtree(
      key: _playerKey,
      child: YoutubePlayer(
        controller: widget.controller,
        aspectRatio: widget.aspectRatio,
        gestureRecognizers: widget.gestureRecognizers,
        enableFullScreenOnVerticalDrag: widget.enableFullScreenOnVerticalDrag,
        backgroundColor: widget.backgroundColor,
      ),
    );

    return YoutubePlayerControllerProvider(
      controller: widget.controller,
      child: kIsWeb
          ? widget.builder(context, player)
          : YoutubeValueBuilder(
              controller: widget.controller,
              buildWhen: (o, n) => o.fullScreenOption != n.fullScreenOption,
              builder: (context, value) {
                return Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    _FullScreen(
                      auto: widget.autoFullScreen,
                      defaultOrientations: widget.defaultOrientations,
                      fullscreenOrientations: widget.fullscreenOrientations,
                      lockedOrientations: widget.lockedOrientations,
                      fullScreenOption: value.fullScreenOption,
                      child: Builder(
                        builder: (context) {
                          if (value.fullScreenOption.enabled) return player;
                          return widget.builder(
                            context,
                            Directionality(
                              textDirection: TextDirection.ltr,
                              child: Stack(
                                alignment: Alignment.bottomCenter,
                                children: [
                                  player,
                                  BrandLogo(
                                    width: 100,
                                    logo: widget.brandLogo,
                                    ytController: widget.controller,
                                  ),
                                  Positioned.fill(
                                    child: ScreenGestures(
                                      detectScreenTap: () {
                                        _toggleScreen();
                                      },
                                    ),
                                  ),
                                  ValueListenableBuilder<bool>(
                                    valueListenable: _showControlsNotifier,
                                    builder: (context, show, _) {
                                      return show
                                          ? SlidersAndControls(
                                              ytController: widget.controller,
                                            )
                                          : const SizedBox.shrink();
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    if (value.fullScreenOption.enabled) ...[
                      BrandLogo(
                        width: 130,
                        logo: widget.brandLogo,
                        ytController: widget.controller,
                      ),
                      Directionality(
                        textDirection: TextDirection.ltr,
                        child: Positioned.fill(
                          child: Material(
                            type: MaterialType.transparency,
                            child: ScreenGestures(
                              detectScreenTap: () {
                                _toggleScreen();
                              },
                            ),
                          ),
                        ),
                      ),
                      Directionality(
                        textDirection: TextDirection.ltr,
                        child: ValueListenableBuilder<bool>(
                          valueListenable: _showControlsNotifier,
                          builder: (context, show, _) {
                            return show
                                ? SlidersAndControls(
                                    ytController: widget.controller,
                                  )
                                : const SizedBox.shrink();
                          },
                        ),
                      ),
                    ],
                  ],
                );
              },
            ),
    );
  }
}

class _FullScreen extends StatefulWidget {
  const _FullScreen({
    required this.fullScreenOption,
    required this.defaultOrientations,
    required this.fullscreenOrientations,
    required this.lockedOrientations,
    required this.child,
    required this.auto,
  });

  final FullScreenOption fullScreenOption;
  final List<DeviceOrientation> defaultOrientations;
  final List<DeviceOrientation> fullscreenOrientations;
  final List<DeviceOrientation> lockedOrientations;
  final Widget child;
  final bool auto;

  @override
  State<_FullScreen> createState() => _FullScreenState();
}

class _FullScreenState extends State<_FullScreen> with WidgetsBindingObserver {
  Orientation? _previousOrientation;
  bool canPop = false;

  @override
  void initState() {
    super.initState();
    canPop = Navigator.of(context).canPop();
    if (widget.auto) WidgetsBinding.instance.addObserver(this);
    SystemChrome.setPreferredOrientations(_deviceOrientations);
    SystemChrome.setEnabledSystemUIMode(_uiMode);
  }

  @override
  void didUpdateWidget(_FullScreen oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.fullScreenOption != widget.fullScreenOption) {
      SystemChrome.setPreferredOrientations(_deviceOrientations);
      SystemChrome.setEnabledSystemUIMode(_uiMode);
    }
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();

    final orientation = MediaQuery.of(context).orientation;
    final controller = YoutubePlayerControllerProvider.of(context);
    final isFullScreen = controller.value.fullScreenOption.enabled;

    if (_previousOrientation == orientation) return;

    if (!isFullScreen && orientation == Orientation.landscape) {
      controller.enterFullScreen(lock: false);
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    }

    _previousOrientation = orientation;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: canPop,
      onPopInvokedWithResult: _handleFullScreenBackAction,
      child: widget.child,
    );
  }

  @override
  void dispose() {
    if (widget.auto) WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  List<DeviceOrientation> get _deviceOrientations {
    final fullscreen = widget.fullScreenOption;

    if (!fullscreen.enabled && fullscreen.locked) {
      return widget.lockedOrientations;
    } else if (fullscreen.enabled) {
      return widget.fullscreenOrientations;
    }

    return widget.defaultOrientations;
  }

  SystemUiMode get _uiMode {
    return widget.fullScreenOption.enabled
        ? SystemUiMode.immersive
        : SystemUiMode.edgeToEdge;
  }

  void _handleFullScreenBackAction(bool didPop, _) {
    if (didPop) return;

    if (mounted && widget.fullScreenOption.enabled) {
      YoutubePlayerControllerProvider.of(context).exitFullScreen();
    }
  }
}
