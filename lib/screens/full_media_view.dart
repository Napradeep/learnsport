import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class FullMediaView extends StatefulWidget {
  final List<Map<String, dynamic>> items;       
  final int initialIndex;
  final String title;
  final bool isAdmin;
  final VoidCallback onDelete;

  const FullMediaView({
    required this.items,
    required this.initialIndex,
    required this.title,
    required this.isAdmin,
    required this.onDelete,
  });

  @override
  State<FullMediaView> createState() => _FullMediaViewState();
}

class _FullMediaViewState extends State<FullMediaView> {
  late PageController _pageController;
  VideoPlayerController? _controller;

  int _index = 0;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _index = widget.initialIndex;
    _pageController = PageController(initialPage: _index);

    if (_isVideo(widget.items[_index])) {
      _loadVideo(widget.items[_index]["url"]);
    }
  }

  bool _isVideo(Map<String, dynamic> item) =>
      item["type"] == "VIDEO" || item["mimetype"]?.contains("video") == true;

  Future<void> _loadVideo(String url) async {
    try {
      setState(() => _loading = true);
      _controller?.dispose();

      _controller = VideoPlayerController.networkUrl(Uri.parse(url));
      await _controller!.initialize();
      _controller!.play();
    } catch (_) {}
    setState(() => _loading = false);
  }

  @override
  void dispose() {
    _controller?.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      appBar: AppBar(
         centerTitle: false,
        foregroundColor: Colors.white,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),

        title: Text(
          '${widget.title} (${_index + 1}/${widget.items.length})',
          style: const TextStyle(color: Colors.white),
        ),

        // actions: widget.isAdmin
        //     ? [
        //         IconButton(
        //           icon: const Icon(Icons.delete, color: Colors.red),
        //           onPressed: () {
        //             widget.onDelete();
        //             Navigator.pop(context);
        //           },
        //         )
        //       ]
        //     : null,
      ),

      body: PageView.builder(
        controller: _pageController,
        itemCount: widget.items.length,
        onPageChanged: (i) {
          setState(() => _index = i);

          final item = widget.items[i];

          if (_isVideo(item)) {
            _loadVideo(item["url"]);
          }
        },

        itemBuilder: (_, i) {
          final item = widget.items[i];
          final isVideo = _isVideo(item);

          if (isVideo) {
            if (_loading || _controller == null) {
              return const Center(child: CircularProgressIndicator());
            }

            return Stack(
              alignment: Alignment.center,
              children: [
                AspectRatio(
                  aspectRatio: _controller!.value.aspectRatio,
                  child: VideoPlayer(_controller!),
                ),

                Positioned(
                  bottom: 30,
                  left: 0,
                  right: 0,
                  child: VideoProgressIndicator(
                    _controller!,
                    allowScrubbing: true,
                  ),
                ),

                GestureDetector(
                  onTap: () {
                    setState(() {
                      _controller!.value.isPlaying
                          ? _controller!.pause()
                          : _controller!.play();
                    });
                  },
                  child: Icon(
                    _controller!.value.isPlaying
                        ? Icons.pause_circle
                        : Icons.play_circle_fill,
                    size: 70,
                    color: Colors.white,
                  ),
                ),
              ],
            );
          }

          return InteractiveViewer(
            child: Image.network(
              item["url"],
              fit: BoxFit.contain,
              loadingBuilder: (_, child, progress) {
                if (progress == null) return child;
                return const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                );
              },
              errorBuilder: (_, __, ___) =>
                  const Icon(Icons.broken_image, size: 80, color: Colors.white),
            ),
          );
        },
      ),
    );
  }
}
