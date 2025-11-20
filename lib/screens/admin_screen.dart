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
import 'package:sportspark/utils/shared/shared_pref.dart';
import 'package:sportspark/utils/widget/admin_card.dart';

class AdminScreen extends StatefulWidget {
  final String? heading;

  const AdminScreen({super.key, this.heading});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  String? userName;
  String? profilePicUrl;
  String? gmail;
  final searchController = TextEditingController();

  String selectedFilter = 'All';

  Future<void> _loadUserData() async {
    final user = await UserPreferences.getUser();

    if (mounted) {
      setState(() {
        userName = user?.name;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Widget build(BuildContext context) {
    // ✅ Default to USER if heading is null, empty, or unrecognized
    final role = (widget.heading ?? '').trim().toUpperCase();
    final userRole = ['ADMIN', 'SUPER_ADMIN'].contains(role) ? role : 'USER';

    print("Current Role: $userRole");

    // ✅ Define dashboard cards dynamically based on userRole
    final List<AdminCardData> adminCards = [
      AdminCardData(
        title: 'My Profile',
        icon: Icons.people_alt_outlined,
        color: Colors.red,
        onTap: () => MyRouter.push(screen: MyProfileScreen(checkrole: userRole,)),
      ),
      AdminCardData(
        title: 'Manage Bookings',
        icon: Icons.calendar_month_outlined,
        color: Colors.blueAccent,
        onTap: () => MyRouter.push(screen: const BookingHistoryScreen()),
      ),
      AdminCardData(
        title: 'Contact Us',
        icon: Icons.contact_support,
        color: Colors.purpleAccent,
        onTap: () => MyRouter.push(screen: ContactUsScreen(role: userRole)),
      ),
      if (userRole != "USER") ...[
        AdminCardData(
          title: 'Manage Users',
          icon: Icons.people_alt_outlined,
          color: Colors.orangeAccent,
          onTap: () => MyRouter.push(screen:  ManageUsersScreen()),
        ),

        AdminCardData(
          title: 'Manage Sports',
          icon: Icons.sports,
          color: Colors.greenAccent,
          onTap: () => MyRouter.push(screen: const ManageSportsScreen()),
        ),
        AdminCardData(
          title: 'Manage Gallery',
          icon: Icons.photo_library,
          color: Colors.tealAccent,
          onTap: () => MyRouter.push(screen: GalleryScreen(isAdmin: true)),
        ),
      ],
      AdminCardData(
        title: 'Settings',
        icon: Icons.settings,
        color: Colors.redAccent,
        onTap: () => MyRouter.push(screen: const SettingsScreen()),
      ),
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
         centerTitle: false,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 4,
        backgroundColor: AppColors.bluePrimaryDual,
        title: Text(
          userRole == "ADMIN"
              ? 'Admin Dashboard'
              : userRole == "SUPER_ADMIN"
              ? 'Super Admin Dashboard'
              : 'User Dashboard',
          style: const TextStyle(
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
              Text(
                "Welcome, $userName 👋",
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.iconColor,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Manage your all activities in one place.',
                style: TextStyle(color: Colors.grey[700], fontSize: 15),
              ),
              const SizedBox(height: 20),

              // ✅ Grid of Dashboard Cards
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
                  return AdminDashboardCard(data: adminCards[index]);
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
