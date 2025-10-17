import 'package:flutter/material.dart';
import 'package:sportspark/utils/const/const.dart';

class ContactUsScreen extends StatefulWidget {
  const ContactUsScreen({super.key});

  @override
  State<ContactUsScreen> createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final List<Map<String, dynamic>> _dummyContacts = [
    {
      'id': 1,
      'name': 'Sarah Connor',
      'subject': 'Booking Issue',
      'message': 'I have a problem with my recent booking...',
      'date': '2025-10-05',
      'status': 'Unread',
    },
    {
      'id': 2,
      'name': 'Tom Hardy',
      'subject': 'Feature Request',
      'message': 'Suggest new turf types...',
      'date': '2025-10-06',
      'status': 'Read',
    },
    {
      'id': 3,
      'name': 'Lisa Ray',
      'subject': 'Payment Query',
      'message': 'Regarding refund process...',
      'date': '2025-10-07',
      'status': 'Unread',
    },
    {
      'id': 4,
      'name': 'John Doe',
      'subject': 'Account Issue',
      'message': 'I am unable to login...',
      'date': '2025-10-08',
      'status': 'Read',
    },
    {
      'id': 6,
      'name': 'John Doe',
      'subject': 'Account Issue',
      'message': 'I am unable to login...',
      'date': '2025-10-08',
      'status': 'Read',
    },
    {
      'id': 4,
      'name': 'John Doe',
      'subject': 'Account Issue',
      'message': 'I am unable to login...',
      'date': '2025-10-08',
      'status': 'UnRead',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
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
    _tabController.dispose();
    _controller.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get pendingMessages => _dummyContacts
      .where((c) => c['status'].toLowerCase() == 'unread')
      .toList();

  List<Map<String, dynamic>> get completedMessages =>
      _dummyContacts.where((c) => c['status'].toLowerCase() == 'read').toList();

  // ✅ Professional Reply Bottom Sheet
  void _showReplySheet(Map<String, dynamic> contact) {
    final TextEditingController _replyController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: AppColors.bluePrimaryDual.withOpacity(0.2),
                    child: Text(
                      contact['name'][0].toUpperCase(),
                      style: TextStyle(
                        color: AppColors.bluePrimaryDual,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      "Reply to ${contact['name']}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.grey),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                "Subject: ${contact['subject']}",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.iconColor,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _replyController,
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: "Type your reply...",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: AppColors.bluePrimaryDual,
                      width: 1.5,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    final reply = _replyController.text.trim();
                    if (reply.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Please type a reply")),
                      );
                      return;
                    }
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Reply sent to ${contact['name']} successfully',
                        ),
                        backgroundColor: Colors.green,
                      ),
                    );
                    setState(() {
                      contact['status'] = 'Read';
                    });
                  },
                  icon: const Icon(Icons.send, color: Colors.white),
                  label: const Text(
                    "Send Reply",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.bluePrimaryDual,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }

  Widget buildMessageCard(Map<String, dynamic> contact) {
    final status = contact['status'] as String;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Card(
        elevation: 4,
        shadowColor: Colors.black.withOpacity(0.1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: ExpansionTile(
          leading: CircleAvatar(
            backgroundColor: AppColors.bluePrimaryDual.withOpacity(0.2),
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
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.iconColor,
            ),
          ),
          subtitle: Text(
            'From: ${contact['name']} • ${contact['date']}',
            style: TextStyle(color: AppColors.iconLightColor, fontSize: 12),
          ),
          trailing: Chip(
            label: Text(status),
            backgroundColor: status.toLowerCase() == 'unread'
                ? Colors.red.withOpacity(0.2)
                : Colors.green.withOpacity(0.2),
            labelStyle: TextStyle(
              color: status.toLowerCase() == 'unread'
                  ? Colors.red
                  : Colors.green,
              fontWeight: FontWeight.w600,
            ),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                contact['message'] as String,
                style: TextStyle(fontSize: 14, color: AppColors.iconColor),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () => _showReplySheet(contact),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.bluePrimaryDual,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                  ),
                  child: const Text(
                    "Reply",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),

                const SizedBox(width: 12),
              ],
            ),
          ],
        ),
      ),
    );
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
          bottom: TabBar(
            controller: _tabController,
            labelColor: Colors.white,
            unselectedLabelColor: const Color.fromARGB(255, 200, 199, 199),
            labelStyle: const TextStyle(fontWeight: FontWeight.bold),
            tabs: const [
              Tab(text: 'Pending'),
              Tab(text: 'Completed'),
            ],
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
            child: TabBarView(
              controller: _tabController,
              children: [
                pendingMessages.isEmpty
                    ? const Center(child: Text('No pending messages'))
                    : ListView.builder(
                        padding: const EdgeInsets.only(top: 16),
                        itemCount: pendingMessages.length,
                        itemBuilder: (context, index) {
                          return buildMessageCard(pendingMessages[index]);
                        },
                      ),
                completedMessages.isEmpty
                    ? const Center(child: Text('No completed messages'))
                    : ListView.builder(
                        padding: const EdgeInsets.only(top: 16),
                        itemCount: completedMessages.length,
                        itemBuilder: (context, index) {
                          return buildMessageCard(completedMessages[index]);
                        },
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
