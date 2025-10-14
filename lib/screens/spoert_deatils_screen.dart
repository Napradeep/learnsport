import 'package:flutter/material.dart';
import 'package:sportspark/utils/const/const.dart'; // Assuming this is where AppColors is defined or move it there
import 'package:video_player/video_player.dart';

// Sample data structure for images and videos grouped by date
// Using network URLs instead of assets
final Map<String, List<String>> _imageData = {
  '05/10/2025': [
    'https://pbs.twimg.com/media/G2iRFXnXMAA5gG4.jpg',
    'https://pbs.twimg.com/media/G2iRCh4aUAAUrr_.jpg',
    'https://pbs.twimg.com/media/G2iQxHLa0AAr6hh.jpg',
    'https://pbs.twimg.com/media/G2iQ99KW8AA4yHp.jpg',
    'https://pbs.twimg.com/media/G2iQ3wsWMAAM8Ca.jpg',
    'https://pbs.twimg.com/media/G2iQ3WaWwAA8D-a.jpg',
  ],
  '04/10/2025': [
    'https://pbs.twimg.com/media/G2dHem3XwAAP2eD.jpg',
    'https://pbs.twimg.com/media/G2dHRH4WYAAhp2I.jpg',
    'https://pbs.twimg.com/media/G2dHeOTXgAA4VwL.jpg',
    'https://pbs.twimg.com/media/G2dHeXZWQAApKSS.jpg',
    'https://pbs.twimg.com/media/G2dHCVFWcAANKid.jpg',
    'https://pbs.twimg.com/media/G2dHCVCWkAAlIe_.jpg',
  ],
};

final Map<String, List<String>> _videoData = {
  '05/10/2025': [
    'https://video.twimg.com/amplify_video/1974987840749551616/vid/avc1/584x270/HQSeTb04EdBEWsl0.mp4',
    'https://video.twimg.com/amplify_video/1974987732007960576/vid/avc1/582x270/eeCuZZC0cM7fleV4.mp4',
    'https://video.twimg.com/amplify_video/1974987406454493184/vid/avc1/320x568/N4kBf4ri9QufGKmy.mp4',
    'https://video.twimg.com/amplify_video/1974986799802966016/vid/avc1/320x446/vq8WGwyVWgzfg1l3.mp4',
    'https://video.twimg.com/amplify_video/1974986329998909440/vid/avc1/360x270/qdBN_tlfIr7Kf9sw.mp4',
  ],
  '04/10/2025': [
    'https://video.twimg.com/amplify_video/1974625404334813184/vid/avc1/320x568/v9LCe9GjCbYwxkdM.mp4',
    'https://video.twimg.com/amplify_video/1974624883272216576/vid/avc1/320x568/gSyvYXMoyctJ_Blk.mp4',
    'https://video.twimg.com/amplify_video/1974625150633926656/vid/avc1/320x400/Pcy8qe8DY-027aXH.mp4?tag=16',
    'https://video.twimg.com/amplify_video/1974622938667143168/vid/avc1/480x270/li6OjqwDOq3TkyPF.mp4',
    'https://video.twimg.com/amplify_video/1974625067263770624/vid/avc1/480x270/jOT4f1ol6aWn0VGm.mp4?tag=16',
  ],
  // Add more dates as needed
};

class SportDetailScreen extends StatefulWidget {
  final String title;
  final String imagePath; // Optional hero tag from previous screen

  const SportDetailScreen({
    super.key,
    required this.title,
    required this.imagePath,
  });

  @override
  State<SportDetailScreen> createState() => _SportDetailScreenState();
}

