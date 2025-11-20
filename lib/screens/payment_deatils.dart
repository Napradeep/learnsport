import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sportspark/screens/admin/booking_service/booking_provider.dart';
import 'package:sportspark/screens/home_screen.dart';
import 'package:sportspark/utils/const/const.dart';
import 'package:sportspark/utils/router/router.dart';
import 'package:sportspark/utils/snackbar/snackbar.dart';
import 'package:sportspark/utils/widget/custom_button.dart';

class PaymentDeatils extends StatefulWidget {
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
  final String playersCount;
  final String notes;
  final String slotType;
  final String? typeMonth;
  final int? typeYear;

  const PaymentDeatils({
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
    required this.playersCount,
    required this.notes,
    required this.slotType,
    this.typeMonth,
    this.typeYear,
  });

  @override
  State<PaymentDeatils> createState() => _PaymentDeatilsState();
}

class _PaymentDeatilsState extends State<PaymentDeatils>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  double slotAmountValue = 0.0;

  @override
  void initState() {
    slotAmountValue = double.tryParse(widget.slotAmount) ?? 0.0;
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..forward();
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double get totalAmount => widget.selectedSlots.length * slotAmountValue;

  String cleanTime(String t) {
    t = t.replaceAll(" ", "").replaceAll("AM", "").replaceAll("PM", "").trim();
    if (!t.contains(":")) {
      t = "${t}:00";
    }
    return t;
  }

  Future<void> _bookSlot() async {
    List<Map<String, String>> times = widget.selectedSlots.map((slot) {
      final parts = slot.split("-");
      return {
        "start_time": cleanTime(parts[0]),
        "end_time": cleanTime(parts[1]),
      };
    }).toList();

    String bookingDate =
        "${widget.selectedDate.year}-${widget.selectedDate.month.toString().padLeft(2, '0')}-${widget.selectedDate.day.toString().padLeft(2, '0')}";

    bool result = await Provider.of<BookingProvider>(context, listen: false)
        .bookSlots(
          sportsId: widget.sportsId,
          slotType: widget.slotType,
          bookingDate: widget.slotType == "DAY" ? bookingDate : null,
          typeMonth: widget.slotType == "MONTH" ? widget.typeMonth : null,
          typeYear: widget.slotType == "MONTH" ? widget.typeYear : null,
          playersCount: widget.playersCount,
          times: times,
        );

    if (result) {
      Messenger.alertSuccess('Booking Successful');
      MyRouter.pushRemoveUntil(screen: const HomeScreen());
    } else {
      Messenger.alertError('Booking Failed, Try Again');
    }
  }

  void _showConfirmDialog() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 10),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blueAccent.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.payment,
                  color: Colors.blueAccent,
                  size: 42,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                "Payment Confirmation!",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              const Text(
                "Are you sure you want to complete the payment?",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Cancel"),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        Navigator.pop(context);
                        _bookSlot();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      child: const Text(
                        "Pay",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _sectionCard({required String title, required List<Widget> children}) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Container(
        margin: const EdgeInsets.only(bottom: 24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 12),
          ],
        ),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                gradient: LinearGradient(
                  colors: [AppColors.bluePrimaryDual, Color(0xFF00B8D4)],
                ),
              ),
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(children: children),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppColors.iconColor,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(fontSize: 15, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F9),
      appBar: AppBar(
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Booking Confirmation'),
        backgroundColor: AppColors.bluePrimaryDual,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _sectionCard(
                  title: '🏟️ Booking Details',
                  children: [
                    _buildDetailRow('Turf Name', widget.turfName),
                    _buildDetailRow(
                      'Date',
                      '${widget.selectedDate.day}/${widget.selectedDate.month}/${widget.selectedDate.year}',
                    ),
                    _buildDetailRow('Slots', widget.selectedSlots.join(", ")),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total Amount',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.iconColor,
                          ),
                        ),
                        Text(
                          '₹${totalAmount.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: AppColors.bluePrimaryDual,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                _sectionCard(
                  title: '👤 User Details',
                  children: [
                    _buildDetailRow('Full Name', widget.fullName),
                    _buildDetailRow('Father’s Name', widget.fatherName),
                    _buildDetailRow('Mobile Number', widget.mobileNumber),
                    if (widget.email.isNotEmpty)
                      _buildDetailRow('Email', widget.email),
                    _buildDetailRow('Address', widget.address),
                    _buildDetailRow('Players', widget.playersCount),
                    if (widget.notes.isNotEmpty)
                      _buildDetailRow('Notes', widget.notes),
                  ],
                ),
                const SizedBox(height: 10),
                Center(
                  child: CustomButton(
                    text: 'Proceed to Pay ₹${totalAmount.toStringAsFixed(2)}',
                    color: AppColors.background,
                    onPressed: _showConfirmDialog,
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.lock_outline,
                        size: 16,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Payments are secured',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
