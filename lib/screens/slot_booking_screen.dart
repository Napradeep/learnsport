// import 'package:flutter/material.dart';
// import 'package:sportspark/screens/PlayersNotesScreen.dart';
// import 'package:sportspark/screens/login/view/login_screen.dart';
// import 'package:sportspark/screens/payment_deatils.dart';
// import 'package:sportspark/utils/const/const.dart';
// import 'package:sportspark/utils/router/router.dart';
// import 'package:sportspark/utils/shared/shared_pref.dart';
// import 'package:sportspark/utils/snackbar/snackbar.dart';

// class SlotBookingScreen extends StatefulWidget {
//   final String turfName;
//   final String sportsId;
//   final String slotAmount;

//   const SlotBookingScreen({
//     super.key,
//     required this.turfName,
//     required this.sportsId,
//     required this.slotAmount,
//   });

//   @override
//   State<SlotBookingScreen> createState() => _SlotBookingScreenState();
// }

// class _SlotBookingScreenState extends State<SlotBookingScreen> {
//   DateTime? _selectedDate;
//   final Set<String> _selectedSlots = {};
//   final Set<String> _bookedSlots = {'10AM - 11AM', '18PM - 19PM'};

//   List<String> _generateSlots24() {
//     List<String> slots = [];
//     for (int h = 0; h < 24; h++) {
//       final period = h >= 12 ? 'PM' : 'AM';
//       final hour = h == 0 ? 12 : (h > 12 ? h - 12 : h);
//       final nextHour = (h + 1) % 24;
//       final nextPeriod = nextHour >= 12 ? 'PM' : 'AM';
//       final nextHourFormatted = nextHour == 0
//           ? 12
//           : (nextHour > 12 ? nextHour - 12 : nextHour);
//       slots.add('$hour$period - $nextHourFormatted$nextPeriod');
//     }
//     return slots;
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
//     if (picked != null && picked != _selectedDate) {
//       setState(() => _selectedDate = picked);
//     }
//   }

//   void _toggleSlot(String slot) {
//     if (_selectedDate == null) {
//       Messenger.alertError("Please select a date first");
//       return;
//     }

//     if (_bookedSlots.contains(slot)) {
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
//     final allSlots = _generateSlots24();

//     return Scaffold(
//       appBar: AppBar(
//          centerTitle: false,
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
//               child: GridView.builder(
//                 itemCount: allSlots.length,
//                 gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 4,
//                   mainAxisSpacing: 16,
//                   crossAxisSpacing: 16,
//                   childAspectRatio: 2,
//                 ),
//                 itemBuilder: (context, index) {
//                   final slot = allSlots[index];
//                   final isSelected = _selectedSlots.contains(slot);
//                   final isBooked = _bookedSlots.contains(slot);

//                   return GestureDetector(
//                     onTap: () => _toggleSlot(slot),
//                     child: AnimatedContainer(
//                       duration: const Duration(milliseconds: 250),
//                       alignment: Alignment.center,
//                       decoration: BoxDecoration(
//                         gradient: isSelected
//                             ? const LinearGradient(
//                                 colors: [
//                                   AppColors.bluePrimaryDual,
//                                   Colors.lightBlueAccent,
//                                 ],
//                                 begin: Alignment.topLeft,
//                                 end: Alignment.bottomRight,
//                               )
//                             : null,
//                         color: isBooked ? Colors.grey.shade400 : Colors.white,
//                         borderRadius: BorderRadius.circular(12),
//                         boxShadow: [
//                           if (!isBooked)
//                             BoxShadow(
//                               color: Colors.black.withOpacity(0.05),
//                               blurRadius: 4,
//                               offset: const Offset(0, 2),
//                             ),
//                         ],
//                         border: Border.all(
//                           color: isSelected
//                               ? AppColors.bluePrimaryDual
//                               : isBooked
//                               ? Colors.grey.shade400
//                               : Colors.grey.shade300,
//                           width: 1.5,
//                         ),
//                       ),
//                       child: Text(
//                         slot.toUpperCase(),
//                         textAlign: TextAlign.center,
//                         style: TextStyle(
//                           fontSize: 12,
//                           fontWeight: FontWeight.w600,
//                           color: isBooked
//                               ? Colors.white70
//                               : (isSelected
//                                     ? Colors.white
//                                     : AppColors.iconColor),
//                         ),
//                       ),
//                     ),
//                   );
//                 },
//               ),
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

