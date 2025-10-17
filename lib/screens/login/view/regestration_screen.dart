import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sportspark/screens/home_screen.dart';
import 'package:sportspark/screens/login/model/register_request.dart';
import 'package:sportspark/screens/login/provider/auth_provider.dart';
import 'package:sportspark/utils/const/const.dart';
import 'package:sportspark/utils/router/router.dart';
import 'package:sportspark/utils/snackbar/snackbar.dart';
import 'package:sportspark/utils/validator/validator.dart';
import 'package:sportspark/utils/widget/custom_text_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  late TabController _tabController;

  final _nameController = TextEditingController();
  final _fatherNameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _emailController = TextEditingController();
  final _nativePlaceController = TextEditingController();
  final _aadharNumberController = TextEditingController();
  final _addressController = TextEditingController();
  final _countryCodeController = TextEditingController(text: 'in');
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  String _role = 'user';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _role = _tabController.index == 0 ? 'user' : 'admin';
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _nameController.dispose();
    _fatherNameController.dispose();
    _mobileController.dispose();
    _emailController.dispose();
    _nativePlaceController.dispose();
    _aadharNumberController.dispose();
    _addressController.dispose();
    _countryCodeController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final request = RegisterRequest(
      name: _nameController.text.trim(),
      fatherName: _fatherNameController.text.trim(),
      mobile: _mobileController.text.trim(),
      email: _emailController.text.trim(),
      nativePlace: _nativePlaceController.text.trim(),
      aadharNumber: _aadharNumberController.text.trim(),
      address: _addressController.text.trim(),
      countryCode: _countryCodeController.text.trim(),
      mobileCode: '91',
      password: _passwordController.text.trim(),
    );

    try {
      final success = await Provider.of<AuthProvider>(
        context,
        listen: false,
      ).register(request, _role);

      setState(() => _isLoading = false);

      if (success) {
        Messenger.alertSuccess('Registration successful');
        MyRouter.pushRemoveUntil(screen: const HomeScreen());
      } else {
        Messenger.alertError('Registration failed. Please check your details.');
      }
    } catch (e) {
      setState(() => _isLoading = false);
      Messenger.alertError('Server error. Please try again later.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.bluePrimaryDual,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Create Account',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorWeight: 3,
          tabs: const [
            Tab(text: 'USER'),
            Tab(text: 'ADMIN'),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Let's get you started 🚀",
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.bluePrimaryDual,
              ),
            ),
            const SizedBox(height: 20),

            // Registration Card
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.white, Colors.blue.shade50],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12.withOpacity(0.08),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    MyTextFormFieldBox(
                      controller: _nameController,
                      labelText: 'Full Name',
                      validator: InputValidator.validateName,
                    ),
                    const SizedBox(height: 14),
                    MyTextFormFieldBox(
                      controller: _fatherNameController,
                      labelText: 'Father Name',
                    ),
                    const SizedBox(height: 14),
                    MyTextFormFieldBox(
                      controller: _mobileController,
                      labelText: 'Mobile Number',
                      keyboardType: TextInputType.phone,
                      validator: InputValidator.validateMobile,
                    ),
                    const SizedBox(height: 14),
                    MyTextFormFieldBox(
                      controller: _emailController,
                      labelText: 'Email Address',
                      keyboardType: TextInputType.emailAddress,
                      validator: InputValidator.validateEmail,
                    ),
                    const SizedBox(height: 14),
                    MyTextFormFieldBox(
                      controller: _nativePlaceController,
                      labelText: 'Native Place',
                    ),
                    const SizedBox(height: 14),
                    MyTextFormFieldBox(
                      controller: _aadharNumberController,
                      labelText: 'Aadhar Number',
                      keyboardType: TextInputType.number,
                      validator: InputValidator.validateAadhar,
                    ),
                    const SizedBox(height: 14),
                    MyTextFormFieldBox(
                      controller: _addressController,
                      labelText: 'Address',
                    ),
                    const SizedBox(height: 14),
                    MyTextFormFieldBox(
                      controller: _passwordController,
                      labelText: 'Password',
                      obscureText: _obscurePassword,
                      validator: InputValidator.validatePassword,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.grey.shade600,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                    ),

                    const SizedBox(height: 14),
                    MyTextFormFieldBox(
                      controller: _confirmPasswordController,
                      obscureText: _obscureConfirmPassword,
                      labelText: 'Confirm Password',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please confirm your password';
                        } else if (value != _passwordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },

                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureConfirmPassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.grey.shade600,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureConfirmPassword = !_obscureConfirmPassword;
                          });
                        },
                      ),
                    ),

                    const SizedBox(height: 26),

                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.bluePrimaryDual,
                            AppColors.bluePrimaryDual.withOpacity(0.8),
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _register,
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text(
                                'Register Now',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
