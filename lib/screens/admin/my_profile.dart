
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sportspark/screens/admin/profile_service/profile_provider.dart';
import 'package:sportspark/utils/const/const.dart';
import 'package:sportspark/utils/snackbar/snackbar.dart';
import 'package:sportspark/utils/widget/custom_confirmation_dialog.dart';
import 'package:sportspark/utils/widget/custom_text_field.dart';

class MyProfileScreen extends StatefulWidget {
  final String checkrole;
  final bool isEdit;

  const MyProfileScreen({
    super.key,
    this.isEdit = false,
    required this.checkrole,
  });

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final _formKey = GlobalKey<FormState>();
  late final bool _isEditMode;

  // Controllers
  late final TextEditingController _nameCtrl;
  late final TextEditingController _fatherCtrl;
  late final TextEditingController _mobileCtrl;
  late final TextEditingController _emailCtrl;
  late final TextEditingController _nativeCtrl;
  late final TextEditingController _aadharCtrl;
  late final TextEditingController _addressCtrl;

  bool _isSaving = false;
  bool _controllersPopulated = false; // 🔥 FIX CORE ISSUE

  @override
  void initState() {
    super.initState();

    _isEditMode = widget.isEdit;

    _nameCtrl = TextEditingController();
    _fatherCtrl = TextEditingController();
    _mobileCtrl = TextEditingController();
    _emailCtrl = TextEditingController();
    _nativeCtrl = TextEditingController();
    _aadharCtrl = TextEditingController();
    _addressCtrl = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<ProfileProvider>();

      provider.fetchProfile().then((_) {
        if (mounted) _populateOnce(provider.user);
      });
    });
  }

  // 🔥 POPULATE ONLY ONCE (PREVENTS OVERWRITING DURING EDIT)
  void _populateOnce(Map<String, dynamic> user) {
    if (_controllersPopulated) return; // prevent overwriting
    if (user.isEmpty) return;

    _nameCtrl.text = user['name'] ?? '';
    _fatherCtrl.text = user['father_name'] ?? '';
    _mobileCtrl.text = user['mobile'] ?? '';
    _emailCtrl.text = user['email'] ?? '';
    _nativeCtrl.text = user['native_place'] ?? '';
    _aadharCtrl.text = user['aadhar_number'] ?? '';
    _addressCtrl.text = user['address'] ?? '';

    _controllersPopulated = true;
  }

  // SAVE PROFILE
  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    CustomConfirmationDialog.show(
      context: context,
      title: "Update Profile!",
      message: "Are you sure you want to update your profile?",
      icon: Icons.info_outline,
      iconColor: Colors.blue,
      confirmColor: Colors.blue,
      onConfirm: () async {
        setState(() => _isSaving = true);

        final provider = context.read<ProfileProvider>();
        final userId = provider.user['_id']?.toString();

        if (userId == null) {
          Messenger.alertError("User ID missing!");
          setState(() => _isSaving = false);
          return;
        }

        final data = {
          'name': _nameCtrl.text.trim(),
          'father_name': _fatherCtrl.text.trim(),
          'mobile': _mobileCtrl.text.trim(),
          'email': _emailCtrl.text.trim(),
          'native_place': _nativeCtrl.text.trim(),
          'aadhar_number': _aadharCtrl.text.trim(),
          'address': _addressCtrl.text.trim(),
        };

        final success = await provider.updateProfile(data, userId);

        if (!mounted) return;
        setState(() => _isSaving = false);

        if (success) {
          Messenger.alertSuccess("Profile updated!");
          Navigator.pop(context, true);
        } else {
          Messenger.alertError("Update failed!");
        }
      },
    );
  }

  @override
  void dispose() {
    if (!widget.isEdit) {
      _nameCtrl.dispose();
      _fatherCtrl.dispose();
      _mobileCtrl.dispose();
      _emailCtrl.dispose();
      _nativeCtrl.dispose();
      _aadharCtrl.dispose();
      _addressCtrl.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        
        elevation: 0,
        backgroundColor: AppColors.bluePrimaryDual,
        foregroundColor: Colors.white,
        centerTitle: false,
        title: Text(
          _isEditMode ? 'Edit Profile' : 'My Profile',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        actions: [
          if (!_isEditMode)
            widget.checkrole == "USER"
                ? const SizedBox()
                : IconButton(
                    icon: const Icon(Icons.edit_outlined),
                    onPressed: () async {
                      final updated = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => MyProfileScreen(
                            isEdit: true,
                            checkrole: widget.checkrole,
                          ),
                        ),
                      );

                      if (updated == true && mounted) {
                        _controllersPopulated = false; // allow repopulate
                        await context.read<ProfileProvider>().fetchProfile();
                      }
                    },
                  )
          else
            IconButton(
              icon: _isSaving
                  ? const CircularProgressIndicator(
                      color: Colors.white, strokeWidth: 2)
                  : const Icon(Icons.save_outlined),
              onPressed: _isSaving ? null : _saveProfile,
            )
        ],
      ),
      body: Consumer<ProfileProvider>(
        builder: (context, provider, _) {
          if (provider.user.isNotEmpty) {
            _populateOnce(provider.user);
          }

          if (provider.isLoading && provider.user.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          return _buildForm();
        },
      ),
    );
  }

  Widget _buildForm() {
    return RefreshIndicator(
      onRefresh: () async {
        _controllersPopulated = false;
        await context.read<ProfileProvider>().fetchProfile();
      },
      color: AppColors.bluePrimaryDual,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 40),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Avatar
              CircleAvatar(
                radius: 62,
                backgroundColor: Colors.grey.shade200,
                child: const Icon(Icons.person, size: 80, color: Colors.blue),
              ),
              const SizedBox(height: 30),

              _Field(
                controller: _nameCtrl,
                label: "Name",
                icon: Icons.person_outline,
                readOnly: !_isEditMode,
                validator: (v) =>
                    v!.trim().isEmpty ? "Required" : null,
              ),
              _Field(
                controller: _fatherCtrl,
                label: "Father's Name",
                icon: Icons.person_outline,
                readOnly: !_isEditMode,
                validator: (v) =>
                    v!.trim().isEmpty ? "Required" : null,
              ),
              _Field(
                controller: _mobileCtrl,
                label: "Mobile Number",
                icon: Icons.phone,
                readOnly: true,
                validator: (v) =>
                    v!.length != 10 ? "10 digits required" : null,
              ),
              _Field(
                controller: _emailCtrl,
                label: "Email",
                icon: Icons.email_outlined,
                readOnly: !_isEditMode,
                validator: (v) =>
                    v!.isNotEmpty &&
                            !RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$')
                                .hasMatch(v)
                        ? "Invalid email"
                        : null,
              ),
              _Field(
                controller: _nativeCtrl,
                label: "Native Place",
                icon: Icons.location_city,
                readOnly: !_isEditMode,
                validator: (v) =>
                    v!.trim().isEmpty ? "Required" : null,
              ),
              _Field(
                controller: _aadharCtrl,
                label: "Aadhaar Number",
                icon: Icons.credit_card,
                readOnly: !_isEditMode,
                validator: (v) =>
                    v!.length == 12 ? null : "12 digits required",
              ),
              _Field(
                controller: _addressCtrl,
                label: "Address",
                icon: Icons.home_outlined,
                maxLines: 3,
                readOnly: !_isEditMode,
                validator: (v) =>
                    v!.trim().isEmpty ? "Required" : null,
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

class _Field extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final bool readOnly;
  final int maxLines;
  final String? Function(String?)? validator;

  const _Field({
    required this.controller,
    required this.label,
    required this.icon,
    this.readOnly = false,
    this.maxLines = 1,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: MyTextFormFieldBox(
        controller: controller,
        hinttext: "Enter $label",
        labelText: label,
        readOnly: readOnly,
        maxLines: maxLines,
        validator: validator,
        icon: Icon(icon, color: AppColors.iconColor),
      ),
    );
  }
}
