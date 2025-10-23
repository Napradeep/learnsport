import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sportspark/utils/const/const.dart';
import 'package:sportspark/utils/snackbar/snackbar.dart';
import 'package:sportspark/utils/widget/custom_confirmation_dialog.dart';

class AddEditSportScreen extends StatefulWidget {
  final Map<String, dynamic>? sport;
  const AddEditSportScreen({super.key, this.sport});

  @override
  State<AddEditSportScreen> createState() => _AddEditSportScreenState();
}

class _AddEditSportScreenState extends State<AddEditSportScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _groundnameController = TextEditingController();
  final TextEditingController _actualPriceController = TextEditingController();
  final TextEditingController _finalPriceController = TextEditingController();
  final TextEditingController _aboutController = TextEditingController();
  final TextEditingController _halfgroundController = TextEditingController();
  final TextEditingController _fullgroundController = TextEditingController();

  String _status = 'Active';
  File? _sportImage;
  File? _bannerImage;

  @override
  void initState() {
    super.initState();
    if (widget.sport != null) {
      _nameController.text = widget.sport!['sport_name'] ?? '';
      _actualPriceController.text =
          widget.sport!['sport_actual_price_per_slot']?.toString() ?? '';
      _finalPriceController.text =
          widget.sport!['sport_final_price_per_slot']?.toString() ?? '';
      _aboutController.text = widget.sport!['about_sport'] ?? '';
      _status = widget.sport!['status'] ?? 'Active';
      _groundnameController.text = widget.sport!['ground_name'] ?? '';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _groundnameController.dispose();
    _actualPriceController.dispose();
    _finalPriceController.dispose();
    _aboutController.dispose();
    _halfgroundController.dispose();
    _fullgroundController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(bool isBanner) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        if (isBanner) {
          _bannerImage = File(pickedFile.path);
        } else {
          _sportImage = File(pickedFile.path);
        }
      });
    }
  }

  void _saveSport() {
    if (!_formKey.currentState!.validate()) return;

    if (_sportImage == null && widget.sport == null) {
      Messenger.alertError('Sport image is required');
      return;
    }

    final actualPrice =
        double.tryParse(_actualPriceController.text.trim()) ?? 0.0;
    final finalPrice =
        double.tryParse(_finalPriceController.text.trim()) ?? 0.0;

    if (finalPrice > actualPrice) {
      Messenger.alertError('Final price cannot be greater than actual price');
      return;
    }

    final sportData = {
      'sport_name': _nameController.text.trim(),
      'ground_name': _groundnameController.text.trim(),
      'sport_actual_price_per_slot': actualPrice,
      'sport_final_price_per_slot': finalPrice,
      'about_sport': _aboutController.text.trim(),
      'status': _status,
      'sport_image': _sportImage?.path,
      'sport_banner': _bannerImage?.path,
      'half_ground': _halfgroundController.text.trim(),
      'full_ground': _fullgroundController.text.trim(),
    };

    // Show confirmation dialog before saving
    CustomConfirmationDialog.show(
      context: context,
      title: widget.sport != null ? 'Update Sport' : 'Add Sport',
      message: widget.sport != null
          ? 'Are you sure you want to update this sport?'
          : 'Are you sure you want to add this sport?',
      icon: widget.sport != null ? Icons.edit : Icons.add,
      iconColor: widget.sport != null ? Colors.orange : Colors.green,
      backgroundColor: Colors.white,
      textColor: Colors.black87,
      confirmColor: AppColors.bluePrimaryDual,
      onConfirm: () {
        Navigator.pop(context, sportData);
        Messenger.alertSuccess(
          widget.sport != null ? 'Sport Updated!' : 'Sport Added!',
        );
      },
    );
  }

  Widget _buildImagePicker(String label, File? image, bool isBanner) {
    return GestureDetector(
      onTap: () => _pickImage(isBanner),
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade400),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: image != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(image, fit: BoxFit.cover),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.image, size: 40, color: Colors.grey.shade400),
                  const SizedBox(height: 8),
                  Text(
                    label,
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    TextInputType type = TextInputType.text,
    bool required = true,
    String? Function(String?)? customValidator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: type,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      validator: (value) {
        if (required && (value == null || value.isEmpty)) {
          return '$label is required';
        }
        if (customValidator != null) return customValidator(value);
        return null;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: Text(widget.sport != null ? 'Edit Sport' : 'Add Sport'),
        backgroundColor: AppColors.bluePrimaryDual,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 500),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.cardBackground,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Header
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: AppColors.bluePrimaryDual.withOpacity(
                          0.2,
                        ),
                        child: Icon(
                          Icons.sports_soccer,
                          color: AppColors.bluePrimaryDual,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        widget.sport != null
                            ? 'Edit Sport Details'
                            : 'Add New Sport',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  _buildTextField('Sport Name', _nameController),
                  const SizedBox(height: 16),

                  _buildTextField('Ground Name', _groundnameController),
                  const SizedBox(height: 16),

                  _buildTextField(
                    'Actual Price per Slot',
                    _actualPriceController,
                    type: TextInputType.number,
                    customValidator: (value) {
                      final price = double.tryParse(value ?? '');
                      if (price == null || price <= 0) {
                        return 'Enter a valid actual price';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Expanded(
                        child: _buildTextField(
                          'Half Ground',
                          _halfgroundController,
                          type: TextInputType.number,
                          required: false,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildTextField(
                          'Full Ground',
                          _fullgroundController,
                          type: TextInputType.number,
                          required: false,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  _buildTextField(
                    'Final Price per Slot',
                    _finalPriceController,
                    type: TextInputType.number,
                    customValidator: (value) {
                      final finalPrice = double.tryParse(value ?? '');
                      final actualPrice =
                          double.tryParse(_actualPriceController.text) ?? 0;
                      if (finalPrice == null || finalPrice < 0) {
                        return 'Enter a valid final price';
                      }
                      if (finalPrice > actualPrice) {
                        return 'Final price cannot exceed actual price';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  _buildTextField(
                    'About Sport',
                    _aboutController,
                    customValidator: (value) {
                      if ((value?.length ?? 0) < 10) {
                        return 'About Sport should be at least 10 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Status toggle
                  Row(
                    children: [
                      const Text('Status:', style: TextStyle(fontSize: 16)),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ToggleButtons(
                          borderRadius: BorderRadius.circular(12),
                          isSelected: [
                            _status == 'Active',
                            _status == 'Inactive',
                          ],
                          onPressed: (index) {
                            setState(() {
                              _status = index == 0 ? 'Active' : 'Inactive';
                            });
                          },
                          selectedColor: Colors.white,
                          fillColor: AppColors.bluePrimaryDual,
                          children: const [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              child: Text('Active'),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              child: Text('Inactive'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Image Pickers
                  Row(
                    children: [
                      Expanded(
                        child: _buildImagePicker(
                          'Pick Sport Image',
                          _sportImage,
                          false,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildImagePicker(
                          'Pick Banner Image',
                          _bannerImage,
                          true,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // Save Button
                  ElevatedButton(
                    onPressed: _saveSport,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.bluePrimaryDual,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      widget.sport != null ? 'Update Sport' : 'Add Sport',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
