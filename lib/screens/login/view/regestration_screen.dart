import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sportspark/screens/home_screen.dart';
import 'package:sportspark/screens/login/model/register_request.dart';
import 'package:sportspark/screens/login/provider/auth_provider.dart';
import 'package:sportspark/utils/const/const.dart';
import 'package:sportspark/utils/router/router.dart';
import 'package:sportspark/utils/snackbar/snackbar.dart';
import 'package:sportspark/utils/validator/validator.dart';
import 'package:sportspark/utils/widget/country_text.dart';
import 'package:sportspark/utils/widget/custom_text_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _fatherNameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _emailController = TextEditingController();
  final _nativePlaceController = TextEditingController();
  final _aadharNumberController = TextEditingController();
  final _addressController = TextEditingController();
  final _countryCodeController = TextEditingController(text: 'IN');
  final _mobileCodeController = TextEditingController(text: '91');
  final _passwordController = TextEditingController();

  bool _isLoading = false;
  String _role = 'user';

  @override
  void dispose() {
    _nameController.dispose();
    _fatherNameController.dispose();
    _mobileController.dispose();
    _emailController.dispose();
    _nativePlaceController.dispose();
    _aadharNumberController.dispose();
    _addressController.dispose();
    _countryCodeController.dispose();
    _mobileCodeController.dispose();
    _passwordController.dispose();
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
      mobileCode: _mobileCodeController.text.trim(),
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
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Register'),
        backgroundColor: AppColors.bluePrimaryDual,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              elevation: 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              shadowColor: Colors.grey.shade300,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      MyTextFormFieldBox(
                        controller: _nameController,
                        labelText: 'Name',
                        validator: InputValidator.validateName,
                      ),
                      const SizedBox(height: 12),
                      MyTextFormFieldBox(
                        controller: _fatherNameController,
                        labelText: 'Father Name',
                      ),
                      const SizedBox(height: 12),
                      MyTextFormFieldBox(
                        controller: _mobileController,
                        labelText: 'Mobile',
                        keyboardType: TextInputType.phone,
                        validator: InputValidator.validateMobile,
                      ),
                      const SizedBox(height: 12),
                      MyTextFormFieldBox(
                        controller: _emailController,
                        labelText: 'Email',
                        keyboardType: TextInputType.emailAddress,
                        validator: InputValidator.validateEmail,
                      ),
                      const SizedBox(height: 12),
                      MyTextFormFieldBox(
                        controller: _nativePlaceController,
                        labelText: 'Native Place',
                      ),
                      const SizedBox(height: 12),
                      MyTextFormFieldBox(
                        controller: _aadharNumberController,
                        labelText: 'Aadhar Number',
                        keyboardType: TextInputType.number,
                        validator: InputValidator.validateAadhar,
                      ),
                      const SizedBox(height: 12),
                      MyTextFormFieldBox(
                        controller: _addressController,
                        labelText: 'Address',
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: PhoneNumberField(
                              countryCodeController: _countryCodeController,
                              mobileController: _mobileCodeController,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),
                      MyTextFormFieldBox(
                        controller: _passwordController,
                        labelText: 'Password',
                        obscureText: true,
                        validator: InputValidator.validatePassword,
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: _role,
                        decoration: InputDecoration(
                          labelText: 'Select Role',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                        ),
                        items: ['user', 'admin', 'superadmin'].map((
                          String value,
                        ) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value.toUpperCase()),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() => _role = newValue!);
                        },
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _register,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            backgroundColor: AppColors.bluePrimaryDual,
                          ),
                          child: _isLoading
                              ? Center(
                                  child: const CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                )
                              : const Text(
                                  'Register',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
