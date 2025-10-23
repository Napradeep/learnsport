import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sportspark/utils/const/const.dart';
import 'package:sportspark/utils/widget/custom_confirmation_dialog.dart';
import 'package:sportspark/utils/widget/custom_text_field.dart';

class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({super.key});

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen>
    with SingleTickerProviderStateMixin {
  // Controllers for text fields
  final _nameController = TextEditingController();
  final _fatherNameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _emailController = TextEditingController();
  final _nativePlaceController = TextEditingController();
  final _aadharController = TextEditingController();
  final _addressController = TextEditingController();

  // Form key for validation
  final _formKey = GlobalKey<FormState>();

  // Track edit mode
  bool _isEditMode = false;

  // Animation controller for button transitions
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize controllers with sample data
    _nameController.text = 'John Doe';
    _fatherNameController.text = 'Michael Doe';
    _mobileController.text = '9876543210';
    _emailController.text = 'john.doe@example.com';
    _nativePlaceController.text = 'Mumbai';
    _aadharController.text = '123456789012';
    _addressController.text = '123, Main Street, Mumbai, Maharashtra';

    // Initialize animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _fatherNameController.dispose();
    _mobileController.dispose();
    _emailController.dispose();
    _nativePlaceController.dispose();
    _aadharController.dispose();
    _addressController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  // Toggle edit mode
  void _toggleEditMode() {
    setState(() {
      _isEditMode = !_isEditMode;
      _animationController.forward(from: 0);
    });
  }

  // Save profile changes
  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      final updatedTime = DateTime.now();
      final formattedTime =
          "${updatedTime.day}-${updatedTime.month}-${updatedTime.year} ${updatedTime.hour}:${updatedTime.minute.toString().padLeft(2, '0')}";

      CustomConfirmationDialog.show(
        context: context,
        title: 'Profile Updated',
        message: 'Are you sure you want update profile',
        //'Your profile was successfully updated on $formattedTime',
        icon: Icons.check_circle_outline,
        iconColor: Colors.green,
        backgroundColor: Colors.white,
        textColor: Colors.black87,
        confirmColor: AppColors.bluePrimaryDual,
        onConfirm: () {
          setState(() {
            _isEditMode = false;
          });
        },
      );
    }
  }

  // void _saveProfile() {
  //   if (_formKey.currentState!.validate()) {
  //     setState(() {
  //       _isEditMode = false;
  //       _animationController.forward(from: 0);
  //     });
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text('Profile updated successfully!')),
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        elevation: 0,

        backgroundColor: AppColors.bluePrimaryDual,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'My Profile',

          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Colors.white,
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Profile Icon
                Container(
                  margin: const EdgeInsets.only(top: 20, bottom: 20),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.bluePrimaryDual,
                      width: 3,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.grey[200],
                    child: Icon(
                      Icons.person,
                      size: 80,
                      color: AppColors.bluePrimaryDual,
                    ),
                  ),
                ),

                // Name Field
                MyTextFormFieldBox(
                  controller: _nameController,
                  hinttext: 'Enter your name',
                  labelText: 'Name',
                  readOnly: !_isEditMode,
                  keyboardType: TextInputType.name,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    if (value.length < 2) {
                      return 'Name must be at least 2 characters';
                    }
                    return null;
                  },
                  icon: const Icon(
                    Icons.person_outline,
                    color: AppColors.iconColor,
                  ),
                ),
                const SizedBox(height: 16),

                // Father's Name Field
                MyTextFormFieldBox(
                  controller: _fatherNameController,
                  hinttext: 'Enter father\'s name',
                  labelText: 'Father\'s Name',
                  readOnly: !_isEditMode,
                  keyboardType: TextInputType.name,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter father\'s name';
                    }
                    return null;
                  },
                  icon: const Icon(
                    Icons.person_outline,
                    color: AppColors.iconColor,
                  ),
                ),
                const SizedBox(height: 16),

                // Mobile Field
                MyTextFormFieldBox(
                  controller: _mobileController,
                  hinttext: 'Enter mobile number',
                  labelText: 'Mobile Number',
                  readOnly: !_isEditMode,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10),
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter mobile number';
                    }
                    if (value.length != 10) {
                      return 'Mobile number must be 10 digits';
                    }
                    return null;
                  },
                  icon: const Icon(Icons.phone, color: AppColors.iconColor),
                ),
                const SizedBox(height: 16),

                // Email Field (Optional)
                MyTextFormFieldBox(
                  controller: _emailController,
                  hinttext: 'Enter email (optional)',
                  labelText: 'Email',
                  readOnly: !_isEditMode,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value != null && value.isNotEmpty) {
                      if (!RegExp(
                        r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                      ).hasMatch(value)) {
                        return 'Please enter a valid email';
                      }
                    }
                    return null;
                  },
                  icon: const Icon(
                    Icons.email_outlined,
                    color: AppColors.iconColor,
                  ),
                ),
                const SizedBox(height: 16),

                // Native Place Field
                MyTextFormFieldBox(
                  controller: _nativePlaceController,
                  hinttext: 'Enter native place',
                  labelText: 'Native Place',
                  readOnly: !_isEditMode,
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter native place';
                    }
                    return null;
                  },
                  icon: const Icon(
                    Icons.location_city,
                    color: AppColors.iconColor,
                  ),
                ),
                const SizedBox(height: 16),

                // Aadhaar Number Field
                MyTextFormFieldBox(
                  controller: _aadharController,
                  hinttext: 'Enter Aadhaar number',
                  labelText: 'Aadhaar Number',
                  readOnly: !_isEditMode,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(12),
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Aadhaar number';
                    }
                    if (value.length != 12) {
                      return 'Aadhaar number must be 12 digits';
                    }
                    return null;
                  },
                  icon: const Icon(
                    Icons.credit_card,
                    color: AppColors.iconColor,
                  ),
                ),
                const SizedBox(height: 16),

                // Address Field
                MyTextFormFieldBox(
                  controller: _addressController,
                  hinttext: 'Enter address',
                  labelText: 'Address',
                  readOnly: !_isEditMode,
                  maxLines: 3,
                  keyboardType: TextInputType.multiline,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter address';
                    }
                    return null;
                  },
                  icon: const Icon(
                    Icons.home_outlined,
                    color: AppColors.iconColor,
                  ),
                ),
                const SizedBox(height: 24),

                // Edit/Save Button
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: ElevatedButton(
                    onPressed: _isEditMode ? _saveProfile : _toggleEditMode,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.bluePrimaryDual,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 3,
                    ),
                    child: Text(
                      _isEditMode ? 'Save Profile' : 'Edit Profile',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
