import 'package:flutter/material.dart';
import 'package:sportspark/screens/payment_screen.dart';
import 'package:sportspark/utils/const/const.dart';
import 'package:sportspark/utils/router/router.dart';
import 'package:sportspark/utils/snackbar/snackbar.dart';

class SlotBookingScreen extends StatefulWidget {
  final String turfName;
  final String sportsId;

  const SlotBookingScreen({
    super.key,
    required this.turfName,
    required this.sportsId,
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
                onPressed: () {
                  if (_selectedDate == null) {
                    Messenger.alertError("Please select a date first");

                    return;
                  }
                  if (_selectedSlots.isEmpty) {
                    Messenger.alertError("Please choose at least one timeslot");
                    return;
                  }

                  MyRouter.push(
                    screen: PaymentScreen(
                      userSlectedgame: widget.turfName,
                      selectedDate: _selectedDate!,
                      selectedSlots: _selectedSlots.toList(),
                      timeSlot: _selectedSlots.join(", "),
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
//   DateTime? _selectedDate;
//   final Set<String> _selectedSlots = {};

//   @override
//   void initState() {
//     super.initState();
//     // Fetch slots for today's date initially
//     _selectedDate = DateTime.now();
//     Future.microtask(() {
//       context.read<BookingProvider>().fetchAvailableSlots(widget.sportsId);
//     });
//   }

//   Future<void> _pickDate() async {
//     final picked = await showDatePicker(
//       context: context,
//       initialDate: _selectedDate ?? DateTime.now(),
//       firstDate: DateTime.now(),
//       lastDate: DateTime.now().add(const Duration(days: 365)),
//       builder: (context, child) {
//         return Theme(
//           data: Theme.of(context).copyWith(
//             colorScheme: ColorScheme.fromSeed(
//               seedColor: AppColors.bluePrimaryDual,
//               primary: AppColors.bluePrimaryDual,
//               secondary: AppColors.iconLightColor,
//             ),
//           ),
//           child: child!,
//         );
//       },
//     );

//     if (picked != null) {
//       setState(() {
//         _selectedDate = picked;
//         _selectedSlots.clear();
//       });

//       // Fetch new slots for selected date
//       context.read<BookingProvider>().fetchAvailableSlots(widget.sportsId);
//     }
//   }

//   void _toggleSlot(String slot, bool isBooked) {
//     if (_selectedDate == null) {
//       Messenger.alertError("Please select a date first");
//       return;
//     }

//     if (isBooked) {
//       Messenger.alertError("Slot $slot is already booked");
//       return;
//     }

//     setState(() {
//       if (_selectedSlots.contains(slot)) {
//         _selectedSlots.remove(slot);
//       } else {
//         _selectedSlots.add(slot);
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final bookingProvider = context.watch<BookingProvider>();
//     final isLoading = bookingProvider.isLoading;
//     final slots = bookingProvider.availableSlots;

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
//                           ElevatedButton.icon(
//                             onPressed: _pickDate,
//                             icon: const Icon(Icons.calendar_month, size: 20),
//                             label: Text(
//                               _selectedDate == null
//                                   ? 'Choose Date'
//                                   : '${_selectedDate!.day}/${_selectedDate!.month.toString().padLeft(2, '0')}/${_selectedDate!.year}',
//                             ),
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: AppColors.bluePrimaryDual,
//                               foregroundColor: Colors.white,
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(8),
//                               ),
//                               padding: const EdgeInsets.symmetric(
//                                 horizontal: 16,
//                                 vertical: 12,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),

//             const SizedBox(height: 24),

//             Expanded(
//               child: isLoading
//                   ? const Center(child: CircularProgressIndicator())
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
//                         final slotLabel =
//                             "${slot['start_time']} - ${slot['end_time']}";
//                         final isBooked = slot['status'] != 'AVAILABLE';
//                         final isSelected = _selectedSlots.contains(slotLabel);

//                         return GestureDetector(
//                           onTap: () => _toggleSlot(slotLabel, isBooked),
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
//                               slotLabel.toUpperCase(),
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

//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 onPressed: () async {
//                   if (_selectedDate == null) {
//                     Messenger.alertError("Please select a date first");
//                     return;
//                   }

//                   if (_selectedSlots.isEmpty) {
//                     Messenger.alertError("Please choose at least one timeslot");
//                     return;
//                   }

//                   final bookings = [
//                     {
//                       "booking_date": _selectedDate!.toIso8601String(),
//                       "times": _selectedSlots.map((slot) {
//                         final parts = slot.split(' - ');
//                         return {"start_time": parts[0], "end_time": parts[1]};
//                       }).toList(),
//                     },
//                   ];

//                   final success = await bookingProvider.bookSlots(
//                     widget.sportsId,
//                     bookings,
//                   );

//                   if (success) {
//                     Messenger.alertSuccess("Booking successful");
//                     MyRouter.push(
//                       screen: PaymentScreen(
//                         userSlectedgame: widget.turfName,
//                         selectedDate: _selectedDate!,
//                         selectedSlots: _selectedSlots.toList(),
//                         timeSlot: _selectedSlots.join(", "),
//                       ),
//                     );
//                   } else {
//                     Messenger.alertError(
//                       "Booking failed, please try again later",
//                     );
//                   }
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor:
//                       _selectedSlots.isNotEmpty && _selectedDate != null
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
