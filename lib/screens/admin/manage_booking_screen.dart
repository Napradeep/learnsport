// import 'package:flutter/material.dart';
// import 'package:sportspark/utils/const/const.dart';

// class BookingHistoryScreen extends StatefulWidget {
//   const BookingHistoryScreen({super.key});

//   @override
//   State<BookingHistoryScreen> createState() => _BookingHistoryScreenState();
// }

// class _BookingHistoryScreenState extends State<BookingHistoryScreen>
//     with TickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<double> _fadeAnimation;
//   late Animation<Offset> _slideAnimation;

//   // Dummy data for bookings
//   final List<Map<String, dynamic>> _dummyBookings = [
//     {
//       'id': 1,
//       'userName': 'John Doe',
//       'gameType': 'Football',
//       'turfName': 'Green Turf Arena',
//       'date': '2025-10-07',
//       'timeSlot': '6am - 7am',
//       'hours': 1,
//       'amount': 500,
//       'paid': true,
//       'imageUrl':
//           'https://images.unsplash.com/photo-1559526324-4b87b5e36fa5?w=100&h=100&fit=crop',
//       'fatherName': 'Jane Doe',
//       'mobile': '+91 9876543210',
//       'email': 'john.doe@example.com',
//       'address': '123 Main St, City, State 12345',
//       'description': 'Casual football match with friends',
//     },
//     {
//       'id': 2,
//       'userName': 'Alice Smith',
//       'gameType': 'Cricket',
//       'turfName': 'City Cricket Ground',
//       'date': '2025-10-08',
//       'timeSlot': '8am - 10am',
//       'hours': 2,
//       'amount': 1000,
//       'paid': false,
//       'imageUrl':
//           'https://images.unsplash.com/photo-1579952363873-27d3bfad9c8f?w=100&h=100&fit=crop',
//       'fatherName': 'Bob Smith',
//       'mobile': '+91 1234567890',
//       'email': 'alice.smith@example.com',
//       'address': '456 Oak Ave, Town, State 67890',
//       'description': 'Practice session for league match',
//     },
//     {
//       'id': 3,
//       'userName': 'Mike Johnson',
//       'gameType': 'Badminton',
//       'turfName': 'Elite Badminton Hall',
//       'date': '2025-10-09',
//       'timeSlot': '7am - 9am',
//       'hours': 2,
//       'amount': 800,
//       'paid': true,
//       'imageUrl':
//           'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=100&h=100&fit=crop',
//       'fatherName': 'Sarah Johnson',
//       'mobile': '+91 5556667777',
//       'email': 'mike.j@example.com',
//       'address': '789 Pine Rd, Village, State 11223',
//       'description': 'Doubles match tournament',
//     },
//     {
//       'id': 4,
//       'userName': 'Emily Davis',
//       'gameType': 'Football',
//       'turfName': 'Green Turf Arena',
//       'date': '2025-10-10',
//       'timeSlot': '9am - 11am',
//       'hours': 2,
//       'amount': 1000,
//       'paid': true,
//       'imageUrl':
//           'https://images.unsplash.com/photo-1559526324-4b87b5e36fa5?w=100&h=100&fit=crop',
//       'fatherName': 'Tom Davis',
//       'mobile': '+91 4445556666',
//       'email': 'emily.davis@example.com',
//       'address': '321 Elm St, Metro, State 44556',
//       'description': 'Team practice',
//     },
//     {
//       'id': 5,
//       'userName': 'David Wilson',
//       'gameType': 'Tennis',
//       'turfName': 'Royal Tennis Club',
//       'date': '2025-10-11',
//       'timeSlot': '5pm - 6pm',
//       'hours': 1,
//       'amount': 600,
//       'paid': false,
//       'imageUrl':
//           'https://images.unsplash.com/photo-1612872087720-bb876e2e67d1?w=100&h=100&fit=crop',
//       'fatherName': 'Lisa Wilson',
//       'mobile': '+91 7778889999',
//       'email': 'david.w@example.com',
//       'address': '654 Birch Ln, Suburb, State 77889',
//       'description': 'Solo practice',
//     },
//   ];

