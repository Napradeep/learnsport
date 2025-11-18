// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:provider/provider.dart';
// import 'package:sportspark/screens/login/view/login_screen.dart';
// import 'package:sportspark/screens/payment_deatils.dart';
// import 'package:sportspark/utils/const/const.dart';
// import 'package:sportspark/utils/router/router.dart';
// import 'package:sportspark/utils/shared/shared_pref.dart';
// import 'package:sportspark/utils/validator/validator.dart';
// import 'package:sportspark/utils/widget/custom_button.dart';
// import 'package:sportspark/utils/widget/custom_text_field.dart';
// import 'package:sportspark/screens/admin/profile_service/profile_provider.dart';
// import 'package:sportspark/utils/snackbar/snackbar.dart';

// class PaymentScreen extends StatefulWidget {
//   final String userSlectedgame;
//   final DateTime selectedDate;
//   final String timeSlot;
//   final List<String> selectedSlots;

//   const PaymentScreen({
//     super.key,
//     required this.userSlectedgame,
//     required this.selectedDate,
//     required this.timeSlot,
//     required this.selectedSlots,
//   });

//   @override
//   State<PaymentScreen> createState() => _PaymentScreenState();
// }

// class _PaymentScreenState extends State<PaymentScreen> {
//   final _formKey = GlobalKey<FormState>();

//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _fatherNameController = TextEditingController();
//   final TextEditingController _mobileController = TextEditingController();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _aadharNumberController = TextEditingController();
//   final TextEditingController _addressController = TextEditingController();
//   final TextEditingController _nativePlaceController = TextEditingController();
//   final TextEditingController _notesController = TextEditingController();

//   bool _profilePrefilled = false;

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _fetchAndPrefillProfile();
//     });
//   }

//   Future<void> _fetchAndPrefillProfile() async {
//     if (!mounted) return;

//     final provider = Provider.of<ProfileProvider>(context, listen: false);

//     try {
//       await provider.fetchProfile();

//       if (!mounted) return;

//       if (provider.user.isNotEmpty) {
//         final user = provider.user;
//         _nameController.text = user['name'] ?? '';
//         _fatherNameController.text = user['father_name'] ?? '';
//         _mobileController.text = user['mobile'] ?? '';
//         _emailController.text = user['email'] ?? '';
//         _aadharNumberController.text = user['aadhar_number'] ?? '';
//         _addressController.text = user['address'] ?? '';
//         _notesController.text = user['notes'] ?? '';
//         _nativePlaceController.text = user['native_place'] ?? '';
//         _profilePrefilled = true;
//       } else {
//         Messenger.alertError("Please fill in your details to continue");
//       }
//     } catch (e) {
//       if (mounted) {
//         Messenger.alertError("Failed to load profile. Please try again.");
//       }
//     } finally {
//       if (mounted) {
//         setState(() {
//           _profilePrefilled = true;
//         });
//       }
//     }
//   }

//   @override
//   void dispose() {
//     _nameController.dispose();
//     _fatherNameController.dispose();
//     _mobileController.dispose();
//     _emailController.dispose();
//     _aadharNumberController.dispose();
//     _addressController.dispose();
//     _nativePlaceController.dispose();
//     _notesController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final provider = Provider.of<ProfileProvider>(context);

//     return Theme(
//       data: theme.copyWith(
//         colorScheme: ColorScheme.fromSeed(
//           seedColor: AppColors.bluePrimaryDual,
//           primary: AppColors.bluePrimaryDual,
//           secondary: AppColors.iconLightColor,
//         ),
//         appBarTheme: const AppBarTheme(
//           backgroundColor: AppColors.bluePrimaryDual,
//           foregroundColor: Colors.white,
//           elevation: 0,
//           centerTitle: true,
//         ),
//       ),
//       child: Scaffold(
//         backgroundColor: const Color(0xFFF7F8FA),
//         appBar: AppBar(
//           centerTitle: false,
//           title: const Text(
//             'Payment Details',
//             style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
//           ),
//         ),
//         body: provider.isLoading || !_profilePrefilled
//             ? const Center(child: CircularProgressIndicator())
//             : SafeArea(
//                 child: SingleChildScrollView(
//                   padding: const EdgeInsets.all(20),
//                   child: Form(
//                     key: _formKey,
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         // Header Card
//                         Container(
//                           padding: const EdgeInsets.all(16),
//                           decoration: BoxDecoration(
//                             color: Colors.white,
//                             borderRadius: BorderRadius.circular(16),
//                             boxShadow: [
//                               BoxShadow(
//                                 color: Colors.black.withOpacity(0.05),
//                                 blurRadius: 10,
//                                 offset: const Offset(0, 4),
//                               ),
//                             ],
//                           ),
//                           child: Row(
//                             children: [
//                               CircleAvatar(
//                                 radius: 26,
//                                 backgroundColor: AppColors.bluePrimaryDual
//                                     .withOpacity(0.15),
//                                 child: const Icon(
//                                   Icons.payment,
//                                   color: AppColors.bluePrimaryDual,
//                                   size: 28,
//                                 ),
//                               ),
//                               const SizedBox(width: 16),
//                               Expanded(
//                                 child: Text(
//                                   'Complete your payment securely',
//                                   style: theme.textTheme.titleMedium?.copyWith(
//                                     fontWeight: FontWeight.w600,
//                                     color: AppColors.iconColor,
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         const SizedBox(height: 24),

