import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:sportspark/screens/common_provider/gallery_provider.dart';
import 'package:sportspark/screens/full_media.dart';
import 'package:sportspark/screens/full_media_view.dart';
import 'package:sportspark/screens/full_youtube_player.dart';
import 'package:sportspark/utils/const/const.dart';
import 'package:sportspark/utils/snackbar/snackbar.dart';
import 'package:sportspark/utils/widget/custom_confirmation_dialog.dart';

class SportDetailScreen extends StatefulWidget {
  final String title;
  final String imagePath;
  final String sportId;
  final bool isAdmin;

  const SportDetailScreen({
    super.key,
    required this.title,
    required this.imagePath,
    required this.sportId,
    this.isAdmin = false,
  });

  @override
  State<SportDetailScreen> createState() => _SportDetailScreenState();
}

class _SportDetailScreenState extends State<SportDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late GalleryProvider _provider;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<GalleryProvider>(context, listen: false);
      provider.loadGallery(widget.sportId).then((_) {
        _precacheImages(provider.gallery);
      });
    });

    _provider = Provider.of<GalleryProvider>(context, listen: false);
  }

  Future<void> _precacheImages(List gallery) async {
    for (var item in gallery) {
      if (item["type"] == "IMAGE") {
        precacheImage(CachedNetworkImageProvider(item["url"]), context);
      }
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // ---------- YOUTUBE HELPERS ----------
  String? getYoutubeId(String url) {
    final regExp = RegExp(r"(?:v=|\/)([0-9A-Za-z_-]{11})");
    final match = regExp.firstMatch(url);
    return match?.group(1);
  }

  String? getYoutubeThumbnail(String url) {
    final id = getYoutubeId(url);
    return id != null ? "https://img.youtube.com/vi/$id/hqdefault.jpg" : null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
         centerTitle: false,
        foregroundColor: Colors.white,
        title: Text(widget.title, style: const TextStyle(color: Colors.white)),
        backgroundColor: AppColors.bluePrimaryDual,
      ),

      body: Consumer<GalleryProvider>(
        builder: (_, gallery, __) {
          if (gallery.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          final images = gallery.gallery
              .where((g) => g["type"] == "IMAGE")
              .toList();
          final videos = gallery.gallery
              .where((g) => g["type"] == "VIDEO")
              .toList();

          return Column(
            children: [
              Container(
                color: AppColors.bluePrimaryDual,
                child: TabBar(
                  controller: _tabController,
                  indicatorColor: Colors.white,
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.white70,
                  tabs: const [
                    Tab(text: "Images"),
                    Tab(text: "Videos"),
                  ],
                ),
              ),

              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildMediaList(images, false, widget.isAdmin),
                    _buildMediaList(videos, true, widget.isAdmin),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // -------- GROUP BY DATE --------
  Map<String, List<Map<String, dynamic>>> _groupByDate(List items) {
    final Map<String, List<Map<String, dynamic>>> map = {};

    for (var item in items) {
      final date = DateFormat(
        "dd/MM/yyyy",
      ).format(DateTime.parse(item["createdAt"]));
      map.putIfAbsent(date, () => []);
      map[date]!.add(item);
    }

    return map;
  }

  // -------- MAIN MEDIA LIST --------
  Widget _buildMediaList(List items, bool isVideo, bool isAdmin) {
    print(isAdmin);
    if (items.isEmpty) {
      return const Center(child: Text("No media available"));
    }

    final grouped = _groupByDate(items);
    final dates = grouped.keys.toList()
      ..sort((b, a) => _parseDate(a).compareTo(_parseDate(b)));

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: dates.length,
      itemBuilder: (_, i) {
        final date = dates[i];
        final dayItems = grouped[date]!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // -------- HEADER WITH MENU --------
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  date,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                PopupMenuButton(
                  icon: const Icon(Icons.more_vert, color: Colors.black87),
                  onSelected: (value) async {
                    // VIEW ALL
                    if (value == "view_all") {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => FullMediaListScreen(
                            title: "$date • ${isVideo ? 'Videos' : 'Images'}",
                            items: dayItems.cast<Map<String, dynamic>>(),
                            isAdmin: widget.isAdmin,
                            onDelete: (selected) {
                              for (var item in selected) {
                                _provider.deleteItem(item["_id"]);
                              }
                            },
                          ),
                        ),
                      );
                      return;
                    }

                    // DELETE ALL — USING YOUR CUSTOM DIALOG
                    if (value == "delete_all") {
                      CustomConfirmationDialog.show(
                        context: context,
                        title: "Delete Items!",
                        message:
                            "Are you sure you want to delete all items for this date?",
                        icon: Icons.delete_outline,
                        iconColor: Colors.red,
                        confirmColor: Colors.red,
                        onConfirm: () async {
                          for (var item in dayItems) {
                            _provider.deleteItem(item["_id"]);
                          }

                          Navigator.pop(context); // close dialog
                          Messenger.alertSuccess("Deleted Successfully");
                        },
                      );
                    }
                  },
                  itemBuilder: (_) => [
                    PopupMenuItem(
                      value: "view_all",
                      child: Row(
                        children: [
                          Icon(Icons.view_comfy, size: 18),
                          SizedBox(width: 8),
                          Text("View "),
                        ],
                      ),
                    ),
                    if (widget.isAdmin)
                      PopupMenuItem(
                        value: "delete_all",
                        child: Row(
                          children: const [
                            Icon(Icons.delete, size: 18, color: Colors.red),
                            SizedBox(width: 8),
                            Text(
                              "Delete All",
                              style: TextStyle(color: Colors.red),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 10),

            // -------- HORIZONTAL THUMBNAILS --------
            SizedBox(
              height: 120,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: dayItems.length > 4 ? 4 : dayItems.length,
                itemBuilder: (_, index) =>
                    _thumbnail(dayItems[index], dayItems, index, date, isVideo),
              ),
            ),

            const SizedBox(height: 18),
          ],
        );
      },
    );
  }

  // -------- THUMBNAIL COMPONENT --------
  Widget _thumbnail(
    Map<String, dynamic> item,
    List items,
    int index,
    String date,
    bool isVideo,
  ) {
    return GestureDetector(
      onTap: () {
        if (isVideo) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => FullYoutubePlayer(url: item["url"]),
            ),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => FullMediaView(
                items: items.cast<Map<String, dynamic>>(),
                initialIndex: index,
                title: "${widget.title} - $date",
                isAdmin: widget.isAdmin,
                onDelete: () => _provider.deleteItem(item["_id"]),
              ),
            ),
          );
        }
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 8),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: SizedBox(
            width: 120,
            child: Stack(
              fit: StackFit.expand,
              children: [
                // IMAGE / VIDEO THUMB
                isVideo
                    ? CachedNetworkImage(
                        imageUrl: getYoutubeThumbnail(item["url"]) ?? "",
                        fit: BoxFit.cover,
                        placeholder: (_, __) => Container(
                          color: Colors.black12,
                          child: const Center(
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        ),
                        errorWidget: (_, __, ___) =>
                            const Icon(Icons.video_file),
                      )
                    : CachedNetworkImage(
                        imageUrl: item["url"],
                        fit: BoxFit.cover,
                        placeholder: (_, __) =>
                            Container(color: Colors.grey.shade300),
                        errorWidget: (_, __, ___) =>
                            const Icon(Icons.broken_image, color: Colors.grey),
                      ),

                // PLAY ICON FOR VIDEO
                if (isVideo)
                  const Positioned.fill(
                    child: Center(
                      child: Icon(
                        Icons.play_circle_fill,
                        size: 42,
                        color: Colors.white,
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

  DateTime _parseDate(String date) {
    final d = date.split("/");
    return DateTime(int.parse(d[2]), int.parse(d[1]), int.parse(d[0]));
  }
}
