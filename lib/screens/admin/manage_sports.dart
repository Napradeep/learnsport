

import 'package:flutter/material.dart';
import 'package:sportspark/screens/admin/add_sports.dart';
import 'package:sportspark/utils/const/const.dart';
import 'package:sportspark/utils/snackbar/snackbar.dart';
import 'dart:io';

import 'package:sportspark/utils/widget/custom_confirmation_dialog.dart';

class ManageSportsScreen extends StatefulWidget {
  const ManageSportsScreen({super.key});

  @override
  State<ManageSportsScreen> createState() => _ManageSportsScreenState();
}

class _ManageSportsScreenState extends State<ManageSportsScreen> {
  final List<Map<String, dynamic>> _sports = [
    {
      'sport_name': 'Basketball',
      'ground_name': 'Basketball Court',
      'sport_actual_price_per_slot': 100.0,
      'sport_final_price_per_slot': 80.0,
      'about_sport': 'Fast-paced game played on a court.',
      'status': 'Active',
      'sport_image': null,
      'sport_banner': null,
    },
    {
      'sport_name': 'Cricket',
      'ground_name': 'Main Turf Ground',
      'sport_actual_price_per_slot': 200.0,
      'sport_final_price_per_slot': 150.0,
      'about_sport': 'Popular turf-based cricket game.',
      'status': 'Active',
      'sport_image': null,
      'sport_banner': null,
    },
  ];

  bool _isLoading = false;

  Future<void> _addOrUpdateSport(
    Map<String, dynamic>? sport, [
    int? index,
  ]) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddEditSportScreen(sport: sport)),
    );

    if (result != null) {
      setState(() {
        if (index != null) {
          _sports[index] = result;
          Messenger.alertSuccess('Sport updated successfully');
        } else {
          _sports.add(result);
          Messenger.alertSuccess('Sport added successfully');
        }
      });
    }
  }

  Future<void> _deleteSport(int index) async {
    CustomConfirmationDialog.show(
      context: context,
      title: 'Delete Sport',
      message: 'Are you sure you want to delete this sport?',
      icon: Icons.delete_outline,
      iconColor: Colors.red,
      backgroundColor: Colors.white,
      textColor: Colors.black87,
      confirmColor: Colors.red,
      onConfirm: () {
        setState(() {
          _sports.removeAt(index);
          Messenger.alertSuccess('Sport deleted successfully');
        });
      },
    );
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
        onPressed: () => _addOrUpdateSport(null),
        backgroundColor: AppColors.bluePrimaryDual,
        elevation: 2,
        hoverElevation: 4,
        tooltip: 'Add New Sport',
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: AppColors.bluePrimaryDual,
              ),
            )
          : _sports.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _sports.length,
              itemBuilder: (context, index) => _buildSportCard(index),
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
          const SizedBox(height: 8),
          Text(
            'Tap the + button to add a new sport',
            style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }

  Widget _buildSportCard(int index) {
    final sport = _sports[index];
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: GestureDetector(
        onTap: () => _addOrUpdateSport(sport, index),
        child: Card(
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
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
                  // Sport Image
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: sport['sport_image'] != null
                          ? Image.file(
                              File(sport['sport_image']),
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  _buildImagePlaceholder(),
                            )
                          : _buildImagePlaceholder(),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Sport Details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          sport['sport_name'] ?? 'Unknown',
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
                          'Actual: \$${sport['sport_actual_price_per_slot']?.toStringAsFixed(2) ?? '0.00'} | Final: \$${sport['sport_final_price_per_slot']?.toStringAsFixed(2) ?? '0.00'}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 6),
                        _buildStatusBadge(sport['status'] ?? 'Unknown'),
                      ],
                    ),
                  ),

                  // 3 Dots Menu
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'edit') {
                        _addOrUpdateSport(sport, index);
                      } else if (value == 'delete') {
                        _deleteSport(index);
                      }
                    },
                    itemBuilder: (context) => [
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
      ),
    );
  }

  Widget _buildImagePlaceholder() {
    return Container(
      color: Colors.grey.shade100,
      child: Icon(Icons.sports_soccer, size: 40, color: Colors.grey.shade400),
    );
  }

  Widget _buildStatusBadge(String status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: status == 'Active'
            ? Colors.green.withOpacity(0.1)
            : Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: status == 'Active' ? Colors.green : Colors.red,
          width: 1,
        ),
      ),
      child: Text(
        status,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: status == 'Active' ? Colors.green : Colors.red,
        ),
      ),
    );
  }
}
