import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sportspark/screens/common_provider/contact_provider.dart';
import 'package:sportspark/screens/home_screen.dart';
import 'package:sportspark/screens/sportslist/sports_provider.dart';
import 'package:sportspark/screens/admin/profile_service/profile_provider.dart';
import 'package:sportspark/utils/const/const.dart';
import 'package:sportspark/utils/router/router.dart';
import 'package:sportspark/utils/validator/validator.dart';
import 'package:sportspark/utils/widget/common_dropdown.dart';
import 'package:sportspark/utils/widget/custom_text_field.dart';
import 'package:sportspark/utils/shared/shared_pref.dart';

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
  bool _isPrefilling = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // Load dropdown data (sports)
      Provider.of<SportsProvider>(context, listen: false).loadSports();

      // Check if user is logged in
      final token = await UserPreferences.getToken();
      if (token != null && token.isNotEmpty) {
        _prefillUserData(context);
      }
    });
  }

  Future<void> _prefillUserData(BuildContext context) async {
    setState(() => _isPrefilling = true);
    final profileProvider = Provider.of<ProfileProvider>(
      context,
      listen: false,
    );

    try {
      await profileProvider.fetchProfile();

      final user = profileProvider.user;
      if (user.isNotEmpty) {
        _nameController.text = user['name'] ?? '';
        _fatherNameController.text = user['father_name'] ?? '';
        _mobileController.text = user['mobile'] ?? '';
        _emailController.text = user['email'] ?? '';
        _nativeController.text = user['native_place'] ?? '';
      }
    } catch (e) {
      debugPrint("⚠️ Error pre-filling user data: $e");
    } finally {
      setState(() => _isPrefilling = false);
    }
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
        centerTitle: false,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        backgroundColor: AppColors.bluePrimaryDual,
        title: const Text(
          'Contact Us',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Colors.white,
          ),
        ),
      ),
      body: _isPrefilling
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 20,
                    ),
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

                              // Name
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

                              // Father Name
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

                              // Mobile
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

                              // Email
                              MyTextFormFieldBox(
                                controller: _emailController,
                                labelText: 'Email',
                                hinttext: 'Enter email address',
                                keyboardType: TextInputType.emailAddress,

                                icon: const Icon(
                                  Icons.email,
                                  color: AppColors.iconLightColor,
                                ),
                                validator: (v) =>
                                    InputValidator.validateEmail(v ?? ''),
                                // validator: (v) {
                                //   if (v != null && v.isNotEmpty) {
                                //     return InputValidator.validateEmail(v);
                                //   }
                                //   return null;
                                // },
                              ),
                              const SizedBox(height: 16),

                              // Native
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

                              // Dropdown
                              Consumer<SportsProvider>(
                                builder: (context, provider, _) {
                                  return LayoutBuilder(
                                    builder: (context, constraints) {
                                      return ConstrainedBox(
                                        constraints: BoxConstraints(
                                          minWidth: constraints.maxWidth,
                                          maxWidth: constraints.maxWidth,
                                        ),
                                        child: CommonDropdown(
                                          items: provider.sports,
                                          selectedValue: _selectedContactType,
                                          onChanged: (v) => setState(
                                            () => _selectedContactType = v,
                                          ),
                                          isLoading: provider.isLoading,
                                          error: provider.error,
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),

                              const SizedBox(height: 16),

                              // Notes / Enquiry
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

                              SizedBox(
                                width: double.infinity,
                                height: 50,
                                child: Consumer<ContactProvider>(
                                  builder: (context, contactProvider, _) {
                                    final isSubmitting =
                                        contactProvider.isSubmitting;

                                    return ElevatedButton.icon(
                                      icon: isSubmitting
                                          ? const SizedBox(
                                              width: 20,
                                              height: 20,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                                color: Colors.white,
                                              ),
                                            )
                                          : const Icon(
                                              Icons.send,
                                              color: Colors.white,
                                            ),
                                      label: Text(
                                        isSubmitting
                                            ? "Submitting..."
                                            : "Submit Enquiry",
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            AppColors.bluePrimaryDual,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            14,
                                          ),
                                        ),
                                        elevation: 5,
                                        shadowColor: AppColors.iconLightColor,
                                      ),
                                      onPressed: isSubmitting
                                          ? null // disable button while submitting
                                          : () async {
                                              if (_formKey.currentState!
                                                  .validate()) {
                                                FocusScope.of(
                                                  context,
                                                ).unfocus();

                                                final success = await contactProvider
                                                    .submitEnquiry({
                                                      'name': _nameController
                                                          .text
                                                          .trim(),
                                                      'father_name':
                                                          _fatherNameController
                                                              .text
                                                              .trim(),
                                                      'email':
                                                          _emailController.text
                                                              .trim()
                                                              .isEmpty
                                                          ? null
                                                          : _emailController
                                                                .text
                                                                .trim(),
                                                      'mobile':
                                                          _mobileController.text
                                                              .trim(),
                                                      'native_place':
                                                          _nativeController.text
                                                              .trim(),
                                                      'country_code': '+91',
                                                      'message':
                                                          _enquiryController
                                                              .text
                                                              .trim(),
                                                      'contact_type':
                                                          _selectedContactType ??
                                                          'General',
                                                    });

                                                if (context.mounted &&
                                                    success) {
                                                  showGeneralDialog(
                                                    context: context,
                                                    barrierDismissible: false,
                                                    transitionDuration:
                                                        const Duration(
                                                          milliseconds: 400,
                                                        ),
                                                    pageBuilder: (_, __, ___) =>
                                                        const SizedBox.shrink(),
                                                    transitionBuilder: (ctx, anim, _, __) {
                                                      final curved =
                                                          Curves.easeInOutBack
                                                              .transform(
                                                                anim.value,
                                                              ) -
                                                          1.0;
                                                      return Transform(
                                                        transform:
                                                            Matrix4.translationValues(
                                                              0,
                                                              curved * -200,
                                                              0,
                                                            ),
                                                        child: Opacity(
                                                          opacity: anim.value,
                                                          child: AlertDialog(
                                                            shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius.circular(
                                                                    20,
                                                                  ),
                                                            ),
                                                            title: const Column(
                                                              children: [
                                                                Icon(
                                                                  Icons
                                                                      .check_circle_rounded,
                                                                  color: Colors
                                                                      .green,
                                                                  size: 70,
                                                                ),
                                                                SizedBox(
                                                                  height: 12,
                                                                ),
                                                                Text(
                                                                  "Success!",
                                                                  style: TextStyle(
                                                                    fontSize:
                                                                        22,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: Colors
                                                                        .green,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            content: const Text(
                                                              "Your enquiry has been submitted successfully!\nOur team will be reply to you as soon as posible.",
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                            ),
                                                            actionsAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            actions: [
                                                              ElevatedButton(
                                                                style: ElevatedButton.styleFrom(
                                                                  backgroundColor:
                                                                      Colors
                                                                          .blue,
                                                                  shape: RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                          12,
                                                                        ),
                                                                  ),
                                                                ),
                                                                onPressed: () =>
                                                                    MyRouter.pushRemoveUntil(
                                                                      screen:
                                                                          const HomeScreen(),
                                                                    ),
                                                                child: const Padding(
                                                                  padding:
                                                                      EdgeInsets.symmetric(
                                                                        horizontal:
                                                                            20,
                                                                        vertical:
                                                                            10,
                                                                      ),
                                                                  child: Text(
                                                                    "OK",
                                                                    style: TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                          16,
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
                                              }
                                            },
                                    );
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
