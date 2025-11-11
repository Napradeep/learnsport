import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
//import 'package:sportspark/screens/admin/manage_users/user_card.dart';
import 'package:sportspark/screens/search_provider/search_provider.dart';
import 'package:sportspark/utils/const/const.dart';
import 'package:sportspark/utils/widget/user_card.dart';

class UserListWidget extends StatelessWidget {
  final List users;
  final ScrollController scrollController;
  final bool isLoadingMore;
  final bool hasMore;

  const UserListWidget({
    super.key,
    required this.users,
    required this.scrollController,
    required this.isLoadingMore,
    required this.hasMore,
  });

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<UserProvider>(context, listen: false);

    if (users.isEmpty && !isLoadingMore) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.people_outline,
              size: 64,
              color: Colors.grey.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            const Text(
              'No Users Found',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      color: AppColors.bluePrimaryDual,
      onRefresh: () async {
        await provider.fetchUsers();
      },
      child: ListView.builder(
        controller: scrollController,
        padding: const EdgeInsets.all(16),
        itemCount: users.length + (hasMore || isLoadingMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index >= users.length) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Center(
                child: isLoadingMore
                    ? const CircularProgressIndicator(strokeWidth: 2)
                    : const Text('No more data'),
              ),
            );
          }

          final user = users[index] as Map<String, dynamic>;
          return UserCard(user: user);
        },
      ),
    );
  }
}
