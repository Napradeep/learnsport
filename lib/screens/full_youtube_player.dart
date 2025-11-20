import 'package:flutter/material.dart';
import 'package:sportspark/utils/const/const.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class FullYoutubePlayer extends StatefulWidget {
  final String url;

  const FullYoutubePlayer({super.key, required this.url});

  @override
  State<FullYoutubePlayer> createState() => _FullYoutubePlayerState();
}

class _FullYoutubePlayerState extends State<FullYoutubePlayer> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();

    final videoId = YoutubePlayer.convertUrlToId(widget.url) ?? "";

    _controller = YoutubePlayerController(
      initialVideoId: videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        controlsVisibleAtStart: true,
        enableCaption: true,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerBuilder(
      player: YoutubePlayer(
        controller: _controller,
        showVideoProgressIndicator: true,
        progressIndicatorColor: Colors.black,
      ),
      builder: (context, player) {
        return Scaffold(
          backgroundColor: Colors.white,

          appBar: AppBar(
             centerTitle: false,
            backgroundColor: AppColors.bluePrimaryDual,
            elevation: 0,
            automaticallyImplyLeading: true,
            iconTheme: const IconThemeData(color: Colors.white),
            title: const Text(
              "Video Player",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          body: Center(
            child: AspectRatio(aspectRatio: 16 / 9, child: player),
          ),
        );
      },
    );
  }
}