//                         // Form Fields
//                         Container(
//                           padding: const EdgeInsets.symmetric(
//                             horizontal: 18,
//                             vertical: 20,
//                           ),
//                           decoration: BoxDecoration(
//                             color: Colors.white,
//                             borderRadius: BorderRadius.circular(16),
//                             boxShadow: [
//                               BoxShadow(
//                                 color: Colors.black.withOpacity(0.05),
//                                 blurRadius: 10,
//                                 offset: const Offset(0, 4),
//                               ),
//                             ],
//                           ),
//                           child: Column(
//                             children: [
//                               MyTextFormFieldBox(
//                                 controller: _nameController,
//                                 labelText: 'Full Name',
//                                 hinttext: 'Enter your name',
//                                 icon: const Icon(
//                                   Icons.person,
//                                   color: AppColors.iconLightColor,
//                                 ),
//                                 validator: (v) => (v == null || v.isEmpty)
//                                     ? 'Name is required'
//                                     : null,
//                               ),
//                               const SizedBox(height: 16),
//                               MyTextFormFieldBox(
//                                 controller: _fatherNameController,
//                                 labelText: 'Father’s Name',
//                                 hinttext: 'Enter father’s name',
//                                 icon: const Icon(
//                                   Icons.person_outline,
//                                   color: AppColors.iconLightColor,
//                                 ),
//                                 validator: (v) => (v == null || v.isEmpty)
//                                     ? 'Father’s name is required'
//                                     : null,
//                               ),
//                               const SizedBox(height: 16),
//                               MyTextFormFieldBox(
//                                 controller: _mobileController,
//                                 labelText: 'Mobile Number',
//                                 hinttext: '10-digit mobile number',
//                                 keyboardType: TextInputType.phone,
//                                 inputFormatters: [
//                                   FilteringTextInputFormatter.digitsOnly,
//                                 ],
//                                 icon: const Icon(
//                                   Icons.phone,
//                                   color: AppColors.iconLightColor,
//                                 ),
//                                 validator: (v) {
//                                   if (v == null || v.isEmpty) {
//                                     return 'Mobile number is required';
//                                   }
//                                   if (v.length != 10) {
//                                     return 'Enter a valid 10-digit number';
//                                   }
//                                   return null;
//                                 },
//                               ),
//                               const SizedBox(height: 16),
//                               MyTextFormFieldBox(
//                                 controller: _emailController,
//                                 labelText: 'Email (Optional)',
//                                 hinttext: 'Enter your email address',
//                                 keyboardType: TextInputType.emailAddress,
//                                 icon: const Icon(
//                                   Icons.email,
//                                   color: AppColors.iconLightColor,
//                                 ),
//                               ),
//                               const SizedBox(height: 16),
//                               MyTextFormFieldBox(
//                                 controller: _aadharNumberController,
//                                 labelText: 'Aadhar Number',
//                                 keyboardType: TextInputType.number,
//                                 icon: const Icon(
//                                   Icons.credit_card,
//                                   color: AppColors.iconLightColor,
//                                 ),
//                                 validator: InputValidator.validateAadhar,
//                               ),
//                               const SizedBox(height: 16),
//                               MyTextFormFieldBox(
//                                 controller: _addressController,
//                                 labelText: 'Address',
//                                 hinttext: 'Enter your address',
//                                 icon: const Icon(
//                                   Icons.location_on,
//                                   color: AppColors.iconLightColor,
//                                 ),
//                                 validator: (v) => (v == null || v.isEmpty)
//                                     ? 'Address is required'
//                                     : null,
//                               ),
//                               const SizedBox(height: 16),
//                               MyTextFormFieldBox(
//                                 controller: _notesController,
//                                 labelText: 'Notes',
//                                 hinttext: 'Add payment notes',
//                                 maxLines: 3,
//                                 icon: const Icon(
//                                   Icons.description,
//                                   color: AppColors.iconLightColor,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),

//                         const SizedBox(height: 32),

//                         // Next Button
//                         Center(
//                           child: CustomButton(
//                             text: 'Next',
//                             color: AppColors.background,
//                             onPressed: () async {
//                               if (_formKey.currentState!.validate()) {
//                                 // 🧩 Check login status
//                                 final isLoggedIn =
//                                     await UserPreferences.isLoggedIn();

//                                 if (isLoggedIn) {
//                                   MyRouter.push(
//                                     screen: PaymentDeatils(
//                                       turfName: widget.userSlectedgame,
//                                       selectedDate: widget.selectedDate,
//                                       fullName: _nameController.text.trim(),
//                                       fatherName: _fatherNameController.text
//                                           .trim(),
//                                       mobileNumber: _mobileController.text
//                                           .trim(),
//                                       email: _emailController.text.trim(),
//                                       address: _addressController.text.trim(),
//                                       notes: _notesController.text.trim(),
//                                       selectedSlots: widget.selectedSlots,
//                                     ),
//                                   );
//                                 } else {
//                                   MyRouter.pushRemoveUntil(
//                                     screen: LoginScreen(),
//                                   );
//                                 }
//                               }
//                             },
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//       ),
//     );
//   }
// }