//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       duration: const Duration(milliseconds: 800),
//       vsync: this,
//     );
//     _fadeAnimation = Tween<double>(
//       begin: 0.0,
//       end: 1.0,
//     ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
//     _slideAnimation = Tween<Offset>(
//       begin: const Offset(0, 0.3),
//       end: Offset.zero,
//     ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));
//     _controller.forward();
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Theme(
//       data: Theme.of(context).copyWith(
//         colorScheme: ColorScheme.fromSeed(
//           seedColor: AppColors.bluePrimaryDual,
//           primary: AppColors.bluePrimaryDual,
//           secondary: AppColors.iconLightColor,
//         ),
//         appBarTheme: const AppBarTheme(
//           backgroundColor: AppColors.bluePrimaryDual,
//           foregroundColor: Colors.white,
//           elevation: 0,
//           centerTitle: true,
//         ),
//       ),
//       child: Scaffold(
//         appBar: AppBar(
//           centerTitle: false,
//           title: const Text(
//             'Booking History',
//             style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
//           ),
//           actions: [
//             IconButton(
//               icon: const Icon(Icons.refresh, color: Colors.white),
//               onPressed: () {
//                 // Simulate refresh animation
//                 _controller.reset();
//                 _controller.forward();
//               },
//             ),
//           ],
//         ),
//         body: FadeTransition(
//           opacity: _fadeAnimation,
//           child: SlideTransition(
//             position: _slideAnimation,
//             child: CustomScrollView(
//               slivers: [
//                 SliverPadding(
//                   padding: const EdgeInsets.all(16.0),
//                   sliver: SliverToBoxAdapter(
//                     child: Text(
//                       'Your Recent Bookings',
//                       style: TextStyle(
//                         fontSize: 24,
//                         fontWeight: FontWeight.bold,
//                         color: AppColors.iconColor,
//                       ),
//                     ),
//                   ),
//                 ),
//                 SliverList(
//                   delegate: SliverChildBuilderDelegate((context, index) {
//                     final booking = _dummyBookings[index];
//                     final isPaid = booking['paid'] as bool;
//                     return Padding(
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 16.0,
//                         vertical: 8.0,
//                       ),
//                       child: Card(
//                         elevation: 6,
//                         shadowColor: Colors.black.withOpacity(0.1),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(16),
//                         ),
//                         child: ExpansionTile(
//                           leading: ClipRRect(
//                             borderRadius: BorderRadius.circular(12),
//                             child: Image.network(
//                               booking['imageUrl'] as String,
//                               width: 60,
//                               height: 60,
//                               fit: BoxFit.cover,
//                               errorBuilder: (context, error, stackTrace) =>
//                                   Container(
//                                     width: 60,
//                                     height: 60,
//                                     decoration: BoxDecoration(
//                                       color: AppColors.bluePrimaryDual
//                                           .withOpacity(0.1),
//                                       borderRadius: BorderRadius.circular(12),
//                                     ),
//                                     child: Icon(
//                                       Icons.sports_soccer,
//                                       color: AppColors.bluePrimaryDual,
//                                       size: 30,
//                                     ),
//                                   ),
//                             ),
//                           ),
//                           title: Text(
//                             '${booking['gameType']} at ${booking['turfName']}',
//                             style: TextStyle(
//                               fontSize: 18,
//                               fontWeight: FontWeight.w600,
//                               color: AppColors.iconColor,
//                             ),
//                           ),
//                           subtitle: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 booking['date'] as String,
//                                 style: TextStyle(
//                                   fontSize: 14,
//                                   color: AppColors.iconLightColor,
//                                 ),
//                               ),
//                               Text(
//                                 '${booking['timeSlot']} (${booking['hours']} hours)',
//                                 style: TextStyle(
//                                   fontSize: 14,
//                                   color: AppColors.iconLightColor,
//                                 ),
//                               ),
//                             ],
//                           ),
//                           trailing: Chip(
//                             label: Text(
//                               isPaid ? 'Paid' : 'Pending',
//                               style: TextStyle(
//                                 color: Colors.white,
//                                 fontWeight: FontWeight.w500,
//                               ),
//                             ),
//                             backgroundColor: isPaid
//                                 ? Colors.green
//                                 : Colors.orange,
//                           ),
//                           childrenPadding: const EdgeInsets.all(16.0),
//                           tilePadding: const EdgeInsets.symmetric(
//                             horizontal: 8.0,
//                           ),
//                           expandedCrossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             const Divider(color: Colors.grey, thickness: 1),
//                             _buildStatusSection(booking, isPaid),
//                             const SizedBox(height: 8),
//                             Align(
//                               alignment: Alignment.centerRight,
//                               child: ElevatedButton.icon(
//                                 onPressed: () {
//                                   Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                       builder: (context) => ReceiptScreen(
//                                         booking: booking,
//                                         isPaid: isPaid,
//                                       ),
//                                     ),
//                                   );
//                                 },
//                                 icon: const Icon(Icons.receipt, size: 18),
//                                 label: Text(
//                                   isPaid ? 'View Receipt' : 'Pay Now',
//                                 ),
//                                 style: ElevatedButton.styleFrom(
//                                   backgroundColor: AppColors.bluePrimaryDual,
//                                   foregroundColor: Colors.white,
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(8),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ],
//                           onExpansionChanged: (expanded) {
//                             if (expanded) {
//                               // Add subtle animation on expand
//                               setState(() {});
//                             }
//                           },
//                         ),
//                       ),
//                     );
//                   }, childCount: _dummyBookings.length),
//                 ),
//                 const SliverToBoxAdapter(child: SizedBox(height: 100)),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildStatusSection(Map<String, dynamic> booking, bool isPaid) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           children: [
//             Icon(
//               isPaid ? Icons.check_circle : Icons.pending,
//               color: isPaid ? Colors.green : Colors.orange,
//               size: 24,
//             ),
//             const SizedBox(width: 12),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     isPaid ? 'Payment Successful' : 'Payment Pending',
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.w600,
//                       color: AppColors.iconColor,
//                     ),
//                   ),
//                   Text(
//                     'Amount: ₹${booking['amount']}',
//                     style: TextStyle(
//                       fontSize: 14,
//                       fontWeight: FontWeight.bold,
//                       color: AppColors.bluePrimaryDual,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//         const SizedBox(height: 12),
//         Container(
//           padding: const EdgeInsets.all(12),
//           decoration: BoxDecoration(
//             color: isPaid
//                 ? Colors.green.withOpacity(0.05)
//                 : Colors.orange.withOpacity(0.05),
//             borderRadius: BorderRadius.circular(8),
//             border: Border.all(
//               color: isPaid
//                   ? Colors.green.withOpacity(0.2)
//                   : Colors.orange.withOpacity(0.2),
//             ),
//           ),
//           child: Row(
//             children: [
//               Expanded(
//                 child: Text(
//                   booking['description'] as String,
//                   style: TextStyle(
//                     fontSize: 14,
//                     color: AppColors.iconLightColor,
//                   ),
//                 ),
//               ),
//               Icon(
//                 Icons.info_outline,
//                 color: AppColors.iconLightColor,
//                 size: 20,
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }

