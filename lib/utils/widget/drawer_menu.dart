import 'package:flutter/material.dart';
import 'package:sportspark/utils/const/const.dart';

class DrawerMenu extends StatelessWidget {
  const DrawerMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 8.0,
      child: Container(
        color: Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: AppColors.iconColor,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppColors.iconColor, AppColors.iconLightColor],
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.sports_soccer,
                      size: 40,
                      color: AppColors.iconColor,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'LearnFort Sports Park',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Your Sports Companion',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: Colors.white70),
                  ),
                ],
              ),
            ),
            _buildDrawerItem(
              context,
              icon: Icons.sports,
              title: 'Games List',
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/sport_game');
              },
            ),

            _buildDrawerItem(
              context,
              icon: Icons.book_online,
              title: 'Book Slot',
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(
                  context,
                  '/slot_booking',
                  arguments: 'General',
                );
              },
            ),
            _buildDrawerItem(
              context,
              icon: Icons.photo_library,
              title: 'Gallery',
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/gallery');
              },
            ),
            _buildDrawerItem(
              context,
              icon: Icons.contact_support,
              title: 'Contact Us',
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/contact');
              },
            ),
            _buildDrawerItem(
              context,
              icon: Icons.info_outline,
              title: 'About Us',
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/about_us');
              },
            ),
            const Divider(
              height: 1,
              thickness: 1,
              color: Color.fromARGB(255, 245, 245, 245),
            ),
            _buildDrawerItem(
              context,
              icon: Icons.admin_panel_settings,
              title: 'Admin Only',
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/admin');
              },
            ),
            _buildDrawerItem(
              context,
              icon: Icons.logout,
              title: 'Logout',
              color: AppColors.iconRed,
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, '/');
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? color,
  }) {
    return ListTile(
      leading: Icon(icon, color: color ?? AppColors.iconColor),
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.w600,
          color: color ?? AppColors.iconColor,
        ),
      ),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 24.0,
        vertical: 4.0,
      ),
      visualDensity: VisualDensity.compact,
    );
  }
}
