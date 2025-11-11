import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
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

class _SportsListState extends State<SportsList> {
  @override
  void initState() {
    super.initState();
    // Fetch API when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SportsProvider>().loadSports();
    });
  }

  IconData _getIcon(String game) {
    switch (game) {
      case 'Skating':
        return Icons.ice_skating;
      case 'Pickle Ball':
        return Icons.sports_tennis;
      case 'Basketball':
        return Icons.sports_basketball;
      case 'Kabaddi':
        return Icons.sports_kabaddi;
      case 'Football (Turf) 14,000 sqft':
        return Icons.sports_soccer;
      case 'Karate':
        return Icons.sports_martial_arts;
      case 'Volleyball':
        return Icons.sports_volleyball;
      case 'Athletic Track':
        return Icons.directions_run;
      case 'Cricket (Turf)':
      case 'Cricket (Net Practice)':
        return Icons.sports_cricket;
      case 'Archery':
        return Icons.architecture;
      case 'Badminton (Outdoor)':
        return Icons.sports;
      default:
        return Icons.sports;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.bluePrimaryDual,
          primary: AppColors.bluePrimaryDual,
          secondary: AppColors.iconLightColor,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.bluePrimaryDual,
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
        ),
      ),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          elevation: 4,
          shadowColor: Colors.black26,
          titleSpacing: 0,
          leading: Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: MyRouter.pop,
              tooltip: 'Back',
            ),
          ),
          centerTitle: false,
          title: const Text(
            'LearnFort Sports Park',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22,
              color: Colors.white,
              letterSpacing: 0.5,
            ),
          ),
        ),
        drawer: const DrawerMenu(isAdmin: 'user'),
        body: Consumer<SportsProvider>(
          builder: (context, provider, _) {
            if (provider.isLoading) {
              return const _ShimmerList();
            }

            if (provider.error != null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Error: ${provider.error}'),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: provider.retry,
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            if (provider.sports.isEmpty) {
              return const Center(child: Text('No sports available'));
            }

            return CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                  sliver: SliverToBoxAdapter(
                    child: Row(
                      children: [
                        const Icon(
                          Icons.sports_soccer,
                          color: AppColors.bluePrimaryDual,
                          size: 26,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Available Sport List',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Dynamic list from API
                SliverPadding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 15,
                  ),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final sport = provider.sports[index];
                      final name = sport['name'] ?? 'Unknown Sport';
                      final imageUrl = sport['imageUrl'];
                      final icon = _getIcon(name);

                      return Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: AppColors.cardBackground,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ListTile(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => SlotBookingScreen(
                                  turfName: name,
                                  sportsId: sport['_id'],
                                ),
                              ),
                            );
                          },
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(40),
                            child: Container(
                              width: 55,
                              height: 55,
                              color: AppColors.iconLightColor.withOpacity(0.15),
                              child: imageUrl != null && imageUrl.isNotEmpty
                                  ? CachedNetworkImage(
                                      imageUrl: imageUrl,
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) =>
                                          Shimmer.fromColors(
                                            baseColor: Colors.grey.shade300,
                                            highlightColor:
                                                Colors.grey.shade100,
                                            child: Container(
                                              color: Colors.white,
                                            ),
                                          ),
                                      errorWidget: (context, url, error) =>
                                          _buildErrorIcon(icon),
                                    )
                                  : _buildErrorIcon(icon),
                            ),
                          ),
                          title: Text(
                            name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          trailing: const Icon(
                            Icons.arrow_forward_ios,
                            size: 18,
                            color: AppColors.iconColor,
                          ),
                        ),
                      );
                    }, childCount: provider.sports.length),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 80)),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildErrorIcon(IconData icon) {
    return Center(
      child: Icon(
        icon,
        color: AppColors.bluePrimaryDual.withOpacity(0.7),
        size: 30,
      ),
    );
  }
}

class _ShimmerList extends StatelessWidget {
  const _ShimmerList();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 6,
      itemBuilder: (_, __) => Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Container(
          height: 70,
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }
}
