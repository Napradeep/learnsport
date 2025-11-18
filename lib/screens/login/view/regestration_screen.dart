// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:sportspark/screens/login/model/register_request.dart';
// import 'package:sportspark/screens/login/provider/auth_provider.dart';
// import 'package:sportspark/utils/const/const.dart';
// import 'package:sportspark/utils/snackbar/snackbar.dart';
// import 'package:sportspark/utils/validator/validator.dart';
// import 'package:sportspark/utils/widget/custom_text_field.dart';

// class RegisterScreen extends StatefulWidget {
//   const RegisterScreen({super.key});

//   @override
//   State<RegisterScreen> createState() => _RegisterScreenState();
// }

// class _RegisterScreenState extends State<RegisterScreen>
//     with SingleTickerProviderStateMixin {
//   final _formKey = GlobalKey<FormState>();
//   late TabController _tabController;

//   // Form Controllers
//   final _nameController = TextEditingController();
//   final _fatherNameController = TextEditingController();
//   final _mobileController = TextEditingController();
//   final _emailController = TextEditingController();
//   final _nativePlaceController = TextEditingController();
//   final _aadharNumberController = TextEditingController();
//   final _addressController = TextEditingController();
//   final _countryCodeController = TextEditingController(text: 'in');
//   final _passwordController = TextEditingController();
//   final _confirmPasswordController = TextEditingController();

//   // OTP Controllers
//   final List<TextEditingController> _otpControllers = List.generate(
//     6,
//     (_) => TextEditingController(),
//   );
//   final List<FocusNode> _otpFocusNodes = List.generate(6, (_) => FocusNode());

//   // State Flags
//   bool _isLoading = false;
//   bool _isOtpSending = false;
//   bool _isOtpSent = false;
//   bool _isOtpVerified = false;
//   int _countdown = 0;
//   Timer? _countdownTimer;

//   bool _obscurePassword = true;
//   bool _obscureConfirmPassword = true;
//   String _role = 'user';

//   // For managing bottom sheet state
//   Function(void Function())? _modalSetState;

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 2, vsync: this);
//     _tabController.addListener(_handleTabChange);
//   }

//   void _handleTabChange() {
//     if (_tabController.indexIsChanging) return;
//     setState(() {
//       _role = _tabController.index == 0 ? 'user' : 'admin';
//       _resetFormAndOtp();
//     });
//   }

//   void _resetFormAndOtp() {
//     _nameController.clear();
//     _fatherNameController.clear();
//     _mobileController.clear();
//     _emailController.clear();
//     _nativePlaceController.clear();
//     _aadharNumberController.clear();
//     _addressController.clear();
//     _passwordController.clear();
//     _confirmPasswordController.clear();
//     for (var c in _otpControllers) c.clear();

//     _isOtpSent = false;
//     _isOtpVerified = false;
//     _isOtpSending = false;
//     _countdown = 0;
//     _countdownTimer?.cancel();
//     _modalSetState = null;
//   }

//   @override
//   void dispose() {
//     _tabController.removeListener(_handleTabChange);
//     _tabController.dispose();
//     _nameController.dispose();
//     _fatherNameController.dispose();
//     _mobileController.dispose();
//     _emailController.dispose();
//     _nativePlaceController.dispose();
//     _aadharNumberController.dispose();
//     _addressController.dispose();
//     _countryCodeController.dispose();
//     _passwordController.dispose();
//     _confirmPasswordController.dispose();
//     for (final c in _otpControllers) c.dispose();
//     for (final f in _otpFocusNodes) f.dispose();
//     _countdownTimer?.cancel();
//     super.dispose();
//   }

//   Future<void> _sendOtpLocally() async {
//     final mobile = _mobileController.text.trim();
//     final validatorMsg = InputValidator.validateMobile(mobile);
//     if (validatorMsg != null) {
//       Messenger.alertError(validatorMsg);
//       return;
//     }

//     setState(() => _isOtpSending = true);

//     await Future.delayed(const Duration(seconds: 1));

