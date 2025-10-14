import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sportspark/screens/home_screen.dart';
import 'package:sportspark/utils/const/const.dart';
import 'package:sportspark/utils/router/router.dart';
import 'package:sportspark/utils/snackbar/snackbar.dart';
import 'package:sportspark/utils/widget/custom_button.dart';
import 'package:sportspark/utils/widget/custom_text_field.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _fatherNameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _fatherNameController.dispose();
    _mobileController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Theme(
      data: Theme.of(context).copyWith(
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.bluePrimaryDual,
          primary: AppColors.bluePrimaryDual,
          secondary: AppColors.iconLightColor,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.bluePrimaryDual,
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
        ),
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFFF7F8FA),
        appBar: AppBar(
          automaticallyImplyLeading: true,
          leadingWidth: 50,
          titleSpacing: 0,
          title: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Payment Details',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),

        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 26,
                          backgroundColor: AppColors.bluePrimaryDual
                              .withOpacity(0.15),
                          child: const Icon(
                            Icons.payment,
                            color: AppColors.bluePrimaryDual,
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            'Complete your payment securely',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppColors.iconColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Form Card
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 20,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        MyTextFormFieldBox(
                          controller: _nameController,
                          labelText: 'Full Name',
                          hinttext: 'Enter your name',
                          icon: const Icon(
                            Icons.person,
                            color: AppColors.iconLightColor,
                          ),
                          validator: (value) => (value == null || value.isEmpty)
                              ? 'Name is required'
                              : null,
                        ),
                        const SizedBox(height: 16),
                        MyTextFormFieldBox(
                          controller: _fatherNameController,
                          labelText: 'Father’s Name',
                          hinttext: 'Enter father’s name',
                          icon: const Icon(
                            Icons.person_outline,
                            color: AppColors.iconLightColor,
                          ),
                          validator: (value) => (value == null || value.isEmpty)
                              ? 'Father’s name is required'
                              : null,
                        ),
                        const SizedBox(height: 16),
                        MyTextFormFieldBox(
                          controller: _mobileController,
                          labelText: 'Mobile Number',
                          hinttext: '10-digit mobile number',
                          keyboardType: TextInputType.phone,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          icon: const Icon(
                            Icons.phone,
                            color: AppColors.iconLightColor,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Mobile number is required';
                            }
                            if (value.length != 10) {
                              return 'Enter a valid 10-digit number';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        MyTextFormFieldBox(
                          controller: _emailController,
                          labelText: 'Email (Optional)',
                          hinttext: 'Enter your email address',
                          keyboardType: TextInputType.emailAddress,
                          icon: const Icon(
                            Icons.email,
                            color: AppColors.iconLightColor,
                          ),
                        ),
                        const SizedBox(height: 16),
                        MyTextFormFieldBox(
                          controller: _addressController,
                          labelText: 'Address',
                          hinttext: 'Enter your address',
                          icon: const Icon(
                            Icons.location_on,
                            color: AppColors.iconLightColor,
                          ),
                          validator: (value) => (value == null || value.isEmpty)
                              ? 'Address is required'
                              : null,
                        ),
                        const SizedBox(height: 16),
                        MyTextFormFieldBox(
                          controller: _descriptionController,
                          labelText: 'Description',
                          hinttext: 'Add payment description (optional)',
                          maxLines: 3,
                          icon: const Icon(
                            Icons.description,
                            color: AppColors.iconLightColor,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Payment Button Section
                  Center(
                    child: CustomButton(
                      text: 'Proceed to Pay ₹500',
                      color: AppColors.background,
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          Messenger.alertSuccess('Payment paid');
                          MyRouter.pushRemoveUntil(screen: HomeScreen());
                        }
                      },
                    ),
                  ),

                  const SizedBox(height: 20),

                  Center(
                    child: Text(
                      'Payments are secured with Razorpay',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                        fontStyle: FontStyle.italic,
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
