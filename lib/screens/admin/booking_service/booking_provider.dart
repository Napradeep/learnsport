// import 'dart:developer';

// import 'package:flutter/foundation.dart';
// import 'package:sportspark/utils/dio/dio.dart';

// class BookingProvider with ChangeNotifier {
//   final NetworkUtils _networkUtils = NetworkUtils();

//   bool _isLoading = false;
//   bool get isLoading => _isLoading;

//   List<Map<String, dynamic>> _availableSlots = [];
//   List<Map<String, dynamic>> get availableSlots => _availableSlots;

//   /// Fetch available slots – supports DAY or MONTH mode
//   Future<void> fetchAvailableSlots({
//     required String sportsId,
//     String? date, // e.g. "2025-12-01"
//     String? typeMonth, // e.g. "DEC"
//     int? typeYear, // e.g. 2025
//   }) async {
//     _isLoading = true;
//     notifyListeners();

//     try {
//       final Map<String, dynamic> params = {'sports_id': sportsId};

//       if (date != null) {
//         params['date'] = date;
//       } else if (typeMonth != null && typeYear != null) {
//         params['slot_type'] = 'MONTH';
//         params['type_month'] = typeMonth;
//         params['type_year'] = typeYear;
//       }

//       final response = await _networkUtils.request(
//         endpoint: '/booking/available-slots',
//         method: HttpMethod.get,
//         params: params,
//       );

//       if (response?.statusCode == 200 && response?.data != null) {
//         final rawSlots = response!.data['slots'] ?? [];
//         log(rawSlots.toString());
//         _availableSlots = List<Map<String, dynamic>>.from(rawSlots);
//       } else {
//         _availableSlots = [];
//       }
//     } catch (e, st) {
//       if (kDebugMode) {
//         print("Fetch slots error: $e");
//         print(st);
//       }
//       _availableSlots = [];
//     } finally {
//       _isLoading = false;
//       notifyListeners();
//     }
//   }

//   /// Book slots – supports DAY or MONTH payload
//   Future<bool> bookSlots({
//     required String sportsId,
//     required String slotType,
//     String? bookingDate,
//     String? typeMonth,
//     int? typeYear,
//     required List<Map<String, String>> times,
//     required String playersCount, // 👈 Added
//   }) async {
//     try {
//       final Map<String, dynamic> bookingPayload = {
//         "slot_type": slotType,
//         "no_of_players": int.tryParse(playersCount) ?? 0,
//         "times": times,
//       };

//       if (slotType == "DAY" && bookingDate != null) {
//         bookingPayload["booking_date"] = bookingDate;
//       } else if (slotType == "MONTH") {
//         if (typeMonth != null) bookingPayload["type_month"] = typeMonth;
//         if (typeYear != null) bookingPayload["type_year"] = typeYear;
//       }

//       final Map<String, dynamic> payload = {
//         "sports_id": sportsId,
//         "bookings": [bookingPayload],
//       };

//       final response = await _networkUtils.request(
//         endpoint: '/booking/slot',
//         method: HttpMethod.post,
//         data: payload,
//       );

//       return response != null &&
//           (response.statusCode == 200 || response.statusCode == 201);
//     } catch (e, st) {
//       if (kDebugMode) {
//         print("Booking error: $e");
//         print(st);
//       }
//       return false;
//     }
//   }
// }

// import 'dart:developer';
// import 'package:flutter/foundation.dart';
// import 'package:sportspark/utils/dio/dio.dart';

// ///----------------🎯 SLOT MODEL----------------///
// class SportSlotModel {
//   final String date;
//   final String startTime;
//   final String endTime;
//   final String status;

//   SportSlotModel({
//     required this.date,
//     required this.startTime,
//     required this.endTime,
//     required this.status,
//   });

//   factory SportSlotModel.fromJson(Map<String, dynamic> json) {
//     return SportSlotModel(
//       date: json["date"] ?? "",
//       startTime: json["start_time"] ?? "",
//       endTime: json["end_time"] ?? "",
//       status: json["status"] ?? "AVAILABLE",
//     );
//   }
// }

// ///----------------🎯 PROVIDER----------------///
// class BookingProvider with ChangeNotifier {
//   final NetworkUtils _networkUtils = NetworkUtils();

//   bool _isLoading = false;
//   bool get isLoading => _isLoading;

//   List<SportSlotModel> _availableSlots = [];
//   List<SportSlotModel> get availableSlots => _availableSlots;

//   /// Fetch Available Slots
//   Future<void> fetchAvailableSlots({
//     required String sportsId,
//     String? date,
//     String? typeMonth,
//     int? typeYear,
//   }) async {
//     _isLoading = true;
//     notifyListeners();

//     try {
//       final params = {
//         'sports_id': sportsId,
//       };

//       if (date != null) {
//         params['date'] = date;
//       } else {
//         params['slot_type'] = 'MONTH';
//         params['type_month'] = typeMonth.toString();
//         params['type_year'] = typeYear.toString();
//       }

