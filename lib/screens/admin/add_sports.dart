import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sportspark/utils/const/const.dart';
import 'package:sportspark/utils/snackbar/snackbar.dart';

class AddEditSportScreen extends StatefulWidget {
  final Map<String, dynamic>? sport;
  const AddEditSportScreen({super.key, this.sport});

  @override
  State<AddEditSportScreen> createState() => _AddEditSportScreenState();
}

class _AddEditSportScreenState extends State<AddEditSportScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _GroundnameController = TextEditingController();
  final TextEditingController _actualPriceController = TextEditingController();
  final TextEditingController _finalPriceController = TextEditingController();
  final TextEditingController _aboutController = TextEditingController();

  String _status = 'Active';
  String? _selectedGround;
  File? _sportImage;
  File? _bannerImage;

  final List<String> _groundList = [
    'Main Turf Ground',
    'Indoor Badminton Court',
    'Tennis Arena',
    'Basketball Court',
    'Cricket Nets',
    'Skating Rink',
  ];

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
      _selectedGround = widget.sport!['ground_name'];
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _actualPriceController.dispose();
    _finalPriceController.dispose();
    _GroundnameController.dispose();
    _aboutController.dispose();
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
    if (_selectedGround == null) {
      Messenger.alertError('Please select a ground name');
      return;
    }

    final sportData = {
      'sport_name': _nameController.text.trim(),
      'ground_name': _selectedGround,
      'sport_actual_price_per_slot':
          double.tryParse(_actualPriceController.text.trim()) ?? 0.0,
      'sport_final_price_per_slot':
          double.tryParse(_finalPriceController.text.trim()) ?? 0.0,
      'about_sport': _aboutController.text.trim(),
      'status': _status,
      'sport_image': _sportImage?.path,
      'sport_banner': _bannerImage?.path,
    };

    Messenger.alertSuccess(
      widget.sport != null ? 'Sport Updated!' : 'Sport Added!',
    );

    Navigator.pop(context, sportData);
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
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: const Offset(0, 2),
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

                  _buildTextField(
                    'Ground Name ',
                    _GroundnameController,
                    type: TextInputType.name,
                  ),

                  const SizedBox(height: 16),

                  _buildTextField(
                    'Actual Price per Slot',
                    _actualPriceController,
                    type: TextInputType.number,
                  ),
                  const SizedBox(height: 16),

                  _buildTextField(
                    'Final Price per Slot',
                    _finalPriceController,
                    type: TextInputType.number,
                  ),
                  const SizedBox(height: 16),

                  _buildTextField(
                    'About Sport',
                    _aboutController,
                    required: true,
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