//     if (!mounted) return;

//     setState(() {
//       _isOtpSending = false;
//       _isOtpSent = true;
//       _isOtpVerified = false;
//       _countdown = 30;
//     });

//     _startCountdown();
//     _showOtpBottomSheet(); // Show once

//     Messenger.alertSuccess('OTP sent to $mobile');
//   }

//   void _startCountdown() {
//     _countdownTimer?.cancel();
//     _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
//       if (!mounted) {
//         timer.cancel();
//         return;
//       }

//       if (_countdown > 0) {
//         _countdown--;
//         _modalSetState?.call(() {});
//         setState(() {});
//       } else {
//         timer.cancel();
//         _modalSetState?.call(() {});
//       }
//     });
//   }

//   Future<void> _resendOtp() async {
//     if (_isOtpSending || _countdown > 0) return;

//     setState(() => _isOtpSending = true);

//     await Future.delayed(const Duration(milliseconds: 500));

//     if (!mounted) return;

//     setState(() {
//       _isOtpSending = false;
//       _isOtpSent = true;
//       _isOtpVerified = false;
//       _countdown = 30;
//     });

//     _startCountdown(); // Reuse same timer & sheet
//     Messenger.alertSuccess('OTP resent successfully');
//   }

//   // MARK: - OTP Bottom Sheet (Single Instance, Live Update)
//   void _showOtpBottomSheet() {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       isDismissible: !_isOtpVerified,
//       enableDrag: !_isOtpVerified,
//       builder: (context) {
//         return StatefulBuilder(
//           builder: (modalContext, setModalState) {
//             _modalSetState = setModalState; // Capture for timer

//             return AnimatedPadding(
//               duration: const Duration(milliseconds: 200),
//               padding: EdgeInsets.only(
//                 bottom: MediaQuery.of(context).viewInsets.bottom,
//               ),
//               child: Container(
//                 decoration: const BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
//                 ),
//                 padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     // Drag handle
//                     Container(
//                       width: 48,
//                       height: 5,
//                       margin: const EdgeInsets.only(bottom: 16),
//                       decoration: BoxDecoration(
//                         color: Colors.grey.shade300,
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                     ),
//                     Text(
//                       'Verify OTP',
//                       style: Theme.of(context).textTheme.titleLarge!.copyWith(
//                         fontWeight: FontWeight.bold,
//                         color: Colors.black87,
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     Text(
//                       'Code sent to ${_mobileController.text.trim()}',
//                       style: TextStyle(
//                         color: Colors.grey.shade600,
//                         fontSize: 14,
//                       ),
//                     ),
//                     const SizedBox(height: 32),
//                     _buildOtpFields(modalContext),
//                     const SizedBox(height: 32),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         TextButton(
//                           onPressed: _countdown > 0 ? null : _resendOtp,
//                           child: Text(
//                             _countdown > 0
//                                 ? 'Resend in $_countdown s'
//                                 : 'Resend OTP',
//                             style: TextStyle(
//                               color: _countdown > 0
//                                   ? Colors.grey
//                                   : AppColors.bluePrimaryDual,
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),
//                         ),
//                         ElevatedButton(
//                           onPressed: _isOtpSending ? null : _verifyOtpLocally,
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: AppColors.bluePrimaryDual,
//                             elevation: 2,
//                             padding: const EdgeInsets.symmetric(
//                               horizontal: 32,
//                               vertical: 14,
//                             ),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(14),
//                             ),
//                           ),
//                           child: _isOtpSending
//                               ? const SizedBox(
//                                   height: 16,
//                                   width: 16,
//                                   child: CircularProgressIndicator(
//                                     color: Colors.white,
//                                     strokeWidth: 2,
//                                   ),
//                                 )
//                               : const Text(
//                                   'Verify',
//                                   style: TextStyle(
//                                     color: Colors.white,
//                                     fontSize: 16,
//                                     fontWeight: FontWeight.w600,
//                                   ),
//                                 ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           },
//         );
//       },
//     ).whenComplete(() {
//       _countdownTimer?.cancel();
//       _modalSetState = null;
//     });
//   }

