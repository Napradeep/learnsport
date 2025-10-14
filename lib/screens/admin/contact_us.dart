// contact_us_screen.dart
import 'package:flutter/material.dart';
import 'package:sportspark/utils/const/const.dart';

class ContactUsScreen extends StatefulWidget {
  const ContactUsScreen({super.key});

  @override
  State<ContactUsScreen> createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // Dummy data for contacts
  final List<Map<String, dynamic>> _dummyContacts = [
    {
      'id': 1,
      'name': 'Sarah Connor',
      'email': 'sarah@example.com',
      'subject': 'Booking Issue',
      'message': 'I have a problem with my recent booking...',
      'date': '2025-10-05',
      'status': 'Unread',
    },
    {
      'id': 2,
      'name': 'Tom Hardy',
      'email': 'tom@example.com',
      'subject': 'Feature Request',
      'message': 'Suggest new turf types...',
      'date': '2025-10-06',
      'status': 'Read',
    },
    {
      'id': 3,
      'name': 'Lisa Ray',
      'email': 'lisa@example.com',
      'subject': 'Payment Query',
      'message': 'Regarding refund process...',
      'date': '2025-10-07',
      'status': 'Unread',
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
            'Contact Us',
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
                      'Support Requests',
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
                    final contact = _dummyContacts[index];
                    final status = contact['status'] as String;
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
                        child: ExpansionTile(
                          leading: CircleAvatar(
                            backgroundColor: AppColors.bluePrimaryDual
                                .withOpacity(0.2),
                            child: Text(
                              contact['name'][0].toUpperCase(),
                              style: TextStyle(
                                color: AppColors.bluePrimaryDual,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          title: Text(
                            contact['subject'] as String,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: AppColors.iconColor,
                            ),
                          ),
                          subtitle: Text(
                            'From: ${contact['email']} • ${contact['date']}',
                            style: TextStyle(color: AppColors.iconLightColor),
                          ),
                          trailing: Chip(
                            label: Text(status),
                            backgroundColor: status == 'Unread'
                                ? Colors.red.withOpacity(0.2)
                                : Colors.green.withOpacity(0.2),
                            labelStyle: TextStyle(
                              color: status == 'Unread'
                                  ? Colors.red
                                  : Colors.green,
                            ),
                          ),
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(
                                contact['message'] as String,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.iconColor,
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Mark as Read'),
                                      ),
                                    );
                                  },
                                  child: const Text('Mark Read'),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Reply to ${contact['name']}',
                                        ),
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.bluePrimaryDual,
                                  ),
                                  child: const Text(
                                    'Reply',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  }, childCount: _dummyContacts.length),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 100)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