//                   // Fetch user profile from SharedPreferences
//                   final user = await UserPreferences.getUser();

//                   if (user == null) {
//                     // Messenger.alertError(
//                     //   "User data missing. Please login again.",
//                     // );
//                     MyRouter.push(screen: LoginScreen());
//                     return;
//                   }

//                   // Navigate to PaymentDetails
//                   MyRouter.push(
//                     screen: PlayersNotesScreen(
//                       turfName: widget.turfName,
//                       selectedDate: _selectedDate!,
//                       selectedSlots: _selectedSlots.toList(),
//                       fullName: user.name,
//                       fatherName: user.fatherName,
//                       mobileNumber: user.mobile,
//                       email: user.email,
//                       address: user.address,
//                       slotAmount: widget.slotAmount,
//                     ),
//                   );
//                   // MyRouter.push(
//                   //   screen: PaymentDeatils(
//                   // turfName: widget.turfName,
//                   // selectedDate: _selectedDate!,
//                   // selectedSlots: _selectedSlots.toList(),
//                   // fullName: user.name,
//                   // fatherName: user.fatherName,
//                   // mobileNumber: user.mobile,
//                   // email: user.email,
//                   // address: user.address,
//                   // slotAmount:  widget.slotAmount, playersCount: '', notes: '',

//                   //   ),
//                   // );
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor:
//                       _selectedDate != null && _selectedSlots.isNotEmpty
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

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:sportspark/screens/login/view/login_screen.dart';
// import 'package:sportspark/screens/PlayersNotesScreen.dart';
// import 'package:sportspark/screens/admin/booking_service/booking_provider.dart';
// import 'package:sportspark/utils/router/router.dart';
// import 'package:sportspark/utils/snackbar/snackbar.dart';
// import 'package:sportspark/utils/shared/shared_pref.dart';
// import 'package:sportspark/utils/const/const.dart';

// class SlotBookingScreen extends StatefulWidget {
//   final String turfName;
//   final String sportsId;
//   final String slotAmount;

//   const SlotBookingScreen({
//     super.key,
//     required this.turfName,
//     required this.sportsId,
//     required this.slotAmount,
//   });

//   @override
//   State<SlotBookingScreen> createState() => _SlotBookingScreenState();
// }

// class _SlotBookingScreenState extends State<SlotBookingScreen> {
//   String _slotType = "DAY";
//   DateTime? _selectedDate;

//   String? _selectedMonth;
//   int? _selectedYear;

//   final Set<String> _selectedSlots = {};

//   final List<String> months = const [
//     "JAN",
//     "FEB",
//     "MAR",
//     "APR",
//     "MAY",
//     "JUN",
//     "JUL",
//     "AUG",
//     "SEP",
//     "OCT",
//     "NOV",
//     "DEC",
//   ];

//   List<int> years = [];

//   @override
//   void initState() {
//     super.initState();
//     int year = DateTime.now().year;
//     years = [year, year + 1, year + 2];
//   }

