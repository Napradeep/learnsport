import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:sportspark/screens/slot_booking_screen.dart';
import 'package:sportspark/screens/sportslist/sports_provider.dart';
import 'package:sportspark/utils/const/const.dart';
import 'package:sportspark/utils/router/router.dart';
import 'package:sportspark/utils/widget/drawer_menu.dart';

class SportsList extends StatefulWidget {
  const SportsList({super.key});

  @override
  State<SportsList> createState() => _SportsListState();
}

class _SportsListState extends State<SportsList>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  // Icons
  static const Map<String, IconData> _sportIcons = {
    'skating': Icons.ice_skating,
    'pickle': Icons.sports_tennis,
    'basketball': Icons.sports_basketball,
    'kabaddi': Icons.sports_kabaddi,
    'football': Icons.sports_soccer,
    'karate': Icons.sports_martial_arts,
    'volleyball': Icons.sports_volleyball,
    'athletic': Icons.directions_run,
    'track': Icons.directions_run,
    'cricket': Icons.sports_cricket,
    'badminton': Icons.sports,
  };

  IconData _getIcon(String name) {
    final lower = name.toLowerCase();
    for (final entry in _sportIcons.entries) {
      if (lower.contains(entry.key)) return entry.value;
    }
    return Icons.sports_soccer;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<SportsProvider>();
      if (provider.sports.isEmpty) provider.loadSports();
    });
  }

  // ⛔ Dialog for unavailable sport
  void _showUnavailableDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Note!"),
        content: const Text(
          "This sport is currently under maintenance. Please try again later!.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Theme(
      data: Theme.of(context).copyWith(
        colorScheme: const ColorScheme.light(
          primary: AppColors.bluePrimaryDual,
          secondary: AppColors.iconLightColor,
        ),
      ),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: AppColors.bluePrimaryDual,
          foregroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: MyRouter.pop,
          ),
          title: const Text(
            'LearnFort Sports Park',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 21,
              letterSpacing: 0.5,
            ),
          ),
        ),
        drawer: const DrawerMenu(isAdmin: 'user'),
        body: Consumer<SportsProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading && provider.sports.isEmpty) {
              return const _FastShimmerList();
            }

            if (provider.error != null) {
              return _ErrorView(
                message: provider.error!,
                onRetry: provider.retry,
              );
            }

            if (provider.sports.isEmpty) {
              return const Center(
                child: Text(
                  'No sports available right now',
                  style: TextStyle(color: Colors.grey, fontSize: 18),
                ),
              );
            }

            return CustomScrollView(
              cacheExtent: 1000,
              physics: const BouncingScrollPhysics(),
              slivers: [
                const SliverToBoxAdapter(child: SizedBox(height: 12)),
                const SliverToBoxAdapter(child: SizedBox(height: 16)),

                // List
                SliverList.builder(
                  itemCount: provider.sports.length,
                  itemBuilder: (context, index) {
                    final sport = provider.sports[index];
                    final String id = sport['_id'] ?? '';
                    final String name = sport['name'] ?? 'Sport';
                    final String? img = sport['image'];
                    final String status = (sport['status'] ?? "AVAILABLE")
                        .toString();
                    final bool isUnavailable =
                        status.toUpperCase() == "NOT_AVAILABLE";

                    return _SportListItem(
                      key: ValueKey(id),
                      name: name,
                      imageUrl: img,
                      icon: _getIcon(name),
                      isUnavailable: isUnavailable,
                      onTap: () {
                        if (isUnavailable) {
                          _showUnavailableDialog();
                          return;
                        }

                        MyRouter.push(
                          screen: SlotBookingScreen(
                            sportsId: id,
                            turfName: name,
                            slotAmount:
                                sport['final_price_per_slot']?.toString() ??
                                '0',
                          ),
                        );
                      },
                    );
                  },
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 100)),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _SportListItem extends StatelessWidget {
  final String name;
  final String? imageUrl;
  final IconData icon;
  final bool isUnavailable;
  final VoidCallback onTap;

  const _SportListItem({
    required Key key,
    required this.name,
    required this.imageUrl,
    required this.icon,
    required this.isUnavailable,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: isUnavailable ? 0.45 : 1,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
              child: Row(
                children: [
                  // Image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Stack(
                      children: [
                        CachedNetworkImage(
                          imageUrl: imageUrl ?? "",
                          width: 64,
                          height: 64,
                          fit: BoxFit.cover,
                          placeholder: (_, __) => _ShimmerIcon(icon: icon),
                          errorWidget: (_, __, ___) => _ShimmerIcon(icon: icon),
                        ),
                        if (isUnavailable)
                          Positioned(
                            bottom: 4,
                            left: 4,
                            child: Container(
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: Colors.black54,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.lock,
                                size: 14,
                                color: Colors.white,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 16),

                  // Name
                  Expanded(
                    child: Text(
                      name,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 20,
                    color: AppColors.iconColor.withOpacity(0.7),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------- SHIMMER ------------------------
class _ShimmerIcon extends StatelessWidget {
  final IconData icon;
  const _ShimmerIcon({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Icon(
        icon,
        size: 32,
        color: AppColors.bluePrimaryDual.withOpacity(0.7),
      ),
    );
  }
}

class _FastShimmerList extends StatelessWidget {
  const _FastShimmerList();

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: 8,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (_, __) => Container(
        height: 90,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
        ),
        child: Row(
          children: [
            Container(
              width: 64,
              height: 64,
              margin: const EdgeInsets.all(12),
              color: Colors.grey.shade300,
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 16,
                    width: 180,
                    color: Colors.grey.shade300,
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: 14,
                    width: 120,
                    color: Colors.grey.shade200,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.wifi_off_rounded, size: 80, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              'Connection Failed',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Try Again'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.bluePrimaryDual,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
