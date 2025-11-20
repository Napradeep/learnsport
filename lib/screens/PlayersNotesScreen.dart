import 'package:flutter/material.dart';
import 'package:sportspark/screens/payment_deatils.dart';
import 'package:sportspark/utils/const/const.dart';
import 'package:sportspark/utils/router/router.dart';
import 'package:sportspark/utils/widget/custom_button.dart';
import 'package:sportspark/utils/widget/custom_text_field.dart';

class PlayersNotesScreen extends StatefulWidget {
  final String sportsId;
  final String turfName;
  final DateTime selectedDate;
  final List<String> selectedSlots;
  final String fullName;
  final String fatherName;
  final String mobileNumber;
  final String email;
  final String address;
  final String slotAmount;
  final String slotType;
  final String? typeMonth;
  final int? typeYear;

  const PlayersNotesScreen({
    super.key,
    required this.sportsId,
    required this.turfName,
    required this.selectedDate,
    required this.selectedSlots,
    required this.fullName,
    required this.fatherName,
    required this.mobileNumber,
    required this.email,
    required this.address,
    required this.slotAmount,
    required this.slotType,
    this.typeMonth,
    this.typeYear,
  });

  @override
  State<PlayersNotesScreen> createState() => _PlayersNotesScreenState();
}

class _PlayersNotesScreenState extends State<PlayersNotesScreen> {
  final TextEditingController _playerCount = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    print(widget.sportsId);
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: AppColors.bluePrimaryDual,
        elevation: 0,
        title: const Text("Players & Notes"),
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              MyTextFormFieldBox(
                controller: _playerCount,
                labelText: 'No. of Players',
                hinttext: 'Enter number of players',
                icon: const Icon(Icons.group),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Player count is required";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 14),
              MyTextFormFieldBox(
                controller: _noteController,
                labelText: 'Write Your Notes (Optional)',
                hinttext: 'Describe your Notes',
                maxLines: 5,
                icon: const Icon(
                  Icons.message,
                  color: AppColors.iconLightColor,
                ),
              ),
              const Spacer(),
              CustomButton(
                text: 'Next',
                color: Colors.white,
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    print(widget.slotType);
                    print(widget.typeMonth);
                    print(widget.typeYear);
                    MyRouter.push(
                      screen: PaymentDeatils(
                        turfName: widget.turfName,
                        selectedDate: widget.selectedDate,
                        selectedSlots: widget.selectedSlots,
                        fullName: widget.fullName,
                        fatherName: widget.fatherName,
                        mobileNumber: widget.mobileNumber,
                        email: widget.email,
                        address: widget.address,
                        slotAmount: widget.slotAmount,
                        playersCount: _playerCount.text.trim(),
                        notes: _noteController.text.trim(),
                        sportsId: widget.sportsId,
                        slotType: widget.slotType,
                        typeMonth: widget.typeMonth,
                        typeYear: widget.typeYear,
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