//   bool _isPastSlot(String time) {
//     if (_slotType == "MONTH") return false;
//     final now = DateTime.now();
//     final parts = time.split(":");
//     final slotTime = DateTime(
//       now.year,
//       now.month,
//       now.day,
//       int.parse(parts[0]),
//       int.parse(parts[1]),
//     );
//     return slotTime.isBefore(now);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: AppColors.bluePrimaryDual,
//         foregroundColor: Colors.white,
//         title: Text(widget.turfName),
//       ),
//       body: Consumer<BookingProvider>(
//         builder: (context, provider, _) {
//           return Padding(
//             padding: const EdgeInsets.all(16),
//             child: Column(
//               children: [
//                 DropdownButtonFormField(
//                   value: _slotType,
//                   decoration: InputDecoration(
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                   ),
//                   items: const [
//                     DropdownMenuItem(value: "DAY", child: Text("DAY")),
//                     DropdownMenuItem(value: "MONTH", child: Text("MONTH")),
//                   ],
//                   onChanged: (value) {
//                     _slotType = value!;
//                     _selectedSlots.clear();
//                     _selectedDate = null;
//                     _selectedMonth = null;
//                     _selectedYear = null;

//                     Provider.of<BookingProvider>(
//                       context,
//                       listen: false,
//                     ).clearSlots();
//                     setState(() {});
//                   },
//                 ),

//                 const SizedBox(height: 16),

//                 if (_slotType == "DAY") _datePicker(provider),
//                 if (_slotType == "MONTH") _monthYearPicker(provider),

//                 const SizedBox(height: 16),

//                 provider.isLoading
//                     ? const CircularProgressIndicator()
//                     : Expanded(
//                         child: provider.availableSlots.isEmpty
//                             ? const Center(
//                                 child: Text(
//                                   "Select date or month to view slots",
//                                 ),
//                               )
//                             : _slotGrid(provider),
//                       ),

//                 const SizedBox(height: 16),

//                 _nextBtn(provider),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }

//   Widget _slotGrid(BookingProvider provider) {
//     return GridView.builder(
//       itemCount: provider.availableSlots.length,
//       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: 4,
//         childAspectRatio: 2,
//         mainAxisSpacing: 10,
//         crossAxisSpacing: 10,
//       ),
//       itemBuilder: (context, index) {
//         final slot = provider.availableSlots[index];
//         final text = "${slot.startTime} - ${slot.endTime}";
//         final isBooked = slot.status != "AVAILABLE";
//         final isPast = _isPastSlot(slot.startTime);
//         final isSelected = _selectedSlots.contains(text);

