import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sportspark/screens/home_screen.dart';
import 'package:sportspark/screens/sportslist/sports_provider.dart';
import 'package:sportspark/utils/const/const.dart';
import 'package:sportspark/utils/router/router.dart';
import 'package:sportspark/utils/validator/validator.dart';
import 'package:sportspark/utils/widget/common_dropdown.dart';
import 'package:sportspark/utils/widget/custom_text_field.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _fatherNameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _enquiryController = TextEditingController();
  final TextEditingController _nativeController = TextEditingController();

  String? _selectedContactType = 'General';

  @override
  void initState() {
    super.initState();
    // Load sports on first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<SportsProvider>(context, listen: false).loadSports();
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _fatherNameController.dispose();
    _mobileController.dispose();
    _emailController.dispose();
    _enquiryController.dispose();
    _nativeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        backgroundColor: AppColors.bluePrimaryDual,
        title: const Text(
          'Contact & Enquiry',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Colors.white,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Card(
                elevation: 4,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 25,
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Your Details',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 22),

                        // ── Text Fields (unchanged) ─────────────────────
                        MyTextFormFieldBox(
                          controller: _nameController,
                          labelText: 'Name',
                          hinttext: 'Enter your full name',
                          icon: const Icon(
                            Icons.person,
                            color: AppColors.iconLightColor,
                          ),
                          validator: (v) =>
                              InputValidator.validateName(v ?? ''),
                        ),
                        const SizedBox(height: 16),
                        MyTextFormFieldBox(
                          controller: _fatherNameController,
                          labelText: 'Father Name',
                          hinttext: "Enter father's name",
                          icon: const Icon(
                            Icons.person_outline,
                            color: AppColors.iconLightColor,
                          ),
                          validator: (v) =>
                              InputValidator.validateName(v ?? ''),
                        ),
                        const SizedBox(height: 16),
                        MyTextFormFieldBox(
                          controller: _mobileController,
                          labelText: 'Mobile Number',
                          hinttext: 'Enter mobile number',
                          keyboardType: TextInputType.phone,
                          icon: const Icon(
                            Icons.phone,
                            color: AppColors.iconLightColor,
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          validator: (v) =>
                              InputValidator.validateMobile(v ?? ''),
                        ),
                        const SizedBox(height: 16),
                        MyTextFormFieldBox(
                          controller: _emailController,
                          labelText: 'Email (Optional)',
                          hinttext: 'Enter email address',
                          keyboardType: TextInputType.emailAddress,
                          icon: const Icon(
                            Icons.email,
                            color: AppColors.iconLightColor,
                          ),
                          validator: (v) {
                            if (v != null && v.isNotEmpty) {
                              return InputValidator.validateEmail(v);
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        MyTextFormFieldBox(
                          controller: _nativeController,
                          labelText: 'Native',
                          hinttext: 'Enter your native',
                          icon: const Icon(
                            Icons.location_history,
                            color: AppColors.iconLightColor,
                          ),
                          validator: (v) =>
                              InputValidator.validateAddress(v ?? ''),
                        ),
                        const SizedBox(height: 16),

                        Consumer<SportsProvider>(
                          builder: (context, provider, _) {
                            return CommonDropdown(
                              items: provider.sports,
                              selectedValue: _selectedContactType,
                              onChanged: (v) =>
                                  setState(() => _selectedContactType = v),
                              isLoading: provider.isLoading,
                              error: provider.error,
                            );
                          },
                        ),

                        const SizedBox(height: 16),

                        MyTextFormFieldBox(
                          controller: _enquiryController,
                          labelText: 'Write Your Notes',
                          hinttext: 'Describe your Notes',
                          maxLines: 5,
                          icon: const Icon(
                            Icons.message,
                            color: AppColors.iconLightColor,
                          ),
                          validator: (v) =>
                              InputValidator.validateEnquiry(v ?? ''),
                        ),
                        const SizedBox(height: 30),

                        // ── Submit Button (unchanged) ───────────────────
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.send, color: Colors.white),
                            label: const Text(
                              "Submit Enquiry",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.bluePrimaryDual,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              elevation: 5,
                              shadowColor: AppColors.iconLightColor,
                            ),
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                FocusScope.of(context).unfocus();

                                showGeneralDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  transitionDuration: const Duration(
                                    milliseconds: 400,
                                  ),
                                  pageBuilder: (_, __, ___) =>
                                      const SizedBox.shrink(),
                                  transitionBuilder: (ctx, anim, _, __) {
                                    final curved =
                                        Curves.easeInOutBack.transform(
                                          anim.value,
                                        ) -
                                        1.0;
                                    return Transform(
                                      transform: Matrix4.translationValues(
                                        0,
                                        curved * -200,
                                        0,
                                      ),
                                      child: Opacity(
                                        opacity: anim.value,
                                        child: AlertDialog(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              20,
                                            ),
                                          ),
                                          title: const Column(
                                            children: [
                                              Icon(
                                                Icons.check_circle_rounded,
                                                color: Colors.green,
                                                size: 70,
                                              ),
                                              SizedBox(height: 12),
                                              Text(
                                                "Success!",
                                                style: TextStyle(
                                                  fontSize: 22,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.green,
                                                ),
                                              ),
                                            ],
                                          ),
                                          content: const Text(
                                            "Your enquiry has been submitted successfully.\nOur team will reach out to you soon.",
                                            textAlign: TextAlign.center,
                                          ),
                                          actionsAlignment:
                                              MainAxisAlignment.center,
                                          actions: [
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    AppColors.bluePrimaryDual,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                              ),
                                              onPressed: () =>
                                                  MyRouter.pushRemoveUntil(
                                                    screen: const HomeScreen(),
                                                  ),
                                              child: const Padding(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 20,
                                                  vertical: 10,
                                                ),
                                                child: Text(
                                                  "OK",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
