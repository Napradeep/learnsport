import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sportspark/screens/admin/add_sports.dart';
import 'package:sportspark/screens/admin/sport_provider/sports_provider.dart';
import 'package:sportspark/utils/const/const.dart';
import 'package:sportspark/utils/snackbar/snackbar.dart';
import 'package:sportspark/utils/widget/custom_confirmation_dialog.dart';

class ManageSportsScreen extends StatefulWidget {
  const ManageSportsScreen({super.key});

  @override
  State<ManageSportsScreen> createState() => _ManageSportsScreenState();
}

class _ManageSportsScreenState extends State<ManageSportsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<AddSportsProvider>(context, listen: false);
      provider.fetchSports();
    });
  }

  Future<void> _openAddEditScreen([Map<String, dynamic>? sport]) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => AddEditSportScreen(sport: sport)),
    );

    if (result == null || result is! Map<String, dynamic>) return;

    final provider = Provider.of<AddSportsProvider>(context, listen: false);

    try {
      if (sport == null) {
        await provider.addSport(
          name: result['name'],
          about: result['about'],
          actualPrice: result['actual_price_per_slot'].toString(),
          finalPrice: result['final_price_per_slot'].toString(),
          groundName: result['ground_name'],
          lightingHalf: result['sport_lighting_price_half'].toString(),
          lightingFull: result['sport_lighting_price_full'].toString(),
          status: result['status'],
          image: result['image'],
          banner: result['banner'],
        );
        Messenger.alertSuccess("Sport added successfully!");
      } else {
        await provider.updateSport(
          id: sport['_id'],
          name: result['name'],
          about: result['about'],
          actualPrice: result['actual_price_per_slot'].toString(),
          finalPrice: result['final_price_per_slot'].toString(),
          groundName: result['ground_name'],
          lightingHalf: result['sport_lighting_price_half'].toString(),
          lightingFull: result['sport_lighting_price_full'].toString(),
          status: result['status'],
          image: result['image'],
          banner: result['banner'],
        );
        Messenger.alertSuccess("Sport updated successfully!");
      }

      if (mounted) provider.fetchSports(forceRefresh: true);
    } catch (e) {
      Messenger.alertError("Operation failed. Please try again.");
    }
  }

  Future<void> _deleteSport(String id) async {
    CustomConfirmationDialog.show(
      context: context,
      title: 'Delete Sport',
      message: 'Are you sure you want to delete this sport?',
      icon: Icons.delete_outline,
      iconColor: Colors.red,
      backgroundColor: Colors.white,
      textColor: Colors.black87,
      confirmColor: Colors.red,
      onConfirm: () async {
        final provider = Provider.of<AddSportsProvider>(context, listen: false);
        final success = await provider.deleteSport(id);
        if (success) {
          Messenger.alert(msg: "Sport deleted successfully!");
          if (mounted) provider.fetchSports(forceRefresh: true);
        }
      },
    );
  }

  Future<void> _toggleStatus(
    Map<String, dynamic> sport,
    AddSportsProvider provider,
  ) async {
    final String currentStatus = (sport['status'] ?? '').toUpperCase();
    final String newStatus = currentStatus == 'AVAILABLE'
        ? 'NOT_AVAILABLE'
        : 'AVAILABLE';
        
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Change Status'),
        content: Text(
          'Are you sure you want to mark this sport as "$newStatus"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: newStatus == 'AVAILABLE'
                  ? Colors.green
                  : Colors.red,
            ),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      await provider.updateSport(
        id: sport['_id'],
        name: sport['name'],
        about: sport['about'],
        actualPrice: sport['actual_price_per_slot'].toString(),
        finalPrice: sport['final_price_per_slot'].toString(),
        groundName: sport['ground_name'],
        lightingHalf: sport['sport_lighting_price_half'].toString(),
        lightingFull: sport['sport_lighting_price_full'].toString(),
        status: newStatus,
        image: sport['image'],
        banner: sport['banner'],
      );

      if (mounted) {
        Messenger.alertSuccess("Status updated to $newStatus!");
        provider.fetchSports(forceRefresh: true);
      }
    } catch (e) {
      Messenger.alertError("Failed to update status. Please try again.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Manage Sports',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 22,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppColors.bluePrimaryDual,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openAddEditScreen(),
        backgroundColor: AppColors.bluePrimaryDual,
        tooltip: 'Add New Sport',
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
      body: Consumer<AddSportsProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading && provider.sports.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppColors.bluePrimaryDual,
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => provider.fetchSports(forceRefresh: true),
            child: provider.sports.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: provider.sports.length,
                    itemBuilder: (_, i) =>
                        _buildSportCard(provider.sports[i], provider),
                  ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey.shade100,
            ),
            child: Icon(
              Icons.sports_soccer,
              size: 80,
              color: Colors.grey.shade400,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'No Sports Available',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSportCard(
    Map<String, dynamic> sport,
    AddSportsProvider provider,
  ) {
    final String backendStatus = (sport['status'] ?? 'UNKNOWN').toUpperCase();
    final bool isAvailable = backendStatus == 'AVAILABLE';
    final Color baseColor = isAvailable ? Colors.green : Colors.red;
    final String displayStatus = isAvailable ? 'Available' : 'Not Available';

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [Colors.white, Colors.grey.shade50],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: sport['imageUrl'] != null
                        ? Image.network(
                            sport['imageUrl'],
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) =>
                                _buildImagePlaceholder(),
                          )
                        : _buildImagePlaceholder(),
                  ),
                ),
                const SizedBox(width: 16),

                // Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        sport['name'] ?? 'Unknown',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        sport['ground_name'] ?? 'No ground',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Actual: ₹${sport['actual_price_per_slot'] ?? 0} | Final: ₹${sport['final_price_per_slot'] ?? 0}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: baseColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: baseColor, width: 1),
                        ),
                        child: Text(
                          displayStatus,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: baseColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                PopupMenuButton<String>(
                  onSelected: (v) {
                    if (v == 'status') _toggleStatus(sport, provider);
                    if (v == 'edit') _openAddEditScreen(sport);
                    if (v == 'delete') _deleteSport(sport['_id']);
                  },
                  itemBuilder: (_) => [
                    PopupMenuItem(
                      value: 'status',
                      child: Row(
                        children: [
                          Icon(
                            isAvailable
                                ? Icons.cancel_outlined
                                : Icons.check_circle_outline,
                            size: 18,
                            color: isAvailable ? Colors.red : Colors.green,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            isAvailable
                                ? 'Mark Not Available'
                                : 'Mark Available',
                          ),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit, size: 18, color: Colors.blue),
                          SizedBox(width: 8),
                          Text('Edit'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete, size: 18, color: Colors.red),
                          SizedBox(width: 8),
                          Text('Delete'),
                        ],
                      ),
                    ),
                  ],
                  icon: const Icon(Icons.more_vert, color: Colors.black54),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImagePlaceholder() {
    return Container(
      color: Colors.grey.shade100,
      child: Icon(Icons.sports_soccer, size: 40, color: Colors.grey.shade400),
    );
  }
}
