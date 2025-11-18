


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
      context.read<AddSportsProvider>().fetchSports();
    });
  }

  // Unified method: Add or Edit → always refresh on success
  Future<void> _openAddEditScreen([Map<String, dynamic>? sport]) async {
    final bool? shouldRefresh = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AddEditSportScreen(sport: sport),
      ),
    );

    // If AddEditSportScreen returns true → operation was successful → refresh
    if (shouldRefresh == true && mounted) {
      context.read<AddSportsProvider>().fetchSports(forceRefresh: true);
    }
  }

  Future<void> _deleteSport(String id) async {
    CustomConfirmationDialog.show(
      context: context,
      title: 'Delete Sport!',
      message: 'Are you sure you want to delete this sport?',
      icon: Icons.delete_outline,
      iconColor: Colors.red,
      backgroundColor: Colors.white,
      textColor: Colors.black87,
      confirmColor: Colors.red,
      onConfirm: () async {
        final provider = context.read<AddSportsProvider>();
        final success = await provider.deleteSport(id);
        if (success && mounted) {
          Messenger.alertSuccess("Sport deleted successfully!");
          provider.fetchSports(forceRefresh: true);
        }
      },
    );
  }

  Future<void> _toggleStatus(
    Map<String, dynamic> sport,
    AddSportsProvider provider,
  ) async {
    final String currentStatus = (sport['status'] ?? '').toString().toUpperCase();
    final String newStatus = currentStatus == 'AVAILABLE' ? 'NOT_AVAILABLE' : 'AVAILABLE';
    final String displayStatus = newStatus == "AVAILABLE" ? "available" : "unavailable";

    final confirmed = await CustomConfirmationDialog.show(
      context: context,
      title: "Update Status",
      message: 'Mark this sport as $displayStatus?',
      icon: Icons.info_outline,
      iconColor: newStatus == "AVAILABLE" ? Colors.green : Colors.red,
      confirmColor: newStatus == "AVAILABLE" ? Colors.green : Colors.red,
      onConfirm: () async {
        await provider.updateSport(
          id: sport['_id'].toString(),
          name: sport['name'] ?? "",
          about: sport['about'] ?? "",
          actualPrice: sport['actual_price_per_slot']?.toString() ?? "0",
          finalPrice: sport['final_price_per_slot']?.toString() ?? "0",
          groundName: sport['ground_name'] ?? "",
          lightingHalf: sport['sport_lighting_price_half']?.toString() ?? "0",
          lightingFull: sport['sport_lighting_price_full']?.toString() ?? "0",
          status: newStatus,
          image: null,
          banner: null,
          webBanner: null,
        );
      },
    );

    if (confirmed == true && mounted) {
      Messenger.alertSuccess("Status updated!");
      provider.fetchSports(forceRefresh: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Manage Sports',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 22, color: Colors.white),
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
              child: CircularProgressIndicator(color: AppColors.bluePrimaryDual),
            );
          }

          return RefreshIndicator(
            onRefresh: () => provider.fetchSports(forceRefresh: true),
            child: provider.sports.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: provider.sports.length,
                    itemBuilder: (_, i) => _buildSportCard(provider.sports[i], provider),
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
            decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.grey.shade100),
            child: Icon(Icons.sports_soccer, size: 80, color: Colors.grey.shade400),
          ),
          const SizedBox(height: 16),
          Text(
            'No Sports Available',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.grey.shade700),
          ),
        ],
      ),
    );
  }

  Widget _buildSportCard(Map<String, dynamic> sport, AddSportsProvider provider) {
    final bool isAvailable = (sport['status'] ?? '').toString().toUpperCase() == 'AVAILABLE';
    final Color statusColor = isAvailable ? Colors.green : Colors.red;
    final String statusText = isAvailable ? 'Available' : 'Not Available';

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(colors: [Colors.white, Colors.grey.shade50], begin: Alignment.topLeft, end: Alignment.bottomRight),
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
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade200)),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: sport['image'] != null
                        ? Image.network(sport['image'], fit: BoxFit.cover, errorBuilder: (_, __, ___) => _buildImagePlaceholder())
                        : _buildImagePlaceholder(),
                  ),
                ),
                const SizedBox(width: 16),

                // Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(sport['name'] ?? 'Unknown', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black87)),
                      const SizedBox(height: 6),
                      Text(sport['ground_name'] ?? 'No ground', style: TextStyle(fontSize: 14, color: Colors.grey.shade600)),
                      const SizedBox(height: 6),
                      Text(
                        'Actual: ₹${sport['actual_price_per_slot'] ?? 0} | Final: ₹${sport['final_price_per_slot'] ?? 0}',
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black54),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(color: statusColor.withOpacity(0.1), borderRadius: BorderRadius.circular(12), border: Border.all(color: statusColor)),
                        child: Text(statusText, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: statusColor)),
                      ),
                    ],
                  ),
                ),

                // Menu
                PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'status') _toggleStatus(sport, provider);
                    if (value == 'edit') _openAddEditScreen(sport);
                    if (value == 'delete') _deleteSport(sport['_id']);
                  },
                  itemBuilder: (_) => [
                    PopupMenuItem(
                      value: 'status',
                      child: Row(children: [Icon(isAvailable ? Icons.cancel_outlined : Icons.check_circle_outline, size: 18, color: isAvailable ? Colors.red : Colors.green), const SizedBox(width: 8), Text(isAvailable ? 'Mark unavailable' : 'Mark available')]),
                    ),
                    const PopupMenuItem(value: 'edit', child: Row(children: [Icon(Icons.edit, size: 18, color: Colors.blue), SizedBox(width: 8), Text('Edit')])),
                    const PopupMenuItem(value: 'delete', child: Row(children: [Icon(Icons.delete, size: 18, color: Colors.red), SizedBox(width: 8), Text('Delete')])),
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
    return Container(color: Colors.grey.shade100, child: Icon(Icons.sports_soccer, size: 40, color: Colors.grey.shade400));
  }
}