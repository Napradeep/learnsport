import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sportspark/screens/admin/add_gallery.dart';
import 'package:sportspark/screens/spoert_deatils_screen.dart';
import 'package:sportspark/utils/const/const.dart';
import 'package:sportspark/utils/router/router.dart';
import 'package:sportspark/screens/sportslist/sports_provider.dart';

class GalleryScreen extends StatefulWidget {
  final bool isAdmin;
  const GalleryScreen({super.key, required this.isAdmin});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  @override
  void initState() {
    print(widget.isAdmin);
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<SportsProvider>(context, listen: false).loadSports();
    });
  }

  // -----------------------------------
  // GET VALID ICON FOR EMPTY IMAGE
  // -----------------------------------
  IconData _getSportIcon(String name) {
    final text = name.toLowerCase();

    if (text.contains("cricket")) return Icons.sports_cricket;
    if (text.contains("football")) return Icons.sports_soccer;
    if (text.contains("volleyball")) return Icons.sports_volleyball;
    if (text.contains("basketball")) return Icons.sports_basketball;
    if (text.contains("kabaddi")) return Icons.sports_kabaddi;
    if (text.contains("karate")) return Icons.sports_martial_arts;
    if (text.contains("skating")) return Icons.sports;
    return Icons.sports;
  }

  // -----------------------------------
  // URL VALIDATOR (SUPER IMPORTANT)
  // -----------------------------------
  String getValidUrl(dynamic url) {
    if (url == null) return "";
    if (url is! String) return "";
    if (url.trim().isEmpty) return "";
    if (!url.startsWith("http")) return "";
    return url.trim();
  }

  // -----------------------------------
  // IMAGE BUILDER WITH SHIMMER + FALLBACK
  // -----------------------------------
  Widget _buildImage(String? url, String name) {
    final imageUrl = getValidUrl(url);

    if (imageUrl.isEmpty) return _fallbackIcon(name);

    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: BoxFit.cover,

      placeholder: (_, __) => Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(0),
          ),
        ),
      ),

      errorWidget: (_, __, ___) => _fallbackIcon(name),
    );
  }

  // -----------------------------------
  // FALLBACK ICON
  // -----------------------------------
  Widget _fallbackIcon(String name) {
    return Container(
      color: Colors.grey[200],
      child: Center(
        child: Icon(
          _getSportIcon(name),
          color: Colors.blueGrey.shade600,
          size: 60,
        ),
      ),
    );
  }

  // -----------------------------------
  // MAIN BUILD UI
  // -----------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
         centerTitle: false,
        foregroundColor: Colors.white,
        title: const Text(
          'Gallery',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppColors.bluePrimaryDual,
        elevation: 0,
      ),

      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Consumer<SportsProvider>(
          builder: (_, provider, __) {
            if (provider.isLoading) return _buildShimmerGrid();
            if (provider.error != null) return _buildError(provider);

            final sports = provider.sports;

            return GridView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: sports.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemBuilder: (_, index) {
                final sport = sports[index];
                final title = sport['name'] ?? "Sport";

                // SAFE URL SELECTION
                final bannerUrl = getValidUrl(sport['banner']);
                final imageUrl = getValidUrl(sport['image']);

                final finalImage = bannerUrl.isNotEmpty
                    ? bannerUrl
                    : (imageUrl.isNotEmpty ? imageUrl : "");

                final id = sport['_id'] ?? "";

                return GestureDetector(
                  onTap: () => _openDetail(title, finalImage, id),
                  child: Hero(
                    tag: "sport_$index",
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          _buildImage(finalImage, title),

                          // GRADIENT OVERLAY
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.black.withOpacity(0.1),
                                  Colors.black.withOpacity(0.7),
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                            ),
                          ),

                          // TITLE
                          Positioned(
                            bottom: 10,
                            left: 10,
                            child: Text(
                              title,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                shadows: [
                                  Shadow(
                                    blurRadius: 4,
                                    offset: Offset(1, 1),
                                    color: Colors.black54,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),

      floatingActionButton: widget.isAdmin
          ? FloatingActionButton(
              onPressed: () => MyRouter.push(screen: GalleryFormScreen()),
              backgroundColor: AppColors.bluePrimaryDual,
              child: const Icon(Icons.add, size: 28, color: Colors.white),
            )
          : null,
    );
  }

  // -----------------------------------
  // ERROR VIEW
  // -----------------------------------
  Widget _buildError(SportsProvider p) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(p.error!, style: const TextStyle(color: Colors.red)),
          const SizedBox(height: 12),
          ElevatedButton(onPressed: p.retry, child: const Text("Retry")),
        ],
      ),
    );
  }

  // -----------------------------------
  // GO TO DETAIL SCREEN
  // -----------------------------------
  void _openDetail(String title, String? image, String sportId) {
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (_, __, ___) => SportDetailScreen(
          isAdmin: widget.isAdmin,
          imagePath: image ?? "",
          title: title,
          sportId: sportId,
        ),
      ),
    );
  }
}

// -----------------------------------
// SHIMMER GRID
// -----------------------------------
Widget _buildShimmerGrid() {
  return GridView.builder(
    physics: const BouncingScrollPhysics(),
    itemCount: 6,
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
    ),
    itemBuilder: (_, index) {
      return Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      );
    },
  );
}
