import 'package:flutter/material.dart';
import 'package:sportspark/screens/sports_list.dart';
import 'package:sportspark/utils/const/const.dart';
import 'package:sportspark/utils/router/router.dart';
import 'package:sportspark/utils/widget/privacy_policy.dart';

class DrawerMenu extends StatelessWidget {
  final String isAdmin;
  const DrawerMenu({super.key, required this.isAdmin});

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
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: Image.asset("assets/applogo.png"),
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
                    'an unit of Eshvar Edu Foundation',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: Colors.white70),
                  ),
                ],
              ),
            ),

            /// ============ MENU ITEMS ============
            _buildDrawerItem(
              context,
              icon: Icons.sports,
              title: 'Our Sports List',
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
                MyRouter.push(screen: const SportsList());
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
              icon: Icons.privacy_tip_outlined,
              title: 'Privacy Policy ',
              onTap: () {
                Navigator.pop(context);
                MyRouter.push(screen: PrivacyPolicyScreen());
              },
            ),
            //PrivacyPolicyScreen
            _buildDrawerItem(
              context,
              icon: Icons.info_outline,
              title: 'About Us',
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/about_us');
              },
            ),

            // isAdmin == "USER"
            //     ? _buildDrawerItem(
            //         context,
            //         icon: Icons.admin_panel_settings,
            //         title: 'User Dashborad',
            //         onTap: () {
            //           Navigator.pop(context);
            //           Navigator.pushNamed(context, '/admin');
            //         },
            //       )
            //     : isAdmin == "ADMIN"
            //     ? _buildDrawerItem(
            //         context,
            //         icon: Icons.admin_panel_settings,
            //         title: 'Admin Dashborad',
            //         onTap: () {
            //           Navigator.pop(context);
            //           Navigator.pushNamed(context, '/admin');
            //         },
            //       )
            //     : _buildDrawerItem(
            //         context,
            //         icon: Icons.admin_panel_settings,
            //         title: 'User Dashborad',
            //         onTap: () {
            //           Navigator.pop(context);
            //           Navigator.pushNamed(context, '/admin');
            //         },
            //       ),
            // const Divider(
            //   height: 1,
            //   thickness: 1,
            //   color: Color.fromARGB(255, 245, 245, 245),
            // ),

            /// LOGOUT
            // _buildDrawerItem(
            //   context,
            //   icon: Icons.logout,
            //   title: 'Logout',
            //   color: AppColors.iconRed,
            //   onTap: () async {
            //     final authProvider = Provider.of<AuthProvider>(
            //       context,
            //       listen: false,
            //     );

            //     await authProvider.logout(context);
            //     MyRouter.pushRemoveUntil(screen: const LoginScreen());
            //   },
            // ),
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