//   Widget _buildOtpFields(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: List.generate(6, (index) {
//         return SizedBox(
//           width: 48,
//           height: 56,
//           child: TextField(
//             controller: _otpControllers[index],
//             focusNode: _otpFocusNodes[index],
//             keyboardType: TextInputType.number,
//             textAlign: TextAlign.center,
//             maxLength: 1,
//             style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             decoration: InputDecoration(
//               counterText: '',
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(12),
//                 borderSide: BorderSide(color: Colors.grey.shade300),
//               ),
//               focusedBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(12),
//                 borderSide: const BorderSide(color: Colors.blue, width: 2),
//               ),
//             ),
//             onChanged: (value) {
//               if (value.isNotEmpty && index < 5) {
//                 FocusScope.of(context).requestFocus(_otpFocusNodes[index + 1]);
//               } else if (value.isEmpty && index > 0) {
//                 FocusScope.of(context).requestFocus(_otpFocusNodes[index - 1]);
//               }
//             },
//           ),
//         );
//       }),
//     );
//   }

//   Future<void> _verifyOtpLocally() async {
//     final otp = _otpControllers.map((e) => e.text).join();
//     if (otp.length != 6 || !RegExp(r'^\d{6}$').hasMatch(otp)) {
//       Messenger.alertError('Enter valid 6-digit OTP');
//       return;
//     }

//     await Future.delayed(const Duration(milliseconds: 800));

//     if (!mounted) return;

//     setState(() => _isOtpVerified = true);

//     Navigator.pop(context); // Close sheet
//     Messenger.alertSuccess('OTP Verified Successfully!');
//   }

//   // MARK: - Final Registration
//   Future<void> _register() async {
//     if (!_formKey.currentState!.validate()) return;
//     if (!_isOtpVerified) {
//       Messenger.alertError('Please verify OTP first');
//       return;
//     }

//     setState(() => _isLoading = true);

//     final request = RegisterRequest(
//       name: _nameController.text.trim(),
//       fatherName: _fatherNameController.text.trim(),
//       mobile: _mobileController.text.trim(),
//       email: _emailController.text.trim(),
//       nativePlace: _nativePlaceController.text.trim(),
//       aadharNumber: _aadharNumberController.text.trim(),
//       address: _addressController.text.trim(),
//       countryCode: _countryCodeController.text.trim(),
//       mobileCode: '91',
//       password: _passwordController.text.trim(),
//     );

//     try {
//       final authProvider = Provider.of<AuthProvider>(context, listen: false);
//       final success = await authProvider.register(request, _role);

//       if (!mounted) return;
//       setState(() => _isLoading = false);

//       if (success) {
//         Messenger.alertSuccess('Registration successful');
//         Navigator.pop(context);
//       } else {
//         Messenger.alertError('Registration failed. Please try again.');
//       }
//     } catch (e) {
//       if (!mounted) return;
//       setState(() => _isLoading = false);
//       Messenger.alertError('Server error. Please try again later.');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: AppColors.bluePrimaryDual,
//         iconTheme: const IconThemeData(color: Colors.white),
//         title: const Text(
//           'Create Account',
//           style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
//         ),
//         centerTitle: true,
//         bottom: TabBar(
//           controller: _tabController,
//           indicatorColor: Colors.white,
//           labelColor: Colors.white,
//           unselectedLabelColor: Colors.white70,
//           indicatorWeight: 3,
//           tabs: const [
//             Tab(text: 'USER'),
//             Tab(text: 'ADMIN'),
//           ],
//         ),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               "Let's get you started",
//               style: Theme.of(context).textTheme.titleMedium!.copyWith(
//                 fontWeight: FontWeight.w600,
//                 color: AppColors.bluePrimaryDual,
//               ),
//             ),
//             const SizedBox(height: 20),
//             _buildFormCard(),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildFormCard() {
//     return Container(
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           colors: [Colors.white, Colors.blue.shade50],
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//         ),
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black12.withOpacity(0.08),
//             blurRadius: 12,
//             offset: const Offset(0, 6),
//           ),
//         ],
//       ),
//       padding: const EdgeInsets.all(20),
//       child: Form(
//         key: _formKey,
//         child: Column(
//           children: [
//             MyTextFormFieldBox(
//               controller: _nameController,
//               labelText: 'Full Name',
//               validator: InputValidator.validateName,
//             ),
//             const SizedBox(height: 14),
//             MyTextFormFieldBox(
//               controller: _fatherNameController,
//               labelText: 'Father Name',
//               validator: InputValidator.validateFatherName,
//             ),
//             const SizedBox(height: 14),

