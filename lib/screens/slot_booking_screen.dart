import 'package:flutter/material.dart';
import 'package:sportspark/screens/login/view/login_screen.dart';
import 'package:sportspark/screens/payment_deatils.dart';
import 'package:sportspark/utils/const/const.dart';
import 'package:sportspark/utils/router/router.dart';
import 'package:sportspark/utils/shared/shared_pref.dart';
import 'package:sportspark/utils/snackbar/snackbar.dart';

class SlotBookingScreen extends StatefulWidget {
  final String turfName;
  final String sportsId;
  final String slotAmount;

  const SlotBookingScreen({
    super.key,
    required this.turfName,
    required this.sportsId,
    required this.slotAmount,
  });

  @override
  State<SlotBookingScreen> createState() => _SlotBookingScreenState();
}

class _SlotBookingScreenState extends State<SlotBookingScreen> {
  DateTime? _selectedDate;
  final Set<String> _selectedSlots = {};
  final Set<String> _bookedSlots = {'10AM - 11AM', '18PM - 19PM'};

  List<String> _generateSlots24() {
    List<String> slots = [];
    for (int h = 0; h < 24; h++) {
      final period = h >= 12 ? 'PM' : 'AM';
      final hour = h == 0 ? 12 : (h > 12 ? h - 12 : h);
      final nextHour = (h + 1) % 24;
      final nextPeriod = nextHour >= 12 ? 'PM' : 'AM';
      final nextHourFormatted = nextHour == 0
          ? 12
          : (nextHour > 12 ? nextHour - 12 : nextHour);
      slots.add('$hour$period - $nextHourFormatted$nextPeriod');
    }
    return slots;
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.fromSeed(
              seedColor: AppColors.bluePrimaryDual,
              primary: AppColors.bluePrimaryDual,
              secondary: AppColors.iconLightColor,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() => _selectedDate = picked);
    }
  }

  void _toggleSlot(String slot) {
    if (_selectedDate == null) {
      Messenger.alertError("Please select a date first");
      return;
    }

    if (_bookedSlots.contains(slot)) {
      Messenger.alertError("Slot $slot is already booked");

      return;
    }

    setState(() {
      if (_selectedSlots.contains(slot)) {
        _selectedSlots.remove(slot);
      } else {
        _selectedSlots.add(slot);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final allSlots = _generateSlots24();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.bluePrimaryDual,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text(
          widget.turfName,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              elevation: 4,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.date_range,
                      color: AppColors.iconColor,
                      size: 28,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Select Date',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.iconColor,
                            ),
                          ),
                          const SizedBox(height: 8),
                          ElevatedButton.icon(
                            onPressed: _pickDate,
                            icon: const Icon(Icons.calendar_month, size: 20),
                            label: Text(
                              _selectedDate == null
                                  ? 'Choose Date'
                                  : '${_selectedDate!.day}/${_selectedDate!.month.toString().padLeft(2, '0')}/${_selectedDate!.year}',
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.bluePrimaryDual,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            Expanded(
              child: GridView.builder(
                itemCount: allSlots.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 2,
                ),
                itemBuilder: (context, index) {
                  final slot = allSlots[index];
                  final isSelected = _selectedSlots.contains(slot);
                  final isBooked = _bookedSlots.contains(slot);

                  return GestureDetector(
                    onTap: () => _toggleSlot(slot),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        gradient: isSelected
                            ? const LinearGradient(
                                colors: [
                                  AppColors.bluePrimaryDual,
                                  Colors.lightBlueAccent,
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              )
                            : null,
                        color: isBooked ? Colors.grey.shade400 : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          if (!isBooked)
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                        ],
                        border: Border.all(
                          color: isSelected
                              ? AppColors.bluePrimaryDual
                              : isBooked
                              ? Colors.grey.shade400
                              : Colors.grey.shade300,
                          width: 1.5,
                        ),
                      ),
                      child: Text(
                        slot.toUpperCase(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: isBooked
                              ? Colors.white70
                              : (isSelected
                                    ? Colors.white
                                    : AppColors.iconColor),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  if (_selectedDate == null) {
                    Messenger.alertError("Please select a date first");
                    return;
                  }
                  if (_selectedSlots.isEmpty) {
                    Messenger.alertError("Please choose at least one timeslot");
                    return;
                  }

                  // Fetch user profile from SharedPreferences
                  final user = await UserPreferences.getUser();

                  if (user == null) {
                    // Messenger.alertError(
                    //   "User data missing. Please login again.",
                    // );
                    MyRouter.push(screen: LoginScreen());
                    return;
                  }

                  // Navigate to PaymentDetails
                  MyRouter.push(
                    screen: PaymentDeatils(
                      turfName: widget.turfName,
                      selectedDate: _selectedDate!,
                      selectedSlots: _selectedSlots.toList(),
                      fullName: user.name,
                      fatherName: user.fatherName,
                      mobileNumber: user.mobile,
                      email: user.email,
                      address: user.address,
                      slotAmount:  widget.slotAmount,
                     
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      _selectedDate != null && _selectedSlots.isNotEmpty
                      ? AppColors.bluePrimaryDual
                      : Colors.grey.shade400,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Next',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:sportspark/screens/admin/booking_service/booking_provider.dart';
// import 'package:sportspark/screens/payment_screen.dart';
// import 'package:sportspark/utils/const/const.dart';
// import 'package:sportspark/utils/router/router.dart';
// import 'package:sportspark/utils/snackbar/snackbar.dart';

// class SlotBookingScreen extends StatefulWidget {
//   final String turfName;
//   final String sportsId;

//   const SlotBookingScreen({
//     super.key,
//     required this.turfName,
//     required this.sportsId,
//   });

//   @override
//   State<SlotBookingScreen> createState() => _SlotBookingScreenState();
// }

// class _SlotBookingScreenState extends State<SlotBookingScreen> {
//   int? _selectedDay;
//   int? _selectedMonth;
//   int? _selectedYear;

//   final Set<String> _selectedSlots = {};

//   DateTime get _today => DateTime.now();

//   // Helper: days in selected month
//   int _daysInMonth() {
//     if (_selectedMonth == null || _selectedYear == null) return 0;
//     return DateTime(_selectedYear!, _selectedMonth! + 1, 0).day;
//   }

//   // Build selected DateTime (only if day is selected)
//   DateTime? get _selectedDate {
//     if (_selectedDay == null || _selectedMonth == null || _selectedYear == null)
//       return null;
//     return DateTime(_selectedYear!, _selectedMonth!, _selectedDay!);
//   }

//   String _monthName(int m) {
//     const names = [
//       'JAN',
//       'FEB',
//       'MAR',
//       'APR',
//       'MAY',
//       'JUN',
//       'JUL',
//       'AUG',
//       'SEP',
//       'OCT',
//       'NOV',
//       'DEC',
//     ];
//     return names[m - 1];
//   }

//   void _fetchSlots() {
//     final provider = context.read<BookingProvider>();

//     if (_selectedDay != null) {
//       // DAY MODE
//       final dateStr =
//           '${_selectedYear!.toString().padLeft(4, '0')}-${_selectedMonth!.toString().padLeft(2, '0')}-${_selectedDay!.toString().padLeft(2, '0')}';
//       provider.fetchAvailableSlots(sportsId: widget.sportsId, date: dateStr);
//     } else if (_selectedMonth != null && _selectedYear != null) {
//       // MONTH MODE
//       provider.fetchAvailableSlots(
//         sportsId: widget.sportsId,
//         typeMonth: _monthName(_selectedMonth!),
//         typeYear: _selectedYear!,
//       );
//     }
//   }

//   void _onDateChanged() {
//     _selectedSlots.clear();
//     if (_selectedMonth != null && _selectedYear != null) {
//       _fetchSlots();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final provider = context.watch<BookingProvider>();
//     final isLoading = provider.isLoading;
//     final slots = provider.availableSlots;

//     // Month list: current to +11 months
//     final months = List.generate(12, (i) {
//       final d = DateTime(_today.year, _today.month + i);
//       return {
//         'value': d.month,
//         'label':
//             '${_monthName(d.month)} ${d.year == _today.year ? '' : d.year}',
//       };
//     });

//     final years = [_today.year, _today.year + 1];

//     // Days: current & future only (only if month/year selected)
//     final maxDay = _daysInMonth();
//     final days = maxDay > 0
//         ? List.generate(maxDay, (i) => i + 1).where((d) {
//             if (_selectedMonth == _today.month &&
//                 _selectedYear == _today.year) {
//               return d >= _today.day;
//             }
//             return true;
//           }).toList()
//         : <int>[];

//     // Reset invalid day
//     if (_selectedDay != null && (maxDay == 0 || _selectedDay! > maxDay)) {
//       _selectedDay = null;
//     }

//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: AppColors.bluePrimaryDual,
//         foregroundColor: Colors.white,
//         elevation: 0,
//         title: Text(
//           widget.turfName,
//           style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             // ==================== DATE CARD WITH 3 DROPDOWNS ====================
//             Card(
//               elevation: 4,
//               color: Colors.white,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Row(
//                   children: [
//                     Icon(
//                       Icons.date_range,
//                       color: AppColors.iconColor,
//                       size: 28,
//                     ),
//                     const SizedBox(width: 12),
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             'Select Date',
//                             style: TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.bold,
//                               color: AppColors.iconColor,
//                             ),
//                           ),
//                           const SizedBox(height: 8),
//                           // 3 DROPDOWNS IN A ROW
//                           Row(
//                             children: [
//                               // DAY
//                               Expanded(
//                                 child: DropdownButtonFormField<int>(
//                                   value: _selectedDay,
//                                   hint: const Text('Day'),
//                                   decoration: InputDecoration(
//                                     border: OutlineInputBorder(
//                                       borderRadius: BorderRadius.circular(8),
//                                     ),
//                                   ),
//                                   items: days
//                                       .map(
//                                         (d) => DropdownMenuItem(
//                                           value: d,
//                                           child: Text(d.toString()),
//                                         ),
//                                       )
//                                       .toList(),
//                                   onChanged: days.isEmpty
//                                       ? null
//                                       : (v) {
//                                           setState(() => _selectedDay = v);
//                                           _onDateChanged();
//                                         },
//                                 ),
//                               ),
//                               const SizedBox(width: 8),

//                               // MONTH
//                               Expanded(
//                                 child: DropdownButtonFormField<int>(
//                                   value: _selectedMonth,
//                                   hint: const Text('Month'),
//                                   decoration: InputDecoration(
//                                     border: OutlineInputBorder(
//                                       borderRadius: BorderRadius.circular(8),
//                                     ),
//                                   ),
//                                   items: months
//                                       .map(
//                                         (m) => DropdownMenuItem(
//                                           value: m['value'] as int,
//                                           child: Text(m['label'] as String),
//                                         ),
//                                       )
//                                       .toList(),
//                                   onChanged: (v) {
//                                     setState(() {
//                                       _selectedMonth = v;
//                                       _selectedDay = null;
//                                     });
//                                     _onDateChanged();
//                                   },
//                                 ),
//                               ),
//                               const SizedBox(width: 8),

//                               // YEAR
//                               Expanded(
//                                 child: DropdownButtonFormField<int>(
//                                   value: _selectedYear,
//                                   hint: const Text('Year'),
//                                   decoration: InputDecoration(
//                                     border: OutlineInputBorder(
//                                       borderRadius: BorderRadius.circular(8),
//                                     ),
//                                   ),
//                                   items: years
//                                       .map(
//                                         (y) => DropdownMenuItem(
//                                           value: y,
//                                           child: Text(y.toString()),
//                                         ),
//                                       )
//                                       .toList(),
//                                   onChanged: (v) {
//                                     setState(() {
//                                       _selectedYear = v;
//                                       _selectedDay = null;
//                                     });
//                                     _onDateChanged();
//                                   },
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             const SizedBox(height: 24),

//             // ==================== SLOT GRID ====================
//             Expanded(
//               child: isLoading
//                   ? const Center(child: CircularProgressIndicator())
//                   : (_selectedMonth == null || _selectedYear == null)
//                   ? const Center(
//                       child: Text(
//                         "Please select Month and Year to view slots",
//                         style: TextStyle(fontSize: 16, color: Colors.grey),
//                       ),
//                     )
//                   : slots.isEmpty
//                   ? const Center(child: Text("No slots available"))
//                   : GridView.builder(
//                       itemCount: slots.length,
//                       gridDelegate:
//                           const SliverGridDelegateWithFixedCrossAxisCount(
//                             crossAxisCount: 4,
//                             mainAxisSpacing: 16,
//                             crossAxisSpacing: 16,
//                             childAspectRatio: 2,
//                           ),
//                       itemBuilder: (context, index) {
//                         final slot = slots[index];
//                         final start = slot['start_time'] as String;
//                         final end = slot['end_time'] as String;
//                         final label = '$start - $end';
//                         final isBooked = slot['status'] != 'AVAILABLE';
//                         final isSelected = _selectedSlots.contains(label);

//                         return GestureDetector(
//                           onTap: isBooked
//                               ? () => Messenger.alertError(
//                                   "Slot $label is booked",
//                                 )
//                               : () {
//                                   setState(() {
//                                     isSelected
//                                         ? _selectedSlots.remove(label)
//                                         : _selectedSlots.add(label);
//                                   });
//                                 },
//                           child: AnimatedContainer(
//                             duration: const Duration(milliseconds: 250),
//                             alignment: Alignment.center,
//                             decoration: BoxDecoration(
//                               gradient: isSelected
//                                   ? const LinearGradient(
//                                       colors: [
//                                         AppColors.bluePrimaryDual,
//                                         Colors.lightBlueAccent,
//                                       ],
//                                       begin: Alignment.topLeft,
//                                       end: Alignment.bottomRight,
//                                     )
//                                   : null,
//                               color: isBooked
//                                   ? Colors.grey.shade400
//                                   : Colors.white,
//                               borderRadius: BorderRadius.circular(12),
//                               boxShadow: [
//                                 if (!isBooked)
//                                   BoxShadow(
//                                     color: Colors.black.withOpacity(0.05),
//                                     blurRadius: 4,
//                                     offset: const Offset(0, 2),
//                                   ),
//                               ],
//                               border: Border.all(
//                                 color: isSelected
//                                     ? AppColors.bluePrimaryDual
//                                     : isBooked
//                                     ? Colors.grey.shade400
//                                     : Colors.grey.shade300,
//                                 width: 1.5,
//                               ),
//                             ),
//                             child: Text(
//                               label.toUpperCase(),
//                               textAlign: TextAlign.center,
//                               style: TextStyle(
//                                 fontSize: 12,
//                                 fontWeight: FontWeight.w600,
//                                 color: isBooked
//                                     ? Colors.white70
//                                     : (isSelected
//                                           ? Colors.white
//                                           : AppColors.iconColor),
//                               ),
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//             ),
//             const SizedBox(height: 16),

//             // ==================== NEXT BUTTON ====================
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 onPressed: () async {
//                   if (_selectedMonth == null || _selectedYear == null) {
//                     Messenger.alertError("Please select month and year");
//                     return;
//                   }
//                   if (_selectedSlots.isEmpty) {
//                     Messenger.alertError(
//                       "Please select at least one time slot",
//                     );
//                     return;
//                   }

//                   final isDayMode = _selectedDay != null;
//                   final times = _selectedSlots.map((s) {
//                     final parts = s.split(' - ');
//                     return {"start_time": parts[0], "end_time": parts[1]};
//                   }).toList();

//                   final success = await context.read<BookingProvider>().bookSlots(
//                     sportsId: widget.sportsId,
//                     slotType: isDayMode ? "DAY" : "MONTH",
//                     bookingDate: isDayMode
//                         ? '${_selectedYear!.toString().padLeft(4, '0')}-${_selectedMonth!.toString().padLeft(2, '0')}-${_selectedDay!.toString().padLeft(2, '0')}'
//                         : null,
//                     typeMonth: !isDayMode ? _monthName(_selectedMonth!) : null,
//                     typeYear: !isDayMode ? _selectedYear! : null,
//                     times: times,
//                   );

//                   if (success) {
//                     Messenger.alertSuccess("Booking successful!");
//                     MyRouter.push(
//                       screen: PaymentScreen(
//                         userSlectedgame: widget.turfName,
//                         selectedDate:
//                             _selectedDate ??
//                             DateTime(_selectedYear!, _selectedMonth!),
//                         selectedSlots: _selectedSlots.toList(),
//                         timeSlot: _selectedSlots.join(", "),
//                       ),
//                     );
//                   } else {
//                     Messenger.alertError("Booking failed. Try again.");
//                   }
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: _selectedSlots.isNotEmpty
//                       ? AppColors.bluePrimaryDual
//                       : Colors.grey.shade400,
//                   foregroundColor: Colors.white,
//                   padding: const EdgeInsets.symmetric(vertical: 16),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                 ),
//                 child: const Text(
//                   'Next',
//                   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
