import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sportspark/screens/login/provider/auth_provider.dart';
import 'package:sportspark/utils/const/const.dart';
import 'package:sportspark/utils/router/router.dart';
import 'package:sportspark/utils/snackbar/snackbar.dart';
import 'package:sportspark/utils/widget/custom_text_field.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isLoading = false;
  bool _showCurrent = false;
  bool _showNew = false;
  bool _showConfirm = false;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _updatePassword() async {
    if (!_formKey.currentState!.validate()) {
      // Clear confirm field if validation fails for better UX
      _confirmPasswordController.clear();
      return;
    }

    setState(() => _isLoading = true);

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    bool success = await authProvider.updatePassword(
      _currentPasswordController.text.trim(),
      _newPasswordController.text.trim(),
    );

    setState(() => _isLoading = false);

    if (success) {
      Messenger.alertSuccess('Password updated successfully');
      MyRouter.pop();
    } else {
      Messenger.alertError('❌ Failed to update password. Try again!');
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Change Password'),
        foregroundColor: Colors.white,
        backgroundColor: AppColors.bluePrimaryDual,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 400),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade300,
                  blurRadius: 12,
                  spreadRadius: 2,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Image.asset('assets/applogo.png', height: 100),
                  const SizedBox(height: 16),
                  const Text(
                    "Change Password",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: AppColors.bluePrimaryDual,
                    ),
                  ),

                  const SizedBox(height: 30),

                  /// Current Password
                  MyTextFormFieldBox(
                    controller: _currentPasswordController,
                    labelText: 'Current Password',
                    icon: const Icon(Icons.lock_outline),
                    obscureText: !_showCurrent,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _showCurrent ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () =>
                          setState(() => _showCurrent = !_showCurrent),
                    ),
                    validator: (value) =>
                        value!.isEmpty ? 'Enter your current password' : null,
                  ),
                  const SizedBox(height: 20),

                  /// New Password
                  MyTextFormFieldBox(
                    controller: _newPasswordController,
                    labelText: 'New Password',
                    icon: const Icon(Icons.lock_reset),
                    obscureText: !_showNew,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _showNew ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () => setState(() => _showNew = !_showNew),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) return 'Enter a new password';
                      if (value.length < 6) return 'Min 6 characters required';
                      // Optional: Basic strength check
                      if (!RegExp(
                        r'(?=.*[a-z])(?=.*[A-Z])|(?=.*\d)',
                      ).hasMatch(value)) {
                        return 'Use at least one uppercase, lowercase, or number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  /// Confirm Password
                  MyTextFormFieldBox(
                    controller: _confirmPasswordController,
                    labelText: 'Confirm Password',
                    icon: const Icon(Icons.check_circle_outline),
                    obscureText: !_showConfirm,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _showConfirm ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () =>
                          setState(() => _showConfirm = !_showConfirm),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) return 'Confirm your password';
                      if (value != _newPasswordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 30),

                  /// Button
                  SizedBox(
                    width: width,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.bluePrimaryDual,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: _isLoading ? null : _updatePassword,
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              'Update Password',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
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
