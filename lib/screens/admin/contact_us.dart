import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sportspark/utils/const/const.dart';
import 'package:sportspark/screens/common_provider/contact_provider.dart';
import 'package:sportspark/utils/widget/enquiry_card.dart';

class ContactUsScreen extends StatefulWidget {
  final String role;
  const ContactUsScreen({super.key, required this.role});

  @override
  State<ContactUsScreen> createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen>
    with TickerProviderStateMixin {
  late TabController _tab;
  final ScrollController _pendingCtrl = ScrollController();
  final ScrollController _completedCtrl = ScrollController();

  bool get isAdmin => widget.role == "ADMIN" || widget.role == "SUPER_ADMIN";

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 2, vsync: this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final p = Provider.of<ContactProvider>(context, listen: false);
      _refreshAll(p);
    });

    _pendingCtrl.addListener(() => _handleScroll("pending"));
    _completedCtrl.addListener(() => _handleScroll("completed"));

    _tab.addListener(() {
      if (_tab.indexIsChanging) return;
      _onTabChange();
    });
  }

  /// REFRESH BOTH LISTS (pending + completed)
  void _refreshAll(ContactProvider p) {
    p.clearAll();

    if (isAdmin) {
      p.fetchAdminEnquiries("pending", widget.role);
      p.fetchAdminEnquiries("completed", widget.role);
    } else {
      p.fetchUserEnquiries("PENDING");
      p.fetchUserEnquiries("REPLIED");
    }
  }

  /// ON TAB CHANGE - REFRESH ONLY SELECTED TAB
  void _onTabChange() {
    final p = Provider.of<ContactProvider>(context, listen: false);
    p.clearAll();

    if (_tab.index == 0) {
      isAdmin
          ? p.fetchAdminEnquiries("pending", widget.role)
          : p.fetchUserEnquiries("PENDING");
    } else {
      isAdmin
          ? p.fetchAdminEnquiries("completed", widget.role)
          : p.fetchUserEnquiries("REPLIED");
    }
  }

  /// PAGINATION (SCROLL LOADING)
  void _handleScroll(String tab) {
    final p = Provider.of<ContactProvider>(context, listen: false);
    final ctrl = tab == "pending" ? _pendingCtrl : _completedCtrl;

    if (ctrl.position.pixels >= ctrl.position.maxScrollExtent - 150) {
      if (isAdmin) {
        if (tab == "pending" && p.hasMoreAdminPending && !p.isLoading) {
          p.fetchAdminEnquiries("pending", widget.role);
        }
        if (tab == "completed" && p.hasMoreAdminCompleted && !p.isLoading) {
          p.fetchAdminEnquiries("completed", widget.role);
        }
      } else {
        if (tab == "pending" && p.hasMoreUserPending && !p.isLoadingUser) {
          p.fetchUserEnquiries("PENDING");
        }
        if (tab == "completed" && p.hasMoreUserCompleted && !p.isLoadingUser) {
          p.fetchUserEnquiries("REPLIED");
        }
      }
    }
  }

  @override
  void dispose() {
    _tab.dispose();
    _pendingCtrl.dispose();
    _completedCtrl.dispose();
    super.dispose();
  }

  /// BOTTOM SHEET FOR REPLY
  void _showReplySheet(Map<String, dynamic> item) {
    final ctrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) {
        return Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 15,
            left: 20,
            right: 20,
            top: 20,
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Reply to ${item['name']}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 10),

              TextField(
                controller: ctrl,
                maxLines: 4,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Type your reply...",
                ),
              ),

              const SizedBox(height: 12),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.bluePrimaryDual,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 48),
                ),
                onPressed: () async {
                  if (ctrl.text.trim().isEmpty) return;

                  Navigator.pop(context);

                  /// SHOW LOADING DIALOG
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (_) => const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.bluePrimaryDual,
                      ),
                    ),
                  );

                  final p =
                      Provider.of<ContactProvider>(context, listen: false);

                  // SEND REPLY
                  await p.replyToEnquiry(item["_id"], ctrl.text.trim());

                  Navigator.pop(context); // close loading dialog

                  /// AUTO REFRESH LIST
                  _refreshAll(p);
                },
                child: const Text("Send Reply"),
              ),
            ],
          ),
        );
      },
    );
  }

  /// LIST UI
  Widget _buildList({
    required List<Map<String, dynamic>> items,
    required bool loading,
    required ScrollController controller,
  }) {
    if (loading && items.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.bluePrimaryDual),
      );
    }

    if (items.isEmpty) {
      return const Center(child: Text("No enquiries found"));
    }

    return Stack(
      children: [
        ListView.builder(
          controller: controller,
          itemCount: items.length,
          itemBuilder: (_, i) => enquiryCard(
            items[i],
            isAdmin: isAdmin,
            onReply: isAdmin ? () => _showReplySheet(items[i]) : null,
          ),
        ),

        /// SCROLL BOTTOM LOADING
        if (loading)
          const Positioned(
            bottom: 15,
            left: 0,
            right: 0,
            child: Center(
              child: CircularProgressIndicator(
                color: AppColors.bluePrimaryDual,
              ),
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isAdmin ? "Contact Enquiries" : "My Enquiries"),
        backgroundColor: AppColors.bluePrimaryDual,
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tab,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(text: "Pending"),
            Tab(text: "Completed"),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () {
              final p = Provider.of<ContactProvider>(context, listen: false);
              _refreshAll(p);
            },
          ),
        ],
      ),
      body: Consumer<ContactProvider>(
        builder: (_, p, __) {
          return TabBarView(
            controller: _tab,
            children: [
              _buildList(
                items: isAdmin ? p.adminPending : p.userPending,
                loading: isAdmin ? p.isLoading : p.isLoadingUser,
                controller: _pendingCtrl,
              ),
              _buildList(
                items: isAdmin ? p.adminCompleted : p.userCompleted,
                loading: isAdmin ? p.isLoading : p.isLoadingUser,
                controller: _completedCtrl,
              ),
            ],
          );
        },
      ),
    );
  }
}