//             // Mobile + OTP Button
//             Stack(
//               alignment: Alignment.centerRight,
//               children: [
//                 MyTextFormFieldBox(
//                   controller: _mobileController,
//                   labelText: 'Mobile Number',
//                   keyboardType: TextInputType.phone,
//                   validator: InputValidator.validateMobile,
//                   enable: !_isOtpVerified,
//                   suffixIcon: const SizedBox(width: 100),
//                 ),
//                 Positioned(
//                   right: 8,
//                   child: AnimatedSwitcher(
//                     duration: const Duration(milliseconds: 300),
//                     transitionBuilder: (child, anim) =>
//                         ScaleTransition(scale: anim, child: child),
//                     child: _isOtpVerified
//                         ? const Icon(
//                             Icons.check_circle,
//                             color: Colors.green,
//                             size: 26,
//                             key: ValueKey('verified'),
//                           )
//                         : _isOtpSending
//                         ? const SizedBox(
//                             key: ValueKey('loading'),
//                             height: 20,
//                             width: 20,
//                             child: CircularProgressIndicator(
//                               strokeWidth: 2,
//                               valueColor: AlwaysStoppedAnimation(Colors.blue),
//                             ),
//                           )
//                         : TextButton(
//                             key: const ValueKey('verify'),
//                             onPressed: _isOtpSent ? null : _sendOtpLocally,
//                             style: TextButton.styleFrom(
//                               padding: const EdgeInsets.symmetric(
//                                 horizontal: 10,
//                               ),
//                               minimumSize: const Size(60, 36),
//                               tapTargetSize: MaterialTapTargetSize.shrinkWrap,
//                             ),
//                             child: Text(
//                               _isOtpSent ? 'Sent' : 'Verify',
//                               style: TextStyle(
//                                 color: _isOtpSent
//                                     ? Colors.green
//                                     : AppColors.bluePrimaryDual,
//                                 fontWeight: FontWeight.w600,
//                                 fontSize: 13,
//                               ),
//                             ),
//                           ),
//                   ),
//                 ),
//               ],
//             ),

//             const SizedBox(height: 14),
//             MyTextFormFieldBox(
//               controller: _emailController,
//               labelText: 'Email Address',
//               keyboardType: TextInputType.emailAddress,
//               validator: InputValidator.validateEmail,
//             ),
//             const SizedBox(height: 14),
//             MyTextFormFieldBox(
//               controller: _nativePlaceController,
//               labelText: 'Native Place',
//               validator: InputValidator.validateNativePlace,
//             ),
//             const SizedBox(height: 14),
//             MyTextFormFieldBox(
//               controller: _aadharNumberController,
//               labelText: 'Aadhar Number',
//               keyboardType: TextInputType.number,
//               validator: InputValidator.validateAadhar,
//             ),
//             const SizedBox(height: 14),
//             MyTextFormFieldBox(
//               controller: _addressController,
//               labelText: 'Address',
//               validator: InputValidator.validateAddress,
//             ),
//             const SizedBox(height: 14),
//             MyTextFormFieldBox(
//               controller: _passwordController,
//               labelText: 'Password',
//               obscureText: _obscurePassword,
//               validator: InputValidator.validatePassword,
//               suffixIcon: IconButton(
//                 icon: Icon(
//                   _obscurePassword ? Icons.visibility_off : Icons.visibility,
//                   color: Colors.grey.shade600,
//                 ),
//                 onPressed: () =>
//                     setState(() => _obscurePassword = !_obscurePassword),
//               ),
//             ),
//             const SizedBox(height: 14),
//             MyTextFormFieldBox(
//               controller: _confirmPasswordController,
//               obscureText: _obscureConfirmPassword,
//               labelText: 'Confirm Password',
//               validator: (value) {
//                 if (value == null || value.isEmpty) {
//                   return 'Please confirm your password';
//                 } else if (value != _passwordController.text) {
//                   return 'Passwords do not match';
//                 }
//                 return null;
//               },
//               suffixIcon: IconButton(
//                 icon: Icon(
//                   _obscureConfirmPassword
//                       ? Icons.visibility_off
//                       : Icons.visibility,
//                   color: Colors.grey.shade600,
//                 ),
//                 onPressed: () => setState(
//                   () => _obscureConfirmPassword = !_obscureConfirmPassword,
//                 ),
//               ),
//             ),
//             const SizedBox(height: 26),

