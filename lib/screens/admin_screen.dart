import 'package:flutter/material.dart';
import 'package:sportspark/screens/admin/contact_us.dart';
import 'package:sportspark/screens/admin/manage_booking_screen.dart';
import 'package:sportspark/screens/admin/manage_sports.dart';
import 'package:sportspark/screens/admin/manage_user_screen.dart';
import 'package:sportspark/screens/admin/my_profile.dart';
import 'package:sportspark/screens/admin/setting.dart';
import 'package:sportspark/screens/gallery_screen.dart';
import 'package:sportspark/utils/const/const.dart';
import 'package:sportspark/utils/router/router.dart';
import 'package:sportspark/utils/widget/admin_card.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final adminCards = [
      AdminCardData(
        title: 'Manage Profile',
        icon: Icons.people_alt_outlined,
        color: Colors.red,

        onTap: () {
          MyRouter.push(screen: MyProfileScreen());
        },
      ),
      AdminCardData(
        title: 'Manage Bookings',
        icon: Icons.calendar_month_outlined,
        color: Colors.blueAccent,

        onTap: () {
          MyRouter.push(screen: const BookingHistoryScreen());
        },
      ),
      AdminCardData(
        title: 'Manage Users',
        icon: Icons.people_alt_outlined,
        color: Colors.orangeAccent,

        onTap: () {
          MyRouter.push(screen: const ManageUsersScreen());
        },
      ),
      AdminCardData(
        title: 'Contact Us',
        icon: Icons.contact_support,
        color: Colors.purpleAccent,

        onTap: () {
          MyRouter.push(screen: const ContactUsScreen());
        },
      ),
      AdminCardData(
        title: 'Manage Sport ',
        icon: Icons.sports,
        color: Colors.greenAccent,

        onTap: () {
          MyRouter.push(screen: const ManageSportsScreen());
        },
      ),
      AdminCardData(
        title: 'Manage Gallery',
        icon: Icons.photo_library,
        color: Colors.tealAccent,

        onTap: () {
          MyRouter.push(screen: GalleryScreen(isAdmin: true));
        },
      ),
      AdminCardData(
        title: 'Settings',
        icon: Icons.settings,
        color: Colors.redAccent,

        onTap: () {
          MyRouter.push(screen: const SettingsScreen());
        },
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 4,
        backgroundColor: AppColors.bluePrimaryDual,
        title: const Text(
          'Admin Dashboard',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Colors.white,
          ),
        ),
      ),
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.bluePrimaryDual.withOpacity(0.1), Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Welcome, Admin 👋',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.iconColor,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Manage all SportsPark activities from one place.',
                style: TextStyle(color: Colors.grey[700], fontSize: 15),
              ),
              const SizedBox(height: 20),

              // Dashboard Grid
              GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: MediaQuery.of(context).size.width > 600
                      ? 3
                      : 2,
                  childAspectRatio: 1.05,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                ),
                itemCount: adminCards.length,
                itemBuilder: (context, index) {
                  final item = adminCards[index];
                  return AdminDashboardCard(data: item);
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
