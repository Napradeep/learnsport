import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sportspark/screens/home_screen.dart';
import 'package:sportspark/screens/login/model/login_request.dart';
import 'package:sportspark/screens/login/provider/auth_provider.dart';
import 'package:sportspark/screens/login/view/regestration_screen.dart';
import 'package:sportspark/utils/const/const.dart';
import 'package:sportspark/utils/router/router.dart';
import 'package:sportspark/utils/snackbar/snackbar.dart';
import 'package:sportspark/utils/widget/custom_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _mobileController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _mobileController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final request = LoginRequest(
      mobile: _mobileController.text.trim(),
      password: _passwordController.text.trim(),
    );

    final success = await Provider.of<AuthProvider>(
      context,
      listen: false,
    ).login(request, 'user'); // Role fixed as user for now

    setState(() => _isLoading = false);

    if (success) {
      MyRouter.pushRemoveUntil(screen: const HomeScreen());
    } else {
      Messenger.alertError('Login failed. Please check your credentials.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.background,
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
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 10),
                  Text(
                    "Welcome Back 👋",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: AppColors.bluePrimaryDual,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "Login to continue to SportsPark",
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 30),

                  /// 📱 Mobile Field
                  MyTextFormFieldBox(
                    controller: _mobileController,
                    keyboardType: TextInputType.phone,
                    hinttext: "Enter your mobile number",
                    labelText: "Mobile Number",
                    icon: const Icon(Icons.phone, color: Colors.grey),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Mobile number is required';
                      } else if (value.length != 10) {
                        return 'Enter a valid 10-digit mobile number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  /// 🔒 Password Field
                  MyTextFormFieldBox(
                    controller: _passwordController,
                    obscureText: true,
                    hinttext: "Enter your password",
                    labelText: "Password",
                    icon: const Icon(Icons.lock, color: Colors.grey),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Password is required';
                      } else if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 30),

                  /// 🔘 Login Button
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
                      onPressed: _isLoading ? null : _login,
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              'Login',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  /// 📝 Register Link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account? "),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RegisterScreen(),
                            ),
                          );
                        },
                        child: Text(
                          "Register",
                          style: TextStyle(
                            color: AppColors.bluePrimaryDual,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
