import 'package:flutter/material.dart';
import 'package:sportspark/utils/widget/custom_confirmation_dialog.dart';
import 'package:video_player/video_player.dart';
import 'package:sportspark/utils/const/const.dart';
import 'package:sportspark/utils/snackbar/snackbar.dart';

final Map<String, List<String>> _imageData = {
  '05/10/2025': [
    'https://pbs.twimg.com/media/G2iRFXnXMAA5gG4.jpg',
    'https://pbs.twimg.com/media/G2iRCh4aUAAUrr_.jpg',
    'https://pbs.twimg.com/media/G2iQxHLa0AAr6hh.jpg',
    'https://pbs.twimg.com/media/G2iQ99KW8AA4yHp.jpg',
    'https://pbs.twimg.com/media/G2iQ3wsWMAAM8Ca.jpg',
  ],
  '04/10/2025': [
    'https://pbs.twimg.com/media/G2dHem3XwAAP2eD.jpg',
    'https://pbs.twimg.com/media/G2dHRH4WYAAhp2I.jpg',
    'https://pbs.twimg.com/media/G2dHeOTXgAA4VwL.jpg',
    'https://pbs.twimg.com/media/G2dHeXZWQAApKSS.jpg',
    'https://pbs.twimg.com/media/G2iRFXnXMAA5gG4.jpg',
  ],
};

final Map<String, List<String>> _videoData = {
  '05/10/2025': [
    'https://video.twimg.com/amplify_video/1974987840749551616/vid/avc1/584x270/HQSeTb04EdBEWsl0.mp4',
    'https://video.twimg.com/amplify_video/1974987732007960576/vid/avc1/582x270/eeCuZZC0cM7fleV4.mp4',
    'https://video.twimg.com/amplify_video/1974987406454493184/vid/avc1/320x568/N4kBf4ri9QufGKmy.mp4',
    'https://video.twimg.com/amplify_video/1974986799802966016/vid/avc1/320x446/vq8WGwyVWgzfg1l3.mp4',
  ],
  '04/10/2025': [
    'https://video.twimg.com/amplify_video/1974625404334813184/vid/avc1/320x568/v9LCe9GjCbYwxkdM.mp4',
    'https://video.twimg.com/amplify_video/1974624883272216576/vid/avc1/320x568/gSyvYXMoyctJ_Blk.mp4',
    'https://video.twimg.com/amplify_video/1974622938667143168/vid/avc1/480x270/li6OjqwDOq3TkyPF.mp4',
  ],
};

class SportDetailScreen extends StatefulWidget {
  final String title;
  final String imagePath;
  final bool isAdmin;

