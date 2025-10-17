import 'package:flutter/material.dart';
import 'package:sportspark/screens/admin/add_sports.dart';
import 'package:sportspark/screens/admin/contact_us.dart';
import 'package:sportspark/screens/admin/manage_booking_screen.dart';
import 'package:sportspark/screens/admin/manage_user_screen.dart';
import 'package:sportspark/screens/admin/setting.dart';
import 'package:sportspark/utils/const/const.dart';
import 'package:sportspark/utils/router/router.dart';
import 'package:sportspark/utils/widget/admin_card.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final adminCards = [
      AdminCardData(
        title: 'Manage Bookings',
        icon: Icons.calendar_month_outlined,
        color: Colors.blueAccent,
        // description: 'View and control all sports ground bookings.',
        onTap: () {
          MyRouter.push(screen: const BookingHistoryScreen());
        },
      ),
      AdminCardData(
        title: 'Manage Users',
        icon: Icons.people_alt_outlined,
        color: Colors.orangeAccent,
        // description: 'View, block, or update user profiles.',
        onTap: () {
          MyRouter.push(screen: const ManageUsersScreen());
        },
      ),
      AdminCardData(
        title: 'Contact Us',
        icon: Icons.contact_support,
        color: Colors.purpleAccent,
        // description: 'Manage incoming support requests and messages.',
        onTap: () {
          MyRouter.push(screen: const ContactUsScreen());
        },
      ),
      AdminCardData(
        title: 'Add Sport ',
        icon: Icons.sports,
        color: Colors.greenAccent,
        //description: 'Add or update the list of available sports.',
        onTap: () {
          MyRouter.push(screen: const AddEditSportScreen());
        },
      ),
      AdminCardData(
        title: 'Add Gallery',
        icon: Icons.photo_library,
        color: Colors.tealAccent,
        // description: 'Upload and manage images for the gallery.',
        onTap: () {
          MyRouter.push(screen: const UploadGalleryScreen());
        },
      ),
      AdminCardData(
        title: 'Settings',
        icon: Icons.settings,
        color: Colors.redAccent,
        ////// description: 'Customize system preferences and access controls.',
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

class UploadGalleryScreen extends StatelessWidget {
  const UploadGalleryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Upload Gallery')),
      body: const Center(child: Text('Upload Gallery Screen')),
    );
  }
}
