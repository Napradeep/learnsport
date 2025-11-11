import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sportspark/screens/admin/profile_service/profile_provider.dart';
import 'package:sportspark/utils/const/const.dart';
import 'package:sportspark/utils/snackbar/snackbar.dart';
import 'package:sportspark/utils/widget/custom_text_field.dart';

class MyProfileScreen extends StatefulWidget {
  final bool isEdit;

  const MyProfileScreen({super.key, this.isEdit = false});

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _fatherNameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _emailController = TextEditingController();
  final _nativePlaceController = TextEditingController();
  final _aadharController = TextEditingController();
  final _addressController = TextEditingController();

  late bool _isEditMode;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _isEditMode = widget.isEdit;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<ProfileProvider>(context, listen: false);
      provider.fetchProfile().then((_) {
        _populateFields(provider.user);
      });
    });
  }

  void _populateFields(Map<String, dynamic> userData) {
    _nameController.text = userData['name'] ?? '';
    _fatherNameController.text = userData['father_name'] ?? '';
    _mobileController.text = userData['mobile'] ?? '';
    _emailController.text = userData['email'] ?? '';
    _nativePlaceController.text = userData['native_place'] ?? '';
    _aadharController.text = userData['aadhar_number'] ?? '';
    _addressController.text = userData['address'] ?? '';
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    final provider = Provider.of<ProfileProvider>(context, listen: false);
    final userId = provider.user['_id'];
    final updatedData = {
      'name': _nameController.text.trim(),
      'father_name': _fatherNameController.text.trim(),
      'mobile': _mobileController.text.trim(),
      'email': _emailController.text.trim(),
      'native_place': _nativePlaceController.text.trim(),
      'aadhar_number': _aadharController.text.trim(),
      'address': _addressController.text.trim(),
    };

    final success = await provider.updateProfile(updatedData, userId);

    if (!mounted) return;

    setState(() => _isSaving = false);

    if (success) {
      // refresh parent on return
      Navigator.pop(context, true);
    }
  }

  Future<void> _refreshProfile() async {
    final provider = Provider.of<ProfileProvider>(context, listen: false);
    await provider.fetchProfile();
    _populateFields(provider.user);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProfileProvider()..fetchProfile(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: AppColors.bluePrimaryDual,
          iconTheme: const IconThemeData(color: Colors.white),
          title: Text(
            _isEditMode ? 'Edit Profile' : 'My Profile',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22,
              color: Colors.white,
            ),
          ),
          actions: [
            if (!_isEditMode)
              IconButton(
                icon: const Icon(Icons.edit_outlined, color: Colors.white),
                tooltip: 'Edit',
                onPressed: () async {
                  final updated = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const MyProfileScreen(isEdit: true),
                    ),
                  );
                  // ✅ Refresh after returning from edit
                  if (updated == true) {
                    await _refreshProfile();
                  }
                },
              )
            else
              IconButton(
                icon: _isSaving
                    ? const Padding(
                        padding: EdgeInsets.all(8),
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        ),
                      )
                    : const Icon(Icons.save_outlined, color: Colors.white),
                tooltip: 'Save',
                onPressed: _isSaving ? null : _saveProfile,
              ),
          ],
        ),
        body: Consumer<ProfileProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading) {
              // ✨ Shimmer-like loader while profile loads
              return const Center(
                child: CircularProgressIndicator(
                  color: AppColors.bluePrimaryDual,
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: _refreshProfile,
              color: AppColors.bluePrimaryDual,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      _buildProfileImage(provider),
                      const SizedBox(height: 24),
                      _buildTextField(
                        controller: _nameController,
                        label: 'Name',
                        icon: Icons.person_outline,
                        readOnly: !_isEditMode,
                        validator: (v) =>
                            v == null || v.isEmpty ? 'Enter your name' : null,
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: _fatherNameController,
                        label: 'Father\'s Name',
                        icon: Icons.person_outline,
                        readOnly: !_isEditMode,
                        validator: (v) => v == null || v.isEmpty
                            ? 'Enter father\'s name'
                            : null,
                      ),
                      const SizedBox(height: 16),
                      GestureDetector(
                        onTap: () {
                          if (_isEditMode) {
                            Messenger.alertError(
                              "You can't change mobile number!",
                            );
                          }
                        },
                        child: AbsorbPointer(
                          absorbing: true,
                          child: _buildTextField(
                            controller: _mobileController,
                            label: 'Mobile Number',
                            icon: Icons.phone,
                            readOnly: true,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(10),
                            ],
                            validator: (v) {
                              if (v == null || v.isEmpty) {
                                return 'Enter mobile number';
                              }
                              if (v.length != 10) return 'Must be 10 digits';
                              return null;
                            },
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: _emailController,
                        label: 'Email',
                        icon: Icons.email_outlined,
                        readOnly: !_isEditMode,
                        validator: (v) {
                          if (v != null && v.isNotEmpty) {
                            if (!RegExp(
                              r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                            ).hasMatch(v)) {
                              return 'Invalid email';
                            }
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: _nativePlaceController,
                        label: 'Native Place',
                        icon: Icons.location_city,
                        readOnly: !_isEditMode,
                        validator: (v) => v == null || v.isEmpty
                            ? 'Enter native place'
                            : null,
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: _aadharController,
                        label: 'Aadhaar Number',
                        icon: Icons.credit_card,
                        readOnly: !_isEditMode,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(12),
                        ],
                        validator: (v) {
                          if (v != null && v.isNotEmpty && v.length != 12) {
                            return 'Must be 12 digits';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: _addressController,
                        label: 'Address',
                        icon: Icons.home_outlined,
                        readOnly: !_isEditMode,
                        maxLines: 3,
                        validator: (v) =>
                            v == null || v.isEmpty ? 'Enter address' : null,
                      ),
                      const SizedBox(height: 60),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildProfileImage(ProfileProvider provider) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.bluePrimaryDual, width: 3),
      ),
      child: CircleAvatar(
        radius: 60,
        backgroundColor: Colors.grey[200],
        backgroundImage: provider.user['profile'] != null
            ? NetworkImage(provider.user['profile'] as String)
            : null,
        child: provider.user['profile'] == null
            ? Icon(Icons.person, size: 80, color: AppColors.bluePrimaryDual)
            : null,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool readOnly = false,
    int maxLines = 1,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
  }) {
    return MyTextFormFieldBox(
      controller: controller,
      hinttext: 'Enter $label',
      labelText: label,
      readOnly: readOnly,
      maxLines: maxLines,
      inputFormatters: inputFormatters,
      validator: validator,
      icon: Icon(icon, color: AppColors.iconColor),
    );
  }
}