class _SportDetailScreenState extends State<SportDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          widget.title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppColors.bluePrimaryDual,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Container(
            color: AppColors.bluePrimaryDual,
            child: TabBar(
              controller: _tabController,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white.withOpacity(0.7),
              indicatorColor: Colors.white,
              indicatorWeight: 3,
              tabs: const [
                Tab(text: 'Images'),
                Tab(text: 'Videos'),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildMediaList(_imageData, isVideo: false),
                _buildMediaList(_videoData, isVideo: true),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMediaList(
    Map<String, List<String>> data, {
    required bool isVideo,
  }) {
    final dates = data.keys.toList()
      ..sort(
        (a, b) => _parseDate(b).compareTo(_parseDate(a)),
      ); // Sort descending
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(12.0),
      itemCount: dates.length,
      itemBuilder: (context, index) {
        final date = dates[index];
        final items = data[date]!;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  date,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // Navigate to full list for this date
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => _FullMediaListScreen(
                          title: '$date - ${isVideo ? 'Videos' : 'Images'}',
                          items: items,
                          isVideo: isVideo,
                        ),
                      ),
                    );
                  },
                  child: Text(
                    'See All >>',
                    style: TextStyle(
                      color: AppColors.bluePrimaryDual,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 120, // Adjust based on thumbnail size
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: items.length > 4
                    ? 4
                    : items.length, // Show up to 4 thumbnails
                itemBuilder: (context, idx) {
                  final item = items[idx];
                  return GestureDetector(
                    onTap: () {
                      // Open full view
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          transitionDuration: const Duration(milliseconds: 600),
                          pageBuilder: (_, __, ___) => _FullMediaView(
                            path: item,
                            title: '${widget.title} - ${date}',
                            isVideo: isVideo,
                          ),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: SizedBox(
                          width: 120,
                          child: isVideo
                              ? Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    Image.network(
                                      'https://via.placeholder.com/120x120?text=Video+Thumb', // Use a real thumbnail service or placeholder
                                      fit: BoxFit.cover,
                                    ),
                                    const Center(
                                      child: Icon(
                                        Icons.play_circle_outline,
                                        color: Colors.white,
                                        size: 40,
                                      ),
                                    ),
                                  ],
                                )
                              : Image.network(item, fit: BoxFit.cover),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
          ],
        );
      },
    );
  }

  DateTime _parseDate(String dateStr) {
    final parts = dateStr.split('/');
    return DateTime(
      int.parse(parts[2]),
      int.parse(parts[1]),
      int.parse(parts[0]),
    );
  }
}

class _FullMediaListScreen extends StatelessWidget {
  final String title;
  final List<String> items;
  final bool isVideo;

  const _FullMediaListScreen({
    required this.title,
    required this.items,
    required this.isVideo,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.bluePrimaryDual,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: GridView.builder(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(12.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1,
        ),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                PageRouteBuilder(
                  transitionDuration: const Duration(milliseconds: 600),
                  pageBuilder: (_, __, ___) => _FullMediaView(
                    path: item,
                    title: title,
                    isVideo: isVideo,
                  ),
                ),
              );
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: isVideo
                  ? Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.network(
                          'https://via.placeholder.com/120x120?text=Video+Thumb',
                          fit: BoxFit.cover,
                        ),
                        const Center(
                          child: Icon(
                            Icons.play_circle_outline,
                            color: Colors.white,
                            size: 40,
                          ),
                        ),
                      ],
                    )
                  : Image.network(item, fit: BoxFit.cover),
            ),
          );
        },
      ),
    );
  }
}

class _FullMediaView extends StatefulWidget {
  final String path;
  final String title;
  final bool isVideo;

  const _FullMediaView({
    required this.path,
    required this.title,
    required this.isVideo,
  });

  @override
  State<_FullMediaView> createState() => _FullMediaViewState();
}

class _FullMediaViewState extends State<_FullMediaView> {
  VideoPlayerController? _controller;

  @override
  void initState() {
    super.initState();
    if (widget.isVideo) {
      _controller = VideoPlayerController.network(widget.path)
        ..initialize().then((_) {
          // Ensure the first frame is shown after initialization
          setState(() {});
          _controller!.play();
        });
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          widget.title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Center(
        child: widget.isVideo
            ? _controller != null && _controller!.value.isInitialized
                  ? AspectRatio(
                      aspectRatio: _controller!.value.aspectRatio,
                      child: VideoPlayer(_controller!),
                    )
                  : const CircularProgressIndicator()
            : InteractiveViewer(
                clipBehavior: Clip.none,
                child: Image.network(widget.path, fit: BoxFit.contain),
              ),
      ),
    );
  }
}

// Update the original GalleryScreen to navigate to SportDetailScreen instead of _FullImageView
// In the GestureDetector onTap:

// Navigator.push(
//   context,
//   PageRouteBuilder(
//     transitionDuration: const Duration(milliseconds: 600),
//     pageBuilder: (_, __, ___) => SportDetailScreen(
//       imagePath: item['image']!,
//       title: item['name']!,
//     ),
//   ),
// );

// Note: For better performance, consider adding 'cached_network_image' package for images.
// For video thumbnails, you can use a library like 'video_thumbnail' to generate thumbs from video URLs.