// class ReceiptScreen extends StatefulWidget {
//   final Map<String, dynamic> booking;
//   final bool isPaid;

//   const ReceiptScreen({super.key, required this.booking, required this.isPaid});

//   @override
//   State<ReceiptScreen> createState() => _ReceiptScreenState();
// }

// class _ReceiptScreenState extends State<ReceiptScreen>
//     with TickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<double> _fadeAnimation;

//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       duration: const Duration(milliseconds: 600),
//       vsync: this,
//     );
//     _fadeAnimation = Tween<double>(
//       begin: 0.0,
//       end: 1.0,
//     ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
//     _controller.forward();
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final booking = widget.booking;
//     final isPaid = widget.isPaid;
//     final theme = Theme.of(context);

//     return Theme(
//       data: Theme.of(context).copyWith(
//         colorScheme: ColorScheme.fromSeed(
//           seedColor: AppColors.bluePrimaryDual,
//           primary: AppColors.bluePrimaryDual,
//           secondary: AppColors.iconLightColor,
//         ),
//         appBarTheme: const AppBarTheme(
//           backgroundColor: AppColors.bluePrimaryDual,
//           foregroundColor: Colors.white,
//           elevation: 0,
//           centerTitle: true,
//         ),
//       ),
//       child: Scaffold(
//         appBar: AppBar(
//           title: Text(
//             isPaid ? 'Receipt' : 'Payment Invoice',
//             style: const TextStyle(
//               fontWeight: FontWeight.bold,
//               color: Colors.white,
//             ),
//           ),
//           actions: [
//             IconButton(
//               icon: const Icon(Icons.print, color: Colors.white),
//               onPressed: () {
//                 // Simulate print
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(content: Text('Printing receipt...')),
//                 );
//               },
//             ),
//             IconButton(
//               icon: const Icon(Icons.share, color: Colors.white),
//               onPressed: () {
//                 // Simulate share
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(content: Text('Sharing receipt...')),
//                 );
//               },
//             ),
//           ],
//         ),
//         body: FadeTransition(
//           opacity: _fadeAnimation,
//           child: SingleChildScrollView(
//             padding: const EdgeInsets.all(16.0),
//             child: Card(
//               elevation: 8,
//               shadowColor: Colors.black.withOpacity(0.15),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(20),
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.all(24.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // Header
//                     Center(
//                       child: Column(
//                         children: [
//                           Container(
//                             padding: const EdgeInsets.all(16),
//                             decoration: BoxDecoration(
//                               color: AppColors.bluePrimaryDual,
//                               shape: BoxShape.circle,
//                             ),
//                             child: const Icon(
//                               Icons.receipt_long,
//                               color: Colors.white,
//                               size: 40,
//                             ),
//                           ),
//                           const SizedBox(height: 16),
//                           Text(
//                             'SportsPark',
//                             style: theme.textTheme.headlineSmall?.copyWith(
//                               fontWeight: FontWeight.bold,
//                               color: AppColors.bluePrimaryDual,
//                             ),
//                           ),
//                           Text(
//                             'Booking Receipt',
//                             style: theme.textTheme.titleMedium?.copyWith(
//                               fontWeight: FontWeight.w600,
//                               color: AppColors.iconColor,
//                             ),
//                           ),
//                           const SizedBox(height: 8),
//                           Text(
//                             'Receipt ID: #${booking['id'].toString().padLeft(4, '0')}',
//                             style: theme.textTheme.bodyMedium?.copyWith(
//                               color: AppColors.iconLightColor,
//                               fontStyle: FontStyle.italic,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     const SizedBox(height: 32),

//                     // Customer Details
//                     _buildSectionTitle('Customer Details'),
//                     const SizedBox(height: 16),
//                     _buildDetailRow('Name', booking['userName'] as String),
//                     _buildDetailRow(
//                       'Father\'s Name',
//                       booking['fatherName'] as String,
//                     ),
//                     _buildDetailRow('Mobile', booking['mobile'] as String),
//                     _buildDetailRow('Email', booking['email'] as String),
//                     _buildDetailRow('Address', booking['address'] as String),
//                     const SizedBox(height: 24),

//                     // Booking Details
//                     _buildSectionTitle('Booking Details'),
//                     const SizedBox(height: 16),
//                     _buildDetailRow('Game Type', booking['gameType'] as String),
//                     _buildDetailRow('Turf Name', booking['turfName'] as String),
//                     _buildDetailRow('Date', booking['date'] as String),
//                     _buildDetailRow('Time Slot', booking['timeSlot'] as String),
//                     _buildDetailRow('Duration', '${booking['hours']} hours'),
//                     _buildDetailRow(
//                       'Description',
//                       booking['description'] as String,
//                       isDescription: true,
//                     ),
//                     const SizedBox(height: 24),

//                     // Payment Details
//                     _buildSectionTitle('Payment Details'),
//                     const SizedBox(height: 16),
//                     Container(
//                       width: double.infinity,
//                       padding: const EdgeInsets.all(16),
//                       decoration: BoxDecoration(
//                         color: isPaid
//                             ? Colors.green.withOpacity(0.08)
//                             : Colors.orange.withOpacity(0.08),
//                         borderRadius: BorderRadius.circular(12),
//                         border: Border.all(
//                           color: isPaid ? Colors.green : Colors.orange,
//                           width: 1,
//                         ),
//                       ),
//                       child: Column(
//                         children: [
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               const Text(
//                                 'Amount Due',
//                                 style: TextStyle(
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.w500,
//                                   color: AppColors.iconLightColor,
//                                 ),
//                               ),
//                               Text(
//                                 '₹${booking['amount']}',
//                                 style: const TextStyle(
//                                   fontSize: 20,
//                                   fontWeight: FontWeight.bold,
//                                   color: AppColors.bluePrimaryDual,
//                                 ),
//                               ),
//                             ],
//                           ),
//                           const SizedBox(height: 8),
//                           Row(
//                             children: [
//                               Icon(
//                                 isPaid ? Icons.check_circle : Icons.pending,
//                                 color: isPaid ? Colors.green : Colors.orange,
//                                 size: 20,
//                               ),
//                               const SizedBox(width: 8),
//                               Text(
//                                 isPaid ? 'Paid' : 'Pending',
//                                 style: TextStyle(
//                                   fontSize: 14,
//                                   fontWeight: FontWeight.w600,
//                                   color: isPaid ? Colors.green : Colors.orange,
//                                 ),
//                               ),
//                             ],
//                           ),
//                           if (isPaid) ...[
//                             const SizedBox(height: 8),
//                             Text(
//                               'Payment Method: Razorpay',
//                               style: TextStyle(
//                                 fontSize: 12,
//                                 color: AppColors.iconLightColor,
//                                 fontStyle: FontStyle.italic,
//                               ),
//                             ),
//                           ],
//                         ],
//                       ),
//                     ),
//                     const SizedBox(height: 24),

//                     // Footer
//                     Container(
//                       padding: const EdgeInsets.all(16),
//                       decoration: BoxDecoration(
//                         color: AppColors.bluePrimaryDual.withOpacity(0.05),
//                         borderRadius: BorderRadius.circular(12),
//                         border: Border.all(
//                           color: AppColors.bluePrimaryDual.withOpacity(0.2),
//                         ),
//                       ),
//                       child: Column(
//                         children: [
//                           Text(
//                             'Thank you for choosing SportsPark!',
//                             style: theme.textTheme.titleMedium?.copyWith(
//                               fontWeight: FontWeight.w600,
//                               color: AppColors.bluePrimaryDual,
//                             ),
//                             textAlign: TextAlign.center,
//                           ),
//                           const SizedBox(height: 8),
//                           Text(
//                             'For support, contact us at support@sportspark.com',
//                             style: theme.textTheme.bodySmall?.copyWith(
//                               color: AppColors.iconLightColor,
//                             ),
//                             textAlign: TextAlign.center,
//                           ),
//                         ],
//                       ),
//                     ),
//                     const SizedBox(height: 16),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildSectionTitle(String title) {
//     return Text(
//       title,
//       style: TextStyle(
//         fontSize: 18,
//         fontWeight: FontWeight.bold,
//         color: AppColors.iconColor,
//       ),
//     );
//   }

//   Widget _buildDetailRow(
//     String label,
//     String value, {
//     bool isDescription = false,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 12.0),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           SizedBox(
//             width: 120,
//             child: Text(
//               '$label:',
//               style: TextStyle(
//                 fontSize: 14,
//                 fontWeight: FontWeight.w500,
//                 color: AppColors.iconLightColor,
//               ),
//             ),
//           ),
//           Expanded(
//             child: Text(
//               value,
//               style: TextStyle(fontSize: 14, color: AppColors.iconColor),
//               maxLines: isDescription ? 3 : 1,
//               overflow: isDescription
//                   ? TextOverflow.ellipsis
//                   : TextOverflow.visible,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:sportspark/utils/const/const.dart';
import 'package:intl/intl.dart';

class BookingHistoryScreen extends StatefulWidget {
  const BookingHistoryScreen({super.key});

  @override
  State<BookingHistoryScreen> createState() => _BookingHistoryScreenState();
}

class _BookingHistoryScreenState extends State<BookingHistoryScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late TabController _tabController;

  // Dummy data for bookings
  final List<Map<String, dynamic>> _dummyBookings = [
    {
      'id': 1,
      'userName': 'John Doe',
      'gameType': 'Football',
      'turfName': 'Green Turf Arena',
      'date': '2025-10-23', // Future
      'timeSlot': '10:00 - 11:00',
      'hours': 1,
      'amount': 500,
      'paid': true,
      'imageUrl':
          'https://images.unsplash.com/photo-1559526324-4b87b5e36fa5?w=100&h=100&fit=crop',
      'fatherName': 'Jane Doe',
      'mobile': '+91 9876543210',
      'email': 'john.doe@example.com',
      'address': '123 Main St, City, State 12345',
      'description': 'Casual football match with friends',
    },
    {
      'id': 2,
      'userName': 'Alice Smith',
      'gameType': 'Cricket',
      'turfName': 'City Cricket Ground',
      'date': '2025-10-22', // Current date
      'timeSlot': '23:00 - 00:00', // Ongoing (assuming 11:14 PM IST)
      'hours': 1,
      'amount': 1000,
      'paid': false,
      'imageUrl':
          'https://images.unsplash.com/photo-1579952363873-27d3bfad9c8f?w=100&h=100&fit=crop',
      'fatherName': 'Bob Smith',
      'mobile': '+91 1234567890',
      'email': 'alice.smith@example.com',
      'address': '456 Oak Ave, Town, State 67890',
      'description': 'Practice session for league match',
    },
    {
      'id': 3,
      'userName': 'Mike Johnson',
      'gameType': 'Badminton',
      'turfName': 'Elite Badminton Hall',
      'date': '2025-10-21', // Past
      'timeSlot': '07:00 - 09:00',
      'hours': 2,
      'amount': 800,
      'paid': true,
      'imageUrl':
          'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=100&h=100&fit=crop',
      'fatherName': 'Sarah Johnson',
      'mobile': '+91 5556667777',
      'email': 'mike.j@example.com',
      'address': '789 Pine Rd, Village, State 11223',
      'description': 'Doubles match tournament',
    },
    {
      'id': 4,
      'userName': 'Emily Davis',
      'gameType': 'Football',
      'turfName': 'Green Turf Arena',
      'date': '2025-10-24', // Future
      'timeSlot': '09:00 - 11:00',
      'hours': 2,
      'amount': 1000,
      'paid': true,
      'imageUrl':
          'https://images.unsplash.com/photo-1559526324-4b87b5e36fa5?w=100&h=100&fit=crop',
      'fatherName': 'Tom Davis',
      'mobile': '+91 4445556666',
      'email': 'emily.davis@example.com',
      'address': '321 Elm St, Metro, State 44556',
      'description': 'Team practice',
    },
    {
      'id': 5,
      'userName': 'David Wilson',
      'gameType': 'Tennis',
      'turfName': 'Royal Tennis Club',
      'date': '2025-10-20', // Past
      'timeSlot': '17:00 - 18:00',
      'hours': 1,
      'amount': 600,
      'paid': false,
      'imageUrl':
          'https://images.unsplash.com/photo-1612872087720-bb876e2e67d1?w=100&h=100&fit=crop',
      'fatherName': 'Lisa Wilson',
      'mobile': '+91 7778889999',
      'email': 'david.w@example.com',
      'address': '654 Birch Ln, Suburb, State 77889',
      'description': 'Solo practice',
    },
  ];

  // Helper to parse time slot and determine booking status
  String getBookingStatus(Map<String, dynamic> booking) {
    final now = DateTime.now(); // Current date and time
    final bookingDate = DateFormat('yyyy-MM-dd').parse(booking['date']);
    final timeSlot = booking['timeSlot'] as String;
    final timeParts = timeSlot.split(' - ');
    final startTimeStr = timeParts[0];
    final endTimeStr = timeParts[1];

    // Parse start and end times
    final startTime = DateFormat('HH:mm').parse(startTimeStr);
    final endTime = DateFormat('HH:mm').parse(endTimeStr);

    // Combine date with time
    final bookingStart = DateTime(
      bookingDate.year,
      bookingDate.month,
      bookingDate.day,
      startTime.hour,
      startTime.minute,
    );
    final bookingEnd = DateTime(
      bookingDate.year,
      bookingDate.month,
      bookingDate.day,
      endTime.hour,
      endTime.minute,
    );

    if (now.isBefore(bookingStart)) {
      return 'Upcoming';
    } else if (now.isAfter(bookingStart) && now.isBefore(bookingEnd)) {
      return 'Live';
    } else {
      return 'Completed';
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));
    _tabController = TabController(length: 3, vsync: this);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Filter bookings by status
    final upcomingBookings = _dummyBookings
        .where((b) => getBookingStatus(b) == 'Upcoming')
        .toList();
    final liveBookings = _dummyBookings
        .where((b) => getBookingStatus(b) == 'Live')
        .toList();
    final completedBookings = _dummyBookings
        .where((b) => getBookingStatus(b) == 'Completed')
        .toList();

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
        appBar: AppBar(
          centerTitle: false,
          title: const Text(
            'Booking History',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh, color: Colors.white),
              onPressed: () {
                // Simulate refresh animation
                _controller.reset();
                _controller.forward();
              },
            ),
          ],
          bottom: TabBar(
            controller: _tabController,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorColor: Colors.white,
            tabs: const [
              Tab(text: 'Upcoming'),
              Tab(text: 'Live'),
              Tab(text: 'Completed'),
            ],
          ),
        ),
        body: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildBookingList(upcomingBookings),
                _buildBookingList(liveBookings),
                _buildBookingList(completedBookings),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBookingList(List<Map<String, dynamic>> bookings) {
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.all(16.0),
          sliver: SliverToBoxAdapter(
            child: Text(
              'Your Recent Bookings',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.iconColor,
              ),
            ),
          ),
        ),
        bookings.isEmpty
            ? SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'No bookings found.',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.iconLightColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            : SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final booking = bookings[index];
                  final isPaid = booking['paid'] as bool;
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
                    child: Card(
                      elevation: 6,
                      shadowColor: Colors.black.withOpacity(0.1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: ExpansionTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            booking['imageUrl'] as String,
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    color: AppColors.bluePrimaryDual
                                        .withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(
                                    Icons.sports_soccer,
                                    color: AppColors.bluePrimaryDual,
                                    size: 30,
                                  ),
                                ),
                          ),
                        ),
                        title: Text(
                          '${booking['gameType']} at ${booking['turfName']}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AppColors.iconColor,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              booking['date'] as String,
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.iconLightColor,
                              ),
                            ),
                            Text(
                              '${booking['timeSlot']} (${booking['hours']} hours)',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.iconLightColor,
                              ),
                            ),
                          ],
                        ),
                        trailing: Chip(
                          label: Text(
                            isPaid ? 'Paid' : 'Pending',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          backgroundColor: isPaid
                              ? Colors.green
                              : Colors.orange,
                        ),
                        childrenPadding: const EdgeInsets.all(16.0),
                        tilePadding: const EdgeInsets.symmetric(
                          horizontal: 8.0,
                        ),
                        expandedCrossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Divider(color: Colors.grey, thickness: 1),
                          _buildStatusSection(booking, isPaid),
                          const SizedBox(height: 8),
                          Align(
                            alignment: Alignment.centerRight,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ReceiptScreen(
                                      booking: booking,
                                      isPaid: isPaid,
                                    ),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.receipt, size: 18),
                              label: Text(isPaid ? 'View Receipt' : 'Pay Now'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.bluePrimaryDual,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),
                        ],
                        onExpansionChanged: (expanded) {
                          if (expanded) {
                            setState(() {});
                          }
                        },
                      ),
                    ),
                  );
                }, childCount: bookings.length),
              ),
        const SliverToBoxAdapter(child: SizedBox(height: 100)),
      ],
    );
  }

  Widget _buildStatusSection(Map<String, dynamic> booking, bool isPaid) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              isPaid ? Icons.check_circle : Icons.pending,
              color: isPaid ? Colors.green : Colors.orange,
              size: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isPaid ? 'Payment Successful' : 'Payment Pending',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.iconColor,
                    ),
                  ),
                  Text(
                    'Amount: ₹${booking['amount']}',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.bluePrimaryDual,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isPaid
                ? Colors.green.withOpacity(0.05)
                : Colors.orange.withOpacity(0.05),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isPaid
                  ? Colors.green.withOpacity(0.2)
                  : Colors.orange.withOpacity(0.2),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  booking['description'] as String,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.iconLightColor,
                  ),
                ),
              ),
              Icon(
                Icons.info_outline,
                color: AppColors.iconLightColor,
                size: 20,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class ReceiptScreen extends StatefulWidget {
  final Map<String, dynamic> booking;
  final bool isPaid;

  const ReceiptScreen({super.key, required this.booking, required this.isPaid});

  @override
  State<ReceiptScreen> createState() => _ReceiptScreenState();
}

class _ReceiptScreenState extends State<ReceiptScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final booking = widget.booking;
    final isPaid = widget.isPaid;
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
        appBar: AppBar(
          title: Text(
            isPaid ? 'Receipt' : 'Payment Invoice',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.print, color: Colors.white),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Printing receipt...')),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.share, color: Colors.white),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Sharing receipt...')),
                );
              },
            ),
          ],
        ),
        body: FadeTransition(
          opacity: _fadeAnimation,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 8,
              shadowColor: Colors.black.withOpacity(0.15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppColors.bluePrimaryDual,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.receipt_long,
                              color: Colors.white,
                              size: 40,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'SportsPark',
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.bluePrimaryDual,
                            ),
                          ),
                          Text(
                            'Booking Receipt',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppColors.iconColor,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Receipt ID: #${booking['id'].toString().padLeft(4, '0')}',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: AppColors.iconLightColor,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    _buildSectionTitle('Customer Details'),
                    const SizedBox(height: 16),
                    _buildDetailRow('Name', booking['userName'] as String),
                    _buildDetailRow(
                      'Father\'s Name',
                      booking['fatherName'] as String,
                    ),
                    _buildDetailRow('Mobile', booking['mobile'] as String),
                    _buildDetailRow('Email', booking['email'] as String),
                    _buildDetailRow('Address', booking['address'] as String),
                    const SizedBox(height: 24),
                    _buildSectionTitle('Booking Details'),
                    const SizedBox(height: 16),
                    _buildDetailRow('Game Type', booking['gameType'] as String),
                    _buildDetailRow('Turf Name', booking['turfName'] as String),
                    _buildDetailRow('Date', booking['date'] as String),
                    _buildDetailRow('Time Slot', booking['timeSlot'] as String),
                    _buildDetailRow('Duration', '${booking['hours']} hours'),
                    _buildDetailRow(
                      'Description',
                      booking['description'] as String,
                      isDescription: true,
                    ),
                    const SizedBox(height: 24),
                    _buildSectionTitle('Payment Details'),
                    const SizedBox(height: 16),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isPaid
                            ? Colors.green.withOpacity(0.08)
                            : Colors.orange.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isPaid ? Colors.green : Colors.orange,
                          width: 1,
                        ),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Amount Due',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.iconLightColor,
                                ),
                              ),
                              Text(
                                '₹${booking['amount']}',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.bluePrimaryDual,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(
                                isPaid ? Icons.check_circle : Icons.pending,
                                color: isPaid ? Colors.green : Colors.orange,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                isPaid ? 'Paid' : 'Pending',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: isPaid ? Colors.green : Colors.orange,
                                ),
                              ),
                            ],
                          ),
                          if (isPaid) ...[
                            const SizedBox(height: 8),
                            Text(
                              'Payment Method: Razorpay',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.iconLightColor,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.bluePrimaryDual.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.bluePrimaryDual.withOpacity(0.2),
                        ),
                      ),
                      child: Column(
                        children: [
                          Text(
                            'Thank you for choosing SportsPark!',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppColors.bluePrimaryDual,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'For support, contact us at support@sportspark.com',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: AppColors.iconLightColor,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: AppColors.iconColor,
      ),
    );
  }

  Widget _buildDetailRow(
    String label,
    String value, {
    bool isDescription = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.iconLightColor,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 14, color: AppColors.iconColor),
              maxLines: isDescription ? 3 : 1,
              overflow: isDescription
                  ? TextOverflow.ellipsis
                  : TextOverflow.visible,
            ),
          ),
        ],
      ),
    );
  }
}
