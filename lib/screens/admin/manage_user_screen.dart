import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sportspark/screens/admin/sport_provider/sports_provider.dart';
import 'package:sportspark/screens/login/view/user_editscreen.dart';
import 'package:sportspark/screens/search_provider/search_provider.dart';
import 'package:sportspark/utils/const/const.dart';
import 'package:sportspark/utils/router/route_observer.dart';
import 'package:sportspark/utils/router/router.dart';
import 'package:sportspark/utils/snackbar/snackbar.dart';
import 'package:sportspark/utils/widget/custom_confirmation_dialog.dart';

class ManageUsersScreen extends StatefulWidget {
  const ManageUsersScreen({super.key});

  @override
  State<ManageUsersScreen> createState() => _ManageUsersScreenState();
}

class _ManageUsersScreenState extends State<ManageUsersScreen>
    with TickerProviderStateMixin, RouteAware {
  late final AnimationController _animCtrl;
  late final Animation<double> _fadeAnim;
  late final Animation<Offset> _slideAnim;
  late final TabController _tabCtrl;
  late final ScrollController _userScrollCtrl;
  late final ScrollController _adminScrollCtrl;

  bool _returning = false;

  @override
  void initState() {
    super.initState();

    // Animations
    _animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _fadeAnim = CurvedAnimation(parent: _animCtrl, curve: Curves.easeInOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animCtrl, curve: Curves.easeOutBack));
    _animCtrl.forward();

    // Tab & Scroll
    _tabCtrl = TabController(length: 2, vsync: this);
    _tabCtrl.addListener(_handleTabChange);
    _userScrollCtrl = ScrollController()..addListener(_onUserScroll);
    _adminScrollCtrl = ScrollController()..addListener(_onAdminScroll);

    // Initial load
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadInitialData());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Subscribe to route changes
    routeObserver.subscribe(this, ModalRoute.of(context)! as PageRoute);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    _animCtrl.dispose();
    _tabCtrl.dispose();
    _userScrollCtrl.dispose();
    _adminScrollCtrl.dispose();
    super.dispose();
  }

  @override
  void didPopNext() {
    if (_returning) return;
    _returning = true;
    Future.microtask(() {
      _refreshCurrentTabSilently();
      _returning = false;
    });
  }

  void _loadInitialData() {
    Provider.of<UserProvider>(context, listen: false).fetchUsers();
  }

  void _handleTabChange() {
    if (_tabCtrl.indexIsChanging) return;
    final p = Provider.of<UserProvider>(context, listen: false);
    if (_tabCtrl.index == 0)
      p.fetchUsers();
    else
      p.fetchAdmins();
  }

  void _onUserScroll() {
    final pos = _userScrollCtrl.position;
    if (pos.pixels >= pos.maxScrollExtent - 200 &&
        !Provider.of<UserProvider>(context, listen: false).isLoadingUsers &&
        Provider.of<UserProvider>(context, listen: false).hasMoreUsers) {
      Provider.of<UserProvider>(context, listen: false).loadMoreUsers();
    }
  }

  void _onAdminScroll() {
    final pos = _adminScrollCtrl.position;
    if (pos.pixels >= pos.maxScrollExtent - 200 &&
        !Provider.of<UserProvider>(context, listen: false).isLoadingAdmins &&
        Provider.of<UserProvider>(context, listen: false).hasMoreAdmins) {
      Provider.of<UserProvider>(context, listen: false).loadMoreAdmins();
    }
  }

  Future<void> _refreshCurrentTabSilently() async {
    final p = Provider.of<UserProvider>(context, listen: false);
    final isUserTab = _tabCtrl.index == 0;
    try {
      await p.refreshDataSilently(isUserTab: isUserTab);
    } catch (e) {
      debugPrint('Silent refresh failed: $e');
    }
  }

  Future<void> _refreshData() async {
    _animCtrl.reset();
    _animCtrl.forward();
    await _refreshCurrentTabSilently();
  }

  List<Map<String, dynamic>> _filterByRole(List<dynamic> all, String role) {
    return all
        .where((u) => (u as Map<String, dynamic>)['role'] == role)
        .cast<Map<String, dynamic>>()
        .toList();
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
          centerTitle: false,
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh, color: Colors.white),
              onPressed: _refreshData,
              tooltip: 'Refresh',
            ),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(48),
            child: _buildTabBar(),
          ),
        ),
        body: Consumer<UserProvider>(
          builder: (context, provider, _) {
            final loading = _tabCtrl.index == 0
                ? provider.isLoadingUsers
                : provider.isLoadingAdmins;
            final empty = _tabCtrl.index == 0
                ? provider.users.isEmpty
                : provider.admins.isEmpty;

            if (loading && empty) {
              return const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppColors.bluePrimaryDual,
                  ),
                ),
              );
            }

            return FadeTransition(
              opacity: _fadeAnim,
              child: SlideTransition(
                position: _slideAnim,
                child: TabBarView(
                  controller: _tabCtrl,
                  children: [
                    _buildUserList(
                      users: _filterByRole(provider.users, 'USER'),
                      role: 'User',
                      scrollController: _userScrollCtrl,
                      isLoadingMore:
                          provider.isLoadingUsers && provider.users.isNotEmpty,
                      hasMore: provider.hasMoreUsers,
                    ),
                    _buildUserList(
                      users: provider.admins
                          .cast<Map<String, dynamic>>()
                          .toList(),
                      role: 'Admin',
                      scrollController: _adminScrollCtrl,
                      isLoadingMore:
                          provider.isLoadingAdmins &&
                          provider.admins.isNotEmpty,
                      hasMore: provider.hasMoreAdmins,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTabBar() => Container(
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: Colors.grey.withOpacity(.3)),
    ),
    child: TabBar(
      controller: _tabCtrl,
      labelColor: AppColors.bluePrimaryDual,
      unselectedLabelColor: Colors.grey,
      indicatorColor: AppColors.bluePrimaryDual,
      indicatorWeight: 3,
      tabs: const [
        Tab(text: 'User List'),
        Tab(text: 'Admin List'),
      ],
    ),
  );

  Widget _buildUserList({
    required List<Map<String, dynamic>> users,
    required String role,
    required ScrollController scrollController,
    required bool isLoadingMore,
    required bool hasMore,
  }) {
    if (users.isEmpty && !isLoadingMore) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.people_outline,
              size: 64,
              color: Colors.grey.withOpacity(.5),
            ),
            const SizedBox(height: 16),
            Text(
              'No ${role.toLowerCase()}s Found',
              style: TextStyle(
                color: AppColors.iconLightColor,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      color: AppColors.bluePrimaryDual,
      onRefresh: _refreshCurrentTabSilently,
      child: ListView.builder(
        controller: scrollController,
        padding: const EdgeInsets.all(16),
        itemCount: users.length + (hasMore || isLoadingMore ? 1 : 0),
        itemBuilder: (context, i) {
          if (i >= users.length) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Center(
                child: isLoadingMore
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('No more data'),
              ),
            );
          }

          final user = users[i];
          final status = (user['status'] as String?)?.toUpperCase() ?? 'ACTIVE';
          final (statusDisplay, statusColor) = switch (status) {
            'ACTIVE' => ('Active', Colors.green),
            'INACTIVE' => ('Inactive', Colors.orange),
            'BLOCKED' => ('Blocked', Colors.red),
            _ => ('Unknown', Colors.grey),
          };
          final createdAt =
              (user['createdAt'] as String?)?.substring(0, 10) ?? '—';

          return Card(
            elevation: 5,
            shadowColor: Colors.black.withOpacity(.1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              leading: CircleAvatar(
                radius: 25,
                backgroundColor: AppColors.bluePrimaryDual,
                backgroundImage: user['profile'] != null
                    ? NetworkImage(user['profile'] as String)
                    : null,
                child: user['profile'] == null
                    ? const Icon(Icons.person, color: Colors.white)
                    : null,
              ),
              title: Text(
                user['name'] ?? 'Unknown',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF333333),
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user['email'] ?? '',
                    style: TextStyle(color: AppColors.iconLightColor),
                  ),
                  Text(
                    'Joined: $createdAt',
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
                      color: statusColor.withOpacity(.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      statusDisplay,
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

                // ---- BUILD ITEMS DYNAMICALLY ----
                itemBuilder: (_) {
                  final items = <PopupMenuEntry<String>>[
                    const PopupMenuItem(value: 'Edit', child: Text('Edit')),
                  ];

                  if (user['status'] != 'ACTIVE') {
                    items.add(
                      const PopupMenuItem(
                        value: 'Activate',
                        child: Text('Activate'),
                      ),
                    );
                  }
                  if (user['status'] != 'INACTIVE') {
                    items.add(
                      const PopupMenuItem(
                        value: 'Deactivate',
                        child: Text('Deactivate'),
                      ),
                    );
                  }
                  if (user['status'] != 'BLOCKED') {
                    items.add(
                      const PopupMenuItem(value: 'Block', child: Text('Block')),
                    );
                  }

                  return items;
                },

                // ---- YOUR SAME LOGIC BELOW ----
                onSelected: (value) async {
                  if (value == 'Edit') {
                    MyRouter.push(screen: MyUserScreen(userData: user));
                    return;
                  }

                  final sportsProvider = Provider.of<AddSportsProvider>(
                    context,
                    listen: false,
                  );

                  final (newStatus, title, msg, confirmColor) = switch (value) {
                    'Activate' => (
                      'ACTIVE',
                      'Activate User!',
                      'Are you sure you want to activate ${user['name']}?',
                      Colors.green,
                    ),
                    'Deactivate' => (
                      'INACTIVE',
                      'Deactivate User!',
                      'Are you sure you want to deactivate ${user['name']}?',
                      Colors.orange,
                    ),
                    'Block' => (
                      'BLOCKED',
                      'Block User!',
                      'Are you sure you want to block ${user['name']}?',
                      Colors.red,
                    ),
                    _ => (null, '', '', Colors.orange),
                  };

                  if (newStatus == null) return;

                  CustomConfirmationDialog.show(
                    context: context,
                    title: title,
                    message: msg,
                    icon: Icons.manage_accounts,
                    confirmText: 'Confirm',
                    cancelText: 'Cancel',
                    confirmColor: confirmColor,
                    iconColor: AppColors.iconColor,
                    backgroundColor: AppColors.background,
                    textColor: AppColors.textPrimary,
                    onConfirm: () async {
                      try {
                        final ok = await sportsProvider.updateUserStatus(
                          id: user['_id'],
                          status: newStatus,
                        );

                        if (ok) {
                          Messenger.alertSuccess(
                            "${user['name']} is now $newStatus.",
                          );
                          await _refreshCurrentTabSilently();
                        } else {
                          Messenger.alertError("Failed to update status.");
                        }
                      } catch (e) {
                        Messenger.alertError("Error: $e");
                      }
                    },
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