//         return GestureDetector(
//           onTap: () {
//             if (isBooked || isPast) return;
//             setState(() {
//               isSelected
//                   ? _selectedSlots.remove(text)
//                   : _selectedSlots.add(text);
//             });
//           },
//           child: Container(
//             alignment: Alignment.center,
//             decoration: BoxDecoration(
//               color: isBooked
//                   ? Colors.red.shade400
//                   : isPast
//                   ? Colors.grey.shade400
//                   : isSelected
//                   ? AppColors.bluePrimaryDual
//                   : Colors.white,
//               borderRadius: BorderRadius.circular(12),
//               border: Border.all(color: Colors.black26),
//             ),
//             child: Text(
//               text,
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 color: isSelected || isBooked ? Colors.white : Colors.black,
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Widget _datePicker(BookingProvider provider) {
//     return Card(
//       child: ListTile(
//         title: Text(
//           _selectedDate == null
//               ? "Choose Date"
//               : "${_selectedDate!.day}-${_selectedDate!.month}-${_selectedDate!.year}",
//         ),
//         trailing: const Icon(Icons.calendar_month),
//         onTap: () async {
//           final picked = await showDatePicker(
//             context: context,
//             initialDate: DateTime.now(),
//             firstDate: DateTime.now(),
//             lastDate: DateTime.now().add(const Duration(days: 365)),
//           );
//           if (picked != null) {
//             _selectedDate = picked;
//             Provider.of<BookingProvider>(
//               context,
//               listen: false,
//             ).fetchAvailableSlots(
//               sportsId: widget.sportsId,
//               date: "${picked.year}-${picked.month}-${picked.day}",
//             );
//           }
//           setState(() {});
//         },
//       ),
//     );
//   }

//   Widget _monthYearPicker(BookingProvider provider) {
//     return Row(
//       children: [
//         Expanded(
//           child: DropdownButtonFormField(
//             value: _selectedMonth,
//             hint: const Text("Select Month"),
//             items: months
//                 .map((m) => DropdownMenuItem(value: m, child: Text(m)))
//                 .toList(),
//             onChanged: (value) {
//               _selectedMonth = value as String?;
//               if (_selectedYear != null && _selectedMonth != null) {
//                 Provider.of<BookingProvider>(
//                   context,
//                   listen: false,
//                 ).fetchAvailableSlots(
//                   sportsId: widget.sportsId,
//                   typeMonth: _selectedMonth!,
//                   typeYear: _selectedYear!,
//                 );
//               }
//               setState(() {});
//             },
//           ),
//         ),
//         const SizedBox(width: 10),
//         Expanded(
//           child: DropdownButtonFormField(
//             value: _selectedYear,
//             hint: const Text("Year"),
//             items: years
//                 .map((y) => DropdownMenuItem(value: y, child: Text("$y")))
//                 .toList(),
//             onChanged: (value) {
//               _selectedYear = value as int?;
//               if (_selectedMonth != null && _selectedYear != null) {
//                 Provider.of<BookingProvider>(
//                   context,
//                   listen: false,
//                 ).fetchAvailableSlots(
//                   sportsId: widget.sportsId,
//                   typeMonth: _selectedMonth!,
//                   typeYear: _selectedYear!,
//                 );
//               }
//               setState(() {});
//             },
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _nextBtn(BookingProvider provider) {
//     return ElevatedButton(
//       onPressed: () async {
//         if (_selectedSlots.isEmpty)
//           return Messenger.alertError("Select atleast one slot");

//         if (_slotType == "DAY" && _selectedDate == null) {
//           return Messenger.alertError("Select date");
//         }

//         if (_slotType == "MONTH" &&
//             (_selectedMonth == null || _selectedYear == null)) {
//           return Messenger.alertError("Select month & year");
//         }

//         final user = await UserPreferences.getUser();
//         if (user == null) return MyRouter.push(screen: LoginScreen());

//         print(_selectedMonth);
//         print(_selectedYear);
//         MyRouter.push(
//           screen: PlayersNotesScreen(
//             sportsId: widget.sportsId,
//             turfName: widget.turfName,
//             selectedDate: _selectedDate ?? DateTime.now(),
//             selectedSlots: _selectedSlots.toList(),
//             fullName: user.name,
//             fatherName: user.fatherName,
//             mobileNumber: user.mobile,
//             email: user.email,
//             address: user.address,
//             slotAmount: widget.slotAmount,
//             slotType: _slotType,
//             typeMonth: _slotType == "MONTH" ? _selectedMonth : null,
//             typeYear: _slotType == "MONTH" ? _selectedYear : null,
//           ),
//         );
//       },
//       style: ElevatedButton.styleFrom(
//         backgroundColor: _selectedSlots.isNotEmpty
//             ? AppColors.bluePrimaryDual
//             : Colors.grey,
//       ),
//       child: const Text("Next", style: TextStyle(color: Colors.white)),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sportspark/screens/login/view/login_screen.dart';
import 'package:sportspark/screens/PlayersNotesScreen.dart';
import 'package:sportspark/screens/admin/booking_service/booking_provider.dart';
import 'package:sportspark/utils/router/router.dart';
import 'package:sportspark/utils/snackbar/snackbar.dart';
import 'package:sportspark/utils/shared/shared_pref.dart';
import 'package:sportspark/utils/const/const.dart';

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
  String _slotType = "DAY";
  DateTime? _selectedDate;
  String? _selectedMonth;
  int? _selectedYear;

  final Set<String> _selectedSlots = {};

  // Months list
  final List<String> months = const [
    "JAN", "FEB", "MAR", "APR", "MAY", "JUN",
    "JUL", "AUG", "SEP", "OCT", "NOV", "DEC"
  ];

  // Dynamic years: current year → +10 years
  late final List<int> years;

  @override
  void initState() {
    super.initState();

    // Generate years
    final currentYear = DateTime.now().year;
    years = List.generate(11, (i) => currentYear + i);

    // Critical: Clear old data when screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<BookingProvider>(context, listen: false);
      provider.clearSlots();
      _resetAllSelections();
    });
  }

  // Reset when switching to a different turf/sportsId
  @override
  void didUpdateWidget(covariant SlotBookingScreen oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.sportsId != widget.sportsId) {
      final provider = Provider.of<BookingProvider>(context, listen: false);
      provider.clearSlots();
      _resetAllSelections();
    }
  }

  // Helper: Full reset
  void _resetAllSelections() {
    setState(() {
      _selectedSlots.clear();
      _selectedDate = null;
      _selectedMonth = null;
      _selectedYear = null;
      _slotType = "DAY";
    });
  }

  // Reset when switching DAY ↔ MONTH
  void _resetSelectionOnTypeChange(BookingProvider provider) {
    setState(() {
      _selectedSlots.clear();
      _selectedDate = null;
      _selectedMonth = null;
      _selectedYear = null;
    });
    provider.clearSlots();
  }

  // Check if slot is in the past (only for DAY and today)
  bool _isPastSlot(String time) {
    if (_slotType != "DAY" || _selectedDate == null) return false;

    final now = DateTime.now();
    final selectedDay = DateTime(_selectedDate!.year, _selectedDate!.month, _selectedDate!.day);

    if (selectedDay.year == now.year &&
        selectedDay.month == now.month &&
        selectedDay.day == now.day) {
      final parts = time.split(":");
      final slotTime = DateTime(
        now.year, now.month, now.day,
        int.parse(parts[0]), int.parse(parts[1]),
      );
      return slotTime.isBefore(now);
    }
    return false;
  }

  // Fetch slots only when valid selection exists
  void _fetchSlotsIfValid(BookingProvider provider) {
    if (_slotType == "DAY" && _selectedDate != null) {
      final dateStr = "${_selectedDate!.year}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.day.toString().padLeft(2, '0')}";
      provider.fetchAvailableSlots(sportsId: widget.sportsId, date: dateStr);
    } else if (_slotType == "MONTH" && _selectedMonth != null && _selectedYear != null) {
      provider.fetchAvailableSlots(
        sportsId: widget.sportsId,
        typeMonth: _selectedMonth!,
        typeYear: _selectedYear!,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: AppColors.bluePrimaryDual,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text(
          widget.turfName,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: Consumer<BookingProvider>(
        builder: (context, provider, _) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Slot Type Dropdown
                DropdownButtonFormField<String>(
                  value: _slotType,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  items: const [
                    DropdownMenuItem(value: "DAY", child: Text("DAY")),
                    DropdownMenuItem(value: "MONTH", child: Text("MONTH")),
                  ],
                  onChanged: (value) {
                    if (value != null && value != _slotType) {
                      setState(() => _slotType = value);
                      _resetSelectionOnTypeChange(provider);
                    }
                  },
                ),
                const SizedBox(height: 16),

                // Pickers
                if (_slotType == "DAY") _dayPicker(provider),
                if (_slotType == "MONTH") _monthYearPicker(provider),

                const SizedBox(height: 20),

                // Content Area
                provider.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : provider.availableSlots.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.event_busy,
                                  size: 70,
                                  color: Colors.grey.shade400,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  _slotType == "DAY"
                                      ? "Please select a date to view available slots"
                                      : "Please select month & year to view slots",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey.shade600,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          )
                        : Expanded(child: _slotGrid(provider)),

                const SizedBox(height: 20),

                // Next Button
                _nextBtn(provider),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _dayPicker(BookingProvider provider) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: const Icon(Icons.calendar_today, color: AppColors.bluePrimaryDual),
        title: Text(
          _selectedDate == null
              ? "Choose Date"
              : "${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}",
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        trailing: const Icon(Icons.keyboard_arrow_down),
        onTap: () async {
          final picked = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime.now(),
            lastDate: DateTime.now().add(const Duration(days: 730)),
            builder: (context, child) => Theme(
              data: Theme.of(context).copyWith(
                colorScheme: const ColorScheme.light(primary: AppColors.bluePrimaryDual),
              ),
              child: child!,
            ),
          );

          if (picked != null) {
            setState(() {
              _selectedDate = picked;
              _selectedSlots.clear();
            });
            _fetchSlotsIfValid(provider);
          }
        },
      ),
    );
  }

  Widget _monthYearPicker(BookingProvider provider) {
    return Row(
      children: [
        Expanded(
          child: DropdownButtonFormField<String>(
            value: _selectedMonth,
            hint: const Text("Month"),
            decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
            items: months.map((m) => DropdownMenuItem(value: m, child: Text(m))).toList(),
            onChanged: (v) {
              setState(() {
                _selectedMonth = v;
                _selectedSlots.clear();
              });
              if (_selectedYear != null) _fetchSlotsIfValid(provider);
            },
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: DropdownButtonFormField<int>(
            value: _selectedYear,
            hint: const Text("Year"),
            decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
            items: years.map((y) => DropdownMenuItem(value: y, child: Text("$y"))).toList(),
            onChanged: (v) {
              setState(() {
                _selectedYear = v;
                _selectedSlots.clear();
              });
              if (_selectedMonth != null) _fetchSlotsIfValid(provider);
            },
          ),
        ),
      ],
    );
  }

  Widget _slotGrid(BookingProvider provider) {
    return GridView.builder(
      itemCount: provider.availableSlots.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 14,
        crossAxisSpacing: 14,
        childAspectRatio: 2,
      ),
      itemBuilder: (_, i) {
        final slot = provider.availableSlots[i];
        final text = "${slot.startTime} - ${slot.endTime}";
        final isBooked = slot.status != "AVAILABLE";
        final isPast = _isPastSlot(slot.startTime);
        final isSelected = _selectedSlots.contains(text);

        return GestureDetector(
          onTap: (isBooked || isPast)
              ? null
              : () => setState(() => isSelected ? _selectedSlots.remove(text) : _selectedSlots.add(text)),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              gradient: isSelected
                  ? const LinearGradient(
                      colors: [AppColors.bluePrimaryDual, Colors.lightBlueAccent],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : null,
              color: isBooked || isPast ? Colors.grey.shade400 : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected
                    ? AppColors.bluePrimaryDual
                    : (isBooked || isPast)
                        ? Colors.grey.shade400
                        : Colors.grey.shade300,
                width: 1.8,
              ),
            ),
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isBooked || isPast || isSelected ? Colors.white : Colors.black87,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _nextBtn(BookingProvider provider) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () async {
          if (_selectedSlots.isEmpty) {
            return Messenger.alertError("Please select at least one slot");
          }
          if (_slotType == "DAY" && _selectedDate == null) {
            return Messenger.alertError("Please select a date");
          }
          if (_slotType == "MONTH" && (_selectedMonth == null || _selectedYear == null)) {
            return Messenger.alertError("Please select both month and year");
          }

          final user = await UserPreferences.getUser();
          if (user == null) {
            MyRouter.push(screen: const LoginScreen());
            return;
          }

          MyRouter.push(
            screen: PlayersNotesScreen(
              sportsId: widget.sportsId,
              turfName: widget.turfName,
              selectedDate: _selectedDate ?? DateTime.now(),
              selectedSlots: _selectedSlots.toList(),
              fullName: user.name,
              fatherName: user.fatherName,
              mobileNumber: user.mobile,
              email: user.email,
              address: user.address,
              slotAmount: widget.slotAmount,
              slotType: _slotType,
              typeMonth: _slotType == "MONTH" ? _selectedMonth : null,
              typeYear: _slotType == "MONTH" ? _selectedYear : null,
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: _selectedSlots.isNotEmpty ? AppColors.bluePrimaryDual : Colors.grey.shade400,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: const Text(
          "Next",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
    );
  }
}