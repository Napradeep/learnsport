import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:sportspark/screens/full_media_view.dart';
import 'package:sportspark/screens/full_youtube_player.dart';
import 'package:sportspark/utils/const/const.dart';
import 'package:sportspark/utils/snackbar/snackbar.dart';
import 'package:sportspark/utils/widget/custom_confirmation_dialog.dart';

class FullMediaListScreen extends StatefulWidget {
  final String title;
  final List<Map<String, dynamic>> items;
  final bool isAdmin;
  final Function(List<Map<String, dynamic>>) onDelete;

  const FullMediaListScreen({
    super.key,
    required this.title,
    required this.items,
    required this.isAdmin,
    required this.onDelete,
  });

  @override
  State<FullMediaListScreen> createState() => _FullMediaListScreenState();
}

class _FullMediaListScreenState extends State<FullMediaListScreen> {
  final Set<int> _selected = {};

  // -------- YOUTUBE HELPERS ----------
  String? getYoutubeId(String url) {
    final regExp = RegExp(r"(?:v=|\/)([0-9A-Za-z_-]{11})");
    final match = regExp.firstMatch(url);
    return match?.group(1);
  }

  String? getYoutubeThumb(String url) {
    final id = getYoutubeId(url);
    return id != null
        ? "https://img.youtube.com/vi/$id/hqdefault.jpg"
        : null;
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
        iconTheme: const IconThemeData(color: Colors.white),

        actions: widget.isAdmin && _selected.isNotEmpty
            ? [
                PopupMenuButton(
                  icon: const Icon(Icons.more_vert, color: Colors.white),
                  itemBuilder: (_) => const [
                    PopupMenuItem(
                      value: "delete",
                      child: Row(
                        children: [
                          Icon(Icons.delete, color: Colors.red),
                          SizedBox(width: 8),
                          Text("Delete"),
                        ],
                      ),
                    ),
                  ],
                  onSelected: (value) {
                    if (value == "delete") {
                      CustomConfirmationDialog.show(
                        context: context,
                        title: "Delete Items!",
                        message:
                            "Are you sure you want to delete selected items?",
                        icon: Icons.delete_outline,
                        iconColor: Colors.red,
                        confirmColor: Colors.red,
                        onConfirm: () async {
                          final selectedItems = _selected
                              .map((i) => widget.items[i])
                              .toList();

                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            widget.onDelete(selectedItems);
                          });

                          Navigator.pop(context);
                          Navigator.pop(context);

                          Messenger.alertSuccess("Deleted Successfully");
                        },
                      );
                    }
                  },
                ),
              ]
            : null,
      ),

      body: GridView.builder(
        padding: const EdgeInsets.all(12),
        physics: const BouncingScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
        ),
        itemCount: widget.items.length,
        itemBuilder: (context, i) {
          final item = widget.items[i];
          final isVideo = item["type"] == "VIDEO";

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
                      items: widget.items,
                      initialIndex: i,
                      title: widget.title,
                      isAdmin: widget.isAdmin,
                      onDelete: () => widget.onDelete([item]),
                    ),
                  ),
                );
              }
            },

            onLongPress: () {
              if (!widget.isAdmin) return;
              setState(() {
                _selected.contains(i)
                    ? _selected.remove(i)
                    : _selected.add(i);
              });
            },

            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // ---------- VIDEO THUMBNAIL WITH PLAY ICON ----------
                  if (isVideo)
                    CachedNetworkImage(
                      imageUrl: getYoutubeThumb(item["url"]) ?? "",
                      fit: BoxFit.cover,
                      placeholder: (_, __) => Container(
                        color: Colors.black12,
                        child: const Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                      errorWidget: (_, __, ___) =>
                          const Icon(Icons.video_file, size: 40),
                    )
                  else
                    // ---------- IMAGE ----------
                    CachedNetworkImage(
                      imageUrl: item["url"],
                      fit: BoxFit.cover,
                      errorWidget: (_, __, ___) =>
                          const Icon(Icons.broken_image, size: 40),
                    ),

                  // PLAY ICON FOR VIDEO
                  if (isVideo)
                    const Positioned.fill(
                      child: Center(
                        child: Icon(Icons.play_circle_fill,
                            color: Colors.white, size: 42),
                      ),
                    ),

                  // ---------- SELECTION OVERLAY ----------
                  if (widget.isAdmin && _selected.contains(i))
                    Container(
                      color: Colors.black.withOpacity(0.4),
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
          );
        },
      ),
    );
  }
}
