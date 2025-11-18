import 'package:flutter/material.dart';
import 'package:sportspark/screens/home_screen.dart';
import 'package:sportspark/utils/const/const.dart';
import 'package:sportspark/utils/router/router.dart';
import 'package:sportspark/utils/snackbar/snackbar.dart';
import 'package:sportspark/utils/widget/custom_button.dart';

class PaymentDeatils extends StatefulWidget {
  final String turfName;
  final DateTime selectedDate;
  final List<String> selectedSlots;
  final String fullName;
  final String fatherName;
  final String mobileNumber;
  final String email;
  final String address;
  final String slotAmount;

  const PaymentDeatils({
    super.key,
    required this.turfName,
    required this.selectedDate,
    required this.selectedSlots,
    required this.fullName,
    required this.fatherName,
    required this.mobileNumber,
    required this.email,
    required this.address,
    required this.slotAmount,
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
    print(widget.selectedSlots);
    print(widget.slotAmount);
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

  Widget _sectionCard({required String title, required List<Widget> children}) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Container(
        margin: const EdgeInsets.only(bottom: 24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gradient header bar
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                gradient: LinearGradient(
                  colors: [AppColors.bluePrimaryDual, Color(0xFF00B8D4)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
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
        crossAxisAlignment: CrossAxisAlignment.start,
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
              style: const TextStyle(
                fontSize: 15,
                color: Colors.black87,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Theme(
      data: Theme.of(context).copyWith(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.bluePrimaryDual,
          primary: AppColors.bluePrimaryDual,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.bluePrimaryDual,
          foregroundColor: Colors.white,
          centerTitle: true,
          elevation: 0,
        ),
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFFF4F6F9),
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          centerTitle: false,
          automaticallyImplyLeading: true,
          title: const Text(
            'Booking Confirmation',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
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
                        '${widget.selectedDate.day}/${widget.selectedDate.month.toString().padLeft(2, '0')}/${widget.selectedDate.year}',
                      ),
                      _buildDetailRow(
                        'Time Slots',
                        widget.selectedSlots.join(", "),
                      ),
                      const Divider(height: 24, color: Colors.grey),
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
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Payment Button
                  //₹${totalAmount.toStringAsFixed(2)}
                  Center(
                    child: CustomButton(
                      text: 'Proceed to Pay ',
                      color: AppColors.background,
                      onPressed: () {
                        _showLogoutDialog(context);
                      },
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
                          'Payments are secured with Razorpay',
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
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
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
              // Center icon
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

              // Title
              const Text(
                "Payment Confirmation!",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
              ),

              const SizedBox(height: 8),

              // Subtitle
              const Text(
                "Are you sure you want to complete the payment?",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),

              const SizedBox(height: 24),

              // Buttons Row
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text("Cancel"),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        MyRouter.pop();
                        Messenger.alertSuccess('Payment successful');
                        MyRouter.pushRemoveUntil(screen: const HomeScreen());
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
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
}
