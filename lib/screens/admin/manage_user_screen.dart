// manage_users_screen.dart
import 'package:flutter/material.dart';
import 'package:sportspark/utils/const/const.dart';

class ManageUsersScreen extends StatefulWidget {
  const ManageUsersScreen({super.key});

  @override
  State<ManageUsersScreen> createState() => _ManageUsersScreenState();
}

class _ManageUsersScreenState extends State<ManageUsersScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // Dummy data for users
  final List<Map<String, dynamic>> _dummyUsers = [
    {
      'id': 1,
      'name': 'John Doe',
      'email': 'john.doe@example.com',
      'mobile': '+91 9876543210',
      'status': 'Active',
      'role': 'User',
      'joined': '2025-01-15',
      'avatarUrl':
          'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=60&h=60&fit=crop',
    },
    {
      'id': 2,
      'name': 'Alice Smith',
      'email': 'alice.smith@example.com',
      'mobile': '+91 1234567890',
      'status': 'Inactive',
      'role': 'User',
      'joined': '2025-02-20',
      'avatarUrl':
          'https://images.unsplash.com/photo-1494790108755-2616b612b786?w=60&h=60&fit=crop',
    },
    {
      'id': 3,
      'name': 'Mike Johnson',
      'email': 'mike.j@example.com',
      'mobile': '+91 5556667777',
      'status': 'Active',
      'role': 'Admin',
      'joined': '2025-03-10',
      'avatarUrl':
          'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=60&h=60&fit=crop',
    },
    {
      'id': 4,
      'name': 'Emily Davis',
      'email': 'emily.davis@example.com',
      'mobile': '+91 4445556666',
      'status': 'Active',
      'role': 'User',
      'joined': '2025-04-05',
      'avatarUrl':
          'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=60&h=60&fit=crop',
    },
    {
      'id': 5,
      'name': 'David Wilson',
      'email': 'david.w@example.com',
      'mobile': '+91 7778889999',
      'status': 'Pending',
      'role': 'User',
      'joined': '2025-05-12',
      'avatarUrl':
          'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=60&h=60&fit=crop',
    },
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
        appBar: AppBar(
          title: const Text(
            'Manage Users',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh, color: Colors.white),
              onPressed: () {
                _controller.reset();
                _controller.forward();
              },
            ),
          ],
        ),
        body: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.all(16.0),
                  sliver: SliverToBoxAdapter(
                    child: Text(
                      'All Users',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.iconColor,
                      ),
                    ),
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final user = _dummyUsers[index];
                    final status = user['status'] as String;
                    Color statusColor = Colors.green;
                    if (status == 'Inactive') statusColor = Colors.orange;
                    if (status == 'Pending') statusColor = Colors.blue;
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 8.0,
                      ),
                      child: Card(
                        elevation: 6,
                        shadowColor: Colors.black.withOpacity(0.1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            radius: 25,
                            backgroundImage: NetworkImage(
                              user['avatarUrl'] as String,
                            ),
                            onBackgroundImageError: (_, __) =>
                                Icon(Icons.person, color: AppColors.iconColor),
                          ),
                          title: Text(
                            user['name'] as String,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: AppColors.iconColor,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                user['email'] as String,
                                style: TextStyle(
                                  color: AppColors.iconLightColor,
                                ),
                              ),
                              Text(
                                'Joined: ${user['joined']}',
                                style: TextStyle(
                                  color: AppColors.iconLightColor,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: statusColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  status,
                                  style: TextStyle(
                                    color: statusColor,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          trailing: PopupMenuButton<String>(
                            icon: const Icon(
                              Icons.more_vert,
                              color: AppColors.iconLightColor,
                            ),
                            onSelected: (value) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Action: $value for ${user['name']}',
                                  ),
                                ),
                              );
                            },
                            itemBuilder: (context) => [
                              const PopupMenuItem(
                                value: 'Edit',
                                child: Text('Edit'),
                              ),
                              const PopupMenuItem(
                                value: 'Block',
                                child: Text('Block'),
                              ),
                              const PopupMenuItem(
                                value: 'Delete',
                                child: Text('Delete'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }, childCount: _dummyUsers.length),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 100)),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('Add new user')));
          },
          backgroundColor: AppColors.bluePrimaryDual,
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }
}