//       final response = await _networkUtils.request(
//         endpoint: '/booking/available-slots',
//         method: HttpMethod.get,
//         params: params,
//       );

//       if (response?.statusCode == 200 && response?.data != null) {
//         final list = response!.data['slots'] ?? response.data;
//         _availableSlots = List.from(list)
//             .map((e) => SportSlotModel.fromJson(e))
//             .toList();
//       } else {
//         _availableSlots = [];
//       }
//     } catch (e) {
//       if (kDebugMode) log("Fetch Slots Error => $e");
//       _availableSlots = [];
//     }

//     _isLoading = false;
//     notifyListeners();
//   }

//   /// Book Slots (Day/Month)
//   Future<bool> bookSlots({
//     required String sportsId,
//     required String slotType,
//     String? bookingDate,
//     String? typeMonth,
//     int? typeYear,
//     required List<Map<String, String>> times,
//     required String playersCount,
//   }) async {
//     try {
//       final bookingPayload = {
//         "slot_type": slotType,
//         "no_of_players": int.tryParse(playersCount) ?? 1,
//         "times": times,
//       };

//       if (slotType == "DAY") {
//         bookingPayload["booking_date"] = bookingDate.toString();
//       } else {
//         bookingPayload["type_month"] = typeMonth.toString();
//         bookingPayload["type_year"] = typeYear.toString();
//       }

//       final payload = {
//         "sports_id": sportsId,
//         "bookings": [bookingPayload],
//       };

//       final response = await _networkUtils.request(
//         endpoint: '/booking/slot',
//         method: HttpMethod.post,
//         data: payload,
//       );

//       return response != null &&
//           (response.statusCode == 200 || response.statusCode == 201);
//     } catch (e) {
//       if (kDebugMode) log("Booking Error => $e");
//       return false;
//     }
//   }
// }
import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:sportspark/utils/dio/dio.dart';

///----------------🎯 SLOT MODEL----------------///
class SportSlotModel {
  final String date;
  final String startTime;
  final String endTime;
  final String status;

  SportSlotModel({
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.status,
  });

  factory SportSlotModel.fromJson(Map<String, dynamic> json) {
    return SportSlotModel(
      date: json["date"] ?? "",
      startTime: json["start_time"] ?? "",
      endTime: json["end_time"] ?? "",
      status: json["status"] ?? "AVAILABLE",
    );
  }
}

///----------------🎯 PROVIDER----------------///
class BookingProvider with ChangeNotifier {
  final NetworkUtils _networkUtils = NetworkUtils();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<SportSlotModel> _availableSlots = [];
  List<SportSlotModel> get availableSlots => _availableSlots;

  /// Clear Slots (UI Switching or Reset)
  void clearSlots() {
    _availableSlots = [];
    notifyListeners();
  }

  /// Fetch Available Slots (Day/Month)
  Future<void> fetchAvailableSlots({
    required String sportsId,
    String? date,
    String? typeMonth,
    int? typeYear,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      Map<String, dynamic> params = {
        'sports_id': sportsId,
      };

      /// DAY logic
      if (date != null) {
        params['date'] = date;
      } 
      /// MONTH logic
      else if (typeMonth != null && typeYear != null) {
        params['slot_type'] = 'MONTH';
        params['type_month'] = typeMonth;
        params['type_year'] = typeYear;
      }

      final response = await _networkUtils.request(
        endpoint: '/booking/available-slots',
        method: HttpMethod.get,
        params: params,
      );

      if (response?.statusCode == 200 && response?.data != null) {
        final data = response!.data['slots'] ?? [];
        _availableSlots =
            List.from(data).map((e) => SportSlotModel.fromJson(e)).toList();
      } else {
        _availableSlots = [];
      }
    } catch (e) {
      if (kDebugMode) log("Fetch Slot Error: $e");
      _availableSlots = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  ///---------------📌 BOOK SLOT----------------///
  Future<bool> bookSlots({
    required String sportsId,
    required String slotType,
    String? bookingDate,
    String? typeMonth,
    int? typeYear,
    required List<Map<String, String>> times,
    required String playersCount,
  }) async {
    try {
      Map<String, dynamic> bookingPayload = {
        "slot_type": slotType,
        "no_of_players": int.tryParse(playersCount) ?? 1,
        "times": times,
      };

      /// DAY PAYLOAD
      if (slotType == "DAY") {
        bookingPayload["booking_date"] = bookingDate;
      } 
      /// MONTH PAYLOAD
      else {
        bookingPayload["type_month"] = typeMonth;
        bookingPayload["type_year"] = typeYear;
      }

      final payload = {
        "sports_id": sportsId,
        "bookings": [bookingPayload],
      };

      final response = await _networkUtils.request(
        endpoint: '/booking/slot',
        method: HttpMethod.post,
        data: payload,
      );

      return response != null &&
          (response.statusCode == 200 || response.statusCode == 201);
    } catch (e) {
      if (kDebugMode) log("Booking Error => $e");
      return false;
    }
  }
}
