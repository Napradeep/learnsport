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

  late final TextEditingController _nameController;
  late final TextEditingController _groundNameController;
  late final TextEditingController _actualPriceController;
  late final TextEditingController _finalPriceController;
  late final TextEditingController _aboutController;
  late final TextEditingController _halfLightController;
  late final TextEditingController _fullLightController;

  File? _sportImage;
  File? _bannerImage;
  String _status = 'AVAILABLE';

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.sport?['name'] ?? '');
    _groundNameController = TextEditingController(
      text: widget.sport?['ground_name'] ?? '',
    );
    _actualPriceController = TextEditingController(
      text: widget.sport?['actual_price_per_slot']?.toString() ?? '',
    );
    _finalPriceController = TextEditingController(
      text: widget.sport?['final_price_per_slot']?.toString() ?? '',
    );
    _aboutController = TextEditingController(
      text: widget.sport?['about'] ?? '',
    );
    _halfLightController = TextEditingController(
      text: widget.sport?['sport_lighting_price_half']?.toString() ?? '',
    );
    _fullLightController = TextEditingController(
      text: widget.sport?['sport_lighting_price_full']?.toString() ?? '',
    );

    final apiStatus = (widget.sport?['status'] ?? 'AVAILABLE')
        .toString()
        .toUpperCase();
    _status = apiStatus == 'AVAILABLE' ? 'AVAILABLE' : 'NOT_AVAILABLE';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _groundNameController.dispose();
    _actualPriceController.dispose();
    _finalPriceController.dispose();
    _aboutController.dispose();
    _halfLightController.dispose();
    _fullLightController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(bool isBanner) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (picked != null) {
      setState(() {
        if (isBanner) {
          _bannerImage = File(picked.path);
        } else {
          _sportImage = File(picked.path);
        }
      });
    }
  }

  void _saveSport() {
    if (!_formKey.currentState!.validate()) return;

    final actual = double.tryParse(_actualPriceController.text) ?? 0;
    final finalP = double.tryParse(_finalPriceController.text) ?? 0;

    if (finalP > actual) {
      Messenger.alertError('Final price cannot exceed actual price');
      return;
    }

    final data = {
      'name': _nameController.text.trim(),
      'ground_name': _groundNameController.text.trim(),
      'actual_price_per_slot': actual,
      'final_price_per_slot': finalP,
      'about': _aboutController.text.trim(),
      'sport_lighting_price_half': _halfLightController.text.trim().isEmpty
          ? '0'
          : _halfLightController.text.trim(),
      'sport_lighting_price_full': _fullLightController.text.trim().isEmpty
          ? '0'
          : _fullLightController.text.trim(),
      'status': _status,
      'image': _sportImage,
      'banner': _bannerImage,
    };

    CustomConfirmationDialog.show(
      context: context,
      title: widget.sport != null ? 'Update Sport' : 'Add Sport',
      message: widget.sport != null ? 'Update this sport?' : 'Add this sport?',
      icon: widget.sport != null ? Icons.edit : Icons.add,
      iconColor: widget.sport != null ? Colors.orange : Colors.green,
      confirmColor: AppColors.bluePrimaryDual,
      onConfirm: () => Navigator.pop(context, data),
      backgroundColor: AppColors.background,
      textColor: AppColors.textPrimary,
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
        ),
        child: image != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(image, fit: BoxFit.cover),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.image, size: 40, color: Colors.grey.shade500),
                  const SizedBox(height: 8),
                  Text(
                    label,
                    style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    bool required = true,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 16,
        ),
      ),
      validator: (value) {
        if (required && (value == null || value.trim().isEmpty)) {
          return '$label is required';
        }
        return validator?.call(value);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(widget.sport != null ? 'Edit Sport' : 'Add Sport'),
        backgroundColor: AppColors.bluePrimaryDual,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 600),
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

                  _buildTextField(
                    label: 'Sport Name',
                    controller: _nameController,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    label: 'Ground Name',
                    controller: _groundNameController,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    label: 'Actual Price',
                    controller: _actualPriceController,
                    keyboardType: TextInputType.number,
                    validator: (v) => (double.tryParse(v ?? '') ?? 0) <= 0
                        ? 'Enter valid price'
                        : null,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    label: 'Final Price',
                    controller: _finalPriceController,
                    keyboardType: TextInputType.number,
                    validator: (v) {
                      final f = double.tryParse(v ?? '') ?? 0;
                      final a =
                          double.tryParse(_actualPriceController.text) ?? 0;
                      return f > a ? 'Cannot exceed actual price' : null;
                    },
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Text(
                        'Lighting Price:',
                        style: TextStyle(fontSize: 16),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildTextField(
                          label: 'Half Ground',
                          controller: _halfLightController,
                          keyboardType: TextInputType.number,
                          required: true, // ✅ Make required
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) {
                              return 'Half Ground price required';
                            }
                            if ((double.tryParse(v) ?? 0) <= 0) {
                              return 'Enter valid price';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildTextField(
                          label: 'Full Ground',
                          controller: _fullLightController,
                          keyboardType: TextInputType.number,
                          required: true, // ✅ Make required
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) {
                              return 'Full Ground price required';
                            }
                            if ((double.tryParse(v) ?? 0) <= 0) {
                              return 'Enter valid price';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),
                  _buildTextField(
                    label: 'About Sport',
                    controller: _aboutController,
                    validator: (v) =>
                        (v?.length ?? 0) < 10 ? 'Min 10 characters' : null,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Text('Status:', style: TextStyle(fontSize: 16)),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ToggleButtons(
                          isSelected: [
                            _status == 'AVAILABLE',
                            _status == 'NOT_AVAILABLE',
                          ],
                          onPressed: (i) => setState(
                            () => _status = i == 0
                                ? 'AVAILABLE'
                                : 'NOT_AVAILABLE',
                          ),
                          borderRadius: BorderRadius.circular(12),
                          selectedColor: Colors.white,
                          fillColor: AppColors.bluePrimaryDual,
                          children: const [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: Text('Available'),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: Text('Not Available'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: _buildImagePicker(
                          'Sport Image',
                          _sportImage,
                          false,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildImagePicker(
                          'Banner Image',
                          _bannerImage,
                          true,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
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
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
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