  const SportDetailScreen({
    super.key,
    required this.title,
    required this.imagePath,
    this.isAdmin = false,
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

  Future<void> _deleteMedia(
    String date,
    List<String> items,
    bool isVideo,
  ) async {
    final dataMap = isVideo ? _videoData : _imageData;
    for (var item in items) {
      dataMap[date]!.remove(item);
    }
    if (dataMap[date]!.isEmpty) dataMap.remove(date);
    setState(() {});
    Messenger.alertSuccess("Selected media deleted successfully");
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
              unselectedLabelColor: Colors.white70,
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
      ..sort((a, b) => _parseDate(b).compareTo(_parseDate(a)));

    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(12),
      itemCount: dates.length,
      itemBuilder: (context, index) {
        final date = dates[index];
        final items = data[date]!;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDateHeader(date, items, isVideo),
            const SizedBox(height: 8),
            SizedBox(
              height: 120,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: items.length > 4 ? 4 : items.length,
                itemBuilder: (context, idx) =>
                    _buildThumbnail(items[idx], items, idx, date, isVideo),
              ),
            ),
            const SizedBox(height: 16),
          ],
        );
      },
    );
  }

  Widget _buildDateHeader(String date, List<String> items, bool isVideo) {
    return Row(
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
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => _FullMediaListScreen(
                  title: '$date - ${isVideo ? 'Videos' : 'Images'}',
                  items: items,
                  isVideo: isVideo,
                  isAdmin: widget.isAdmin,
                  onDelete: (selectedItems) =>
                      _deleteMedia(date, selectedItems, isVideo),
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
    );
  }

  Widget _buildThumbnail(
    String item,
    List<String> items,
    int idx,
    String date,
    bool isVideo,
  ) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 400),
          pageBuilder: (_, __, ___) => _FullMediaView(
            items: items,
            initialIndex: idx,
            title: '${widget.title} - $date',
            isVideo: isVideo,
            isAdmin: widget.isAdmin,
            onDelete: () => _deleteMedia(date, [item], isVideo),
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(right: 8),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: SizedBox(
            width: 120,
            child: Stack(
              fit: StackFit.expand,
              children: [
                isVideo
                    ? Stack(
                        fit: StackFit.expand,
                        children: [
                          Container(color: Colors.black26),
                          const Center(
                            child: Icon(
                              Icons.play_circle_fill,
                              color: Colors.white,
                              size: 50,
                            ),
                          ),
                        ],
                      )
                    : Image.network(
                        item,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            color: Colors.grey.shade300,
                            child: const Center(
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                color: Colors.blueAccent,
                              ),
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: Colors.grey.shade200,
                          child: const Icon(
                            Icons.broken_image,
                            color: Colors.grey,
                            size: 40,
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  DateTime _parseDate(String dateStr) {
    final p = dateStr.split('/');
    return DateTime(int.parse(p[2]), int.parse(p[1]), int.parse(p[0]));
  }
}

class _FullMediaListScreen extends StatefulWidget {
  final String title;
  final List<String> items;
  final bool isVideo;
  final bool isAdmin;
  final Function(List<String>) onDelete;

  const _FullMediaListScreen({
    required this.title,
    required this.items,
    required this.isVideo,
    required this.isAdmin,
    required this.onDelete,
  });

  @override
  State<_FullMediaListScreen> createState() => _FullMediaListScreenState();
}

class _FullMediaListScreenState extends State<_FullMediaListScreen> {
  final Set<int> _selectedIndices = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          widget.title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.bluePrimaryDual,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: widget.isAdmin && _selectedIndices.isNotEmpty
            ? [
                PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'delete') {
                      CustomConfirmationDialog.show(
                        context: context,
                        title: 'Delete Items',
                        message:
                            'Are you sure you want to delete the selected items?',
                        icon: Icons.delete_outline,
                        iconColor: Colors.red,
                        backgroundColor: Colors.white,
                        textColor: Colors.black87,
                        confirmColor: Colors.red,
                        onConfirm: () {
                          final selectedItems = _selectedIndices
                              .map((i) => widget.items[i])
                              .toList();
                          widget.onDelete(selectedItems);
                          Navigator.pop(context);
                          Messenger.alertSuccess(
                            'Selected items deleted successfully',
                          );
                        },
                      );
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete, size: 18, color: Colors.red),
                          SizedBox(width: 8),
                          Text('Delete'),
                        ],
                      ),
                    ),
                  ],
                  icon: const Icon(Icons.more_vert, color: Colors.white),
                ),

                // IconButton(
                //   icon: const Icon(Icons.delete, color: Colors.red),
                //   onPressed: () {
                //     CustomConfirmationDialog.show(
                //       context: context,
                //       title: 'Delete Items',
                //       message:
                //           'Are you sure you want to delete the selected items?',
                //       icon: Icons.delete_outline,
                //       iconColor: Colors.red,
                //       backgroundColor: Colors.white,
                //       textColor: Colors.black87,
                //       confirmColor: Colors.red,
                //       onConfirm: () {
                //         final selectedItems = _selectedIndices
                //             .map((i) => widget.items[i])
                //             .toList();
                //         widget.onDelete(selectedItems);
                //         Navigator.pop(context);
                //         Messenger.alertSuccess(
                //           'Selected items deleted successfully',
                //         );
                //       },
                //     );
                //   },
                // ),
              ]
            : null,
      ),
      body: GridView.builder(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(12),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: widget.items.length,
        itemBuilder: (context, i) => GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => _FullMediaView(
                items: widget.items,
                initialIndex: i,
                title: widget.title,
                isVideo: widget.isVideo,
                isAdmin: widget.isAdmin,
                onDelete: () => widget.onDelete([widget.items[i]]),
              ),
            ),
          ),
          onLongPress: () {
            if (widget.isAdmin) {
              setState(() {
                if (_selectedIndices.contains(i)) {
                  _selectedIndices.remove(i);
                } else {
                  _selectedIndices.add(i);
                }
              });
            }
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Stack(
              fit: StackFit.expand,
              children: [
                widget.isVideo
                    ? Stack(
                        fit: StackFit.expand,
                        children: [
                          Container(color: Colors.black26),
                          const Center(
                            child: Icon(
                              Icons.play_circle_fill,
                              color: Colors.white,
                              size: 50,
                            ),
                          ),
                        ],
                      )
                    : Image.network(
                        widget.items[i],
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            color: Colors.grey.shade300,
                            child: const Center(
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                color: Colors.blueAccent,
                              ),
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: Colors.grey.shade200,
                          child: const Icon(
                            Icons.broken_image,
                            color: Colors.grey,
                            size: 40,
                          ),
                        ),
                      ),
                if (widget.isAdmin && _selectedIndices.contains(i))
                  Container(
                    color: Colors.black.withOpacity(0.3),
                    child: const Center(
                      child: Icon(
                        Icons.check_circle,
                        color: Colors.blue,
                        size: 40,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FullMediaView extends StatefulWidget {
  final List<String> items;
  final int initialIndex;
  final String title;
  final bool isVideo;
  final bool isAdmin;
  final VoidCallback onDelete;

  const _FullMediaView({
    required this.items,
    required this.initialIndex,
    required this.title,
    required this.isVideo,
    required this.isAdmin,
    required this.onDelete,
  });

  @override
  State<_FullMediaView> createState() => _FullMediaViewState();
}

class _FullMediaViewState extends State<_FullMediaView> {
  late PageController _pageController;
  VideoPlayerController? _videoController;
  int _currentIndex = 0;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: _currentIndex);
    if (widget.isVideo) _initializeVideo(widget.items[_currentIndex]);
  }

  Future<void> _initializeVideo(String url) async {
    setState(() => _isLoading = true);
    _videoController?.dispose();
    _videoController = VideoPlayerController.networkUrl(Uri.parse(url));
    await _videoController!.initialize();
    _videoController!.play();
    setState(() => _isLoading = false);
  }

  @override
  void dispose() {
    _videoController?.dispose();
    _pageController.dispose();
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
          '${widget.title} (${_currentIndex + 1}/${widget.items.length})',
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
        //         ),
        //       ]
        //     : null,
      ),
      body: PageView.builder(
        controller: _pageController,
        itemCount: widget.items.length,
        onPageChanged: (i) {
          setState(() => _currentIndex = i);
          if (widget.isVideo) _initializeVideo(widget.items[i]);
        },
        itemBuilder: (context, i) {
          final item = widget.items[i];
          if (widget.isVideo) {
            if (_isLoading) {
              return const Center(
                child: CircularProgressIndicator(color: Colors.white),
              );
            }
            return Stack(
              alignment: Alignment.center,
              children: [
                AspectRatio(
                  aspectRatio: _videoController!.value.aspectRatio,
                  child: VideoPlayer(_videoController!),
                ),
                Positioned(
                  bottom: 30,
                  left: 0,
                  right: 0,
                  child: VideoProgressIndicator(
                    _videoController!,
                    allowScrubbing: true,
                    colors: const VideoProgressColors(
                      playedColor: Colors.blue,
                      bufferedColor: Colors.blueGrey,
                      backgroundColor: Colors.grey,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _videoController!.value.isPlaying
                          ? _videoController!.pause()
                          : _videoController!.play();
                    });
                  },
                  child: Icon(
                    _videoController!.value.isPlaying
                        ? Icons.pause_circle
                        : Icons.play_circle_fill,
                    color: Colors.white,
                    size: 70,
                  ),
                ),
              ],
            );
          } else {
            return InteractiveViewer(
              child: Image.network(
                item,
                fit: BoxFit.contain,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  );
                },
                errorBuilder: (context, error, stackTrace) => const Center(
                  child: Icon(Icons.broken_image, color: Colors.grey, size: 80),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
