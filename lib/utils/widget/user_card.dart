import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sportspark/screens/admin/sport_provider/sports_provider.dart';
import 'package:sportspark/screens/login/view/user_editscreen.dart';
import 'package:sportspark/utils/const/const.dart';
import 'package:sportspark/utils/router/router.dart';
import 'package:sportspark/utils/snackbar/snackbar.dart';
import 'package:sportspark/utils/widget/custom_confirmation_dialog.dart';

class UserCard extends StatelessWidget {
  final Map<String, dynamic> user;
  const UserCard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final status = (user['status'] as String?)?.toUpperCase() ?? 'ACTIVE';
    final createdAt = (user['createdAt'] as String?)?.substring(0, 10) ?? '—';

    final statusData = _getStatusData(status);

    return Card(
      elevation: 5,
      shadowColor: Colors.black.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          radius: 25,
          backgroundColor: AppColors.bluePrimaryDual,
          backgroundImage: user['profile'] != null
              ? NetworkImage(user['profile'])
              : null,
          child: user['profile'] == null
              ? const Icon(Icons.person, color: Colors.white)
              : null,
        ),
        title: Text(
          user['name'] ?? 'Unknown',
          style: const TextStyle(
              fontSize: 18, fontWeight: FontWeight.w600, color: Color(0xFF333333)),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(user['email'] ?? '',
                style: TextStyle(color: AppColors.iconLightColor)),
            Text('Joined: $createdAt',
                style: TextStyle(color: AppColors.iconLightColor, fontSize: 12)),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: statusData['color'].withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                statusData['label'],
                style: TextStyle(
                  color: statusData['color'],
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        trailing: _buildPopupMenu(context),
      ),
    );
  }

  Map<String, dynamic> _getStatusData(String status) {
    switch (status) {
      case 'ACTIVE':
        return {'label': 'Active', 'color': Colors.green};
      case 'INACTIVE':
        return {'label': 'Inactive', 'color': Colors.orange};
      case 'BLOCKED':
        return {'label': 'Blocked', 'color': Colors.red};
      default:
        return {'label': 'Unknown', 'color': Colors.grey};
    }
  }

  Widget _buildPopupMenu(BuildContext context) {
    final sportsProvider = Provider.of<AddSportsProvider>(context, listen: false);

    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert, color: AppColors.iconLightColor),
      onSelected: (value) async {
        if (value == 'Edit') {
          MyRouter.push(screen: MyUserScreen(userData: user));
          return;
        }

        String newStatus = '';
        String title = '';
        String message = '';

        if (value == 'Activate') {
          newStatus = 'ACTIVE';
          title = 'Activate User';
          message = 'Do you want to activate ${user['name']}?';
        } else if (value == 'Deactivate') {
          newStatus = 'INACTIVE';
          title = 'Deactivate User';
          message = 'Do you want to deactivate ${user['name']}?';
        } else if (value == 'Block') {
          newStatus = 'BLOCKED';
          title = 'Block User';
          message = 'Are you sure you want to block ${user['name']}?';
        }

        if (newStatus.isEmpty) return;

        CustomConfirmationDialog.show(
          context: context,
          title: title,
          message: message,
          icon: Icons.manage_accounts,
          confirmText: 'Confirm',
          cancelText: 'Cancel',
          confirmColor: newStatus == 'BLOCKED'
              ? Colors.red
              : newStatus == 'ACTIVE'
                  ? Colors.green
                  : Colors.orange,
          iconColor: AppColors.iconColor,
          backgroundColor: AppColors.background,
          textColor: AppColors.textPrimary,
          onConfirm: () async {
            final success = await sportsProvider.updateUserStatus(
              id: user['_id'],
              status: newStatus,
            );

            if (success) {
              Messenger.alertSuccess(
                  "${user['name']} status updated to $newStatus.");
              Future.microtask(() =>
                  Provider.of(context, listen: false).fetchUsers());
            } else {
              Messenger.alertError("Failed to update status. Try again.");
            }
          },
        );
      },
      itemBuilder: (context) => const [
        PopupMenuItem(value: 'Edit', child: Text('Edit')),
        PopupMenuItem(value: 'Activate', child: Text('Activate')),
        PopupMenuItem(value: 'Deactivate', child: Text('Deactivate')),
        PopupMenuItem(value: 'Block', child: Text('Block')),
      ],
    );
  }
}
