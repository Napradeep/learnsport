import 'package:flutter/material.dart';
import 'package:sportspark/screens/slot_booking_screen.dart';
import 'package:sportspark/utils/const/const.dart';
import 'package:sportspark/utils/const/game_list.dart';
import 'package:sportspark/utils/router/router.dart';
import 'package:sportspark/utils/widget/drawer_menu.dart';

class SportsList extends StatelessWidget {
  const SportsList({super.key});

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
        return Icons.bookmark_outline;
      default:
        return Icons.sports;
    }
  }

  @override
  Widget build(BuildContext context) {
    final games = GameList.gameList;
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
          centerTitle: false,
          titleSpacing: 0,
          leading: Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                MyRouter.pop();
              },
              tooltip: 'Menu',
            ),
          ),

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
        drawer: const DrawerMenu(),
        body: CustomScrollView(
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
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final game = games[index];
                  final icon = _getIcon(game);
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
                            builder: (_) => SlotBookingScreen(turfName: game),
                          ),
                        );
                      },
                      leading: Container(
                        decoration: BoxDecoration(
                          color: AppColors.iconLightColor.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        padding: const EdgeInsets.all(10),
                        child: Icon(
                          icon,
                          color: AppColors.bluePrimaryDual,
                          size: 28,
                        ),
                      ),
                      title: Text(
                        game,
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
                }, childCount: games.length),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 80)),
          ],
        ),
      ),
    );
  }
}