//             // Register Button
//             AnimatedContainer(
//               duration: const Duration(milliseconds: 300),
//               width: double.infinity,
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: [
//                     AppColors.bluePrimaryDual,
//                     AppColors.bluePrimaryDual.withOpacity(0.8),
//                   ],
//                   begin: Alignment.centerLeft,
//                   end: Alignment.centerRight,
//                 ),
//                 borderRadius: BorderRadius.circular(14),
//               ),
//               child: ElevatedButton(
//                 onPressed: _isLoading ? null : _register,
//                 style: ElevatedButton.styleFrom(
//                   elevation: 0,
//                   backgroundColor: Colors.transparent,
//                   shadowColor: Colors.transparent,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(14),
//                   ),
//                   padding: const EdgeInsets.symmetric(vertical: 16),
//                 ),
//                 child: _isLoading
//                     ? const SizedBox(
//                         height: 20,
//                         width: 20,
//                         child: CircularProgressIndicator(
//                           color: Colors.white,
//                           strokeWidth: 2,
//                         ),
//                       )
//                     : const Text(
//                         'Register Now',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 17,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sportspark/screens/login/model/register_request.dart';
import 'package:sportspark/screens/login/provider/auth_provider.dart';
import 'package:sportspark/utils/const/const.dart';
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

  // Form Controllers
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
    _tabController.addListener(_handleTabChange);
  }

  void _handleTabChange() {
    if (_tabController.indexIsChanging) return;
    setState(() {
      _role = _tabController.index == 0 ? 'user' : 'admin';
      _resetForm();
    });
  }

  void _resetForm() {
    _nameController.clear();
    _fatherNameController.clear();
    _mobileController.clear();
    _emailController.clear();
    _nativePlaceController.clear();
    _aadharNumberController.clear();
    _addressController.clear();
    _passwordController.clear();
    _confirmPasswordController.clear();
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

  // Register API Call
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
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final success = await authProvider.register(request, _role);

      if (!mounted) return;
      setState(() => _isLoading = false);

      if (success) {
        Messenger.alertSuccess('Registration successful');
        Navigator.pop(context);
      } 
    } catch (e) {
      if (!mounted) return;
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
              "Let's get you started",
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.bluePrimaryDual,
              ),
            ),
            const SizedBox(height: 20),
            _buildFormCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildFormCard() {
    return Container(
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
              validator: InputValidator.validateFatherName,
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
              validator: InputValidator.validateNativePlace,
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
              validator: InputValidator.validateAddress,
            ),
            const SizedBox(height: 14),
            MyTextFormFieldBox(
              controller: _passwordController,
              labelText: 'Password',
              obscureText: _obscurePassword,
              validator: InputValidator.validatePassword,
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: () =>
                    setState(() => _obscurePassword = !_obscurePassword),
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
                ),
                onPressed: () => setState(() =>
                    _obscureConfirmPassword = !_obscureConfirmPassword),
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
    );
  }
}
