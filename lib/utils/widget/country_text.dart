import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:sportspark/utils/const/const.dart';

class PhoneNumberField extends StatefulWidget {
  final TextEditingController countryCodeController;
  final TextEditingController mobileController;

  const PhoneNumberField({
    super.key,
    required this.countryCodeController,
    required this.mobileController,
  });

  @override
  State<PhoneNumberField> createState() => _PhoneNumberFieldState();
}

class _PhoneNumberFieldState extends State<PhoneNumberField> {
  Color _borderColor = Colors.grey.shade300;
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    return FocusScope(
      onFocusChange: (focus) {
        setState(() {
          _isFocused = focus;
          _borderColor = focus
              ? AppColors.bluePrimaryDual
              : Colors.grey.shade300;
        });
      },
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  width: _isFocused ? 2 : 1.5,
                  color: _borderColor,
                ),
                color: Colors.white,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                child: IntlPhoneField(
                  decoration: const InputDecoration(
                    labelText: 'Mobile Number',
                    hintText: 'Enter mobile number',
                    border: InputBorder.none,
                    counterText: '',
                  ),
                  initialCountryCode: 'IN',
                  showDropdownIcon: true,
                  disableLengthCheck: false,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  onChanged: (phone) {
                    // Store data in your controllers
                    widget.countryCodeController.text = phone.countryCode;
                    widget.mobileController.text = phone.number;

                    print('Full: ${phone.completeNumber}');
                  },
                  validator: (value) {
                    if (value == null || value.number.isEmpty) {
                      return 'Enter a valid phone number';
                    }
                    return null;
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
