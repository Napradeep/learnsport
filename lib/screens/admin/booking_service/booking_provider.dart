
import 'package:flutter/foundation.dart';
import 'package:sportspark/utils/dio/dio.dart';

class BookingProvider with ChangeNotifier {
  final NetworkUtils _networkUtils = NetworkUtils();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<Map<String, dynamic>> _availableSlots = [];
  List<Map<String, dynamic>> get availableSlots => _availableSlots;

  /// Fetch available slots – supports DAY or MONTH mode
  Future<void> fetchAvailableSlots({
    required String sportsId,
    String? date,           // e.g. "2025-12-01"
    String? typeMonth,      // e.g. "DEC"
    int? typeYear,          // e.g. 2025
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final Map<String, dynamic> params = {'sports_id': sportsId};

      if (date != null) {
        params['date'] = date;
      } else if (typeMonth != null && typeYear != null) {
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
        final rawSlots = response!.data['slots'] ?? [];
        _availableSlots = List<Map<String, dynamic>>.from(rawSlots);
      } else {
        _availableSlots = [];
      }
    } catch (e, st) {
      if (kDebugMode) {
        print("Fetch slots error: $e");
        print(st);
      }
      _availableSlots = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Book slots – supports DAY or MONTH payload
  Future<bool> bookSlots({
    required String sportsId,
    required String slotType,           // "DAY" or "MONTH"
    String? bookingDate,                // used in DAY mode
    String? typeMonth,                  // used in MONTH mode
    int? typeYear,                      // used in MONTH mode
    required List<Map<String, String>> times, // [{start_time, end_time}]
  }) async {
    try {
      final Map<String, dynamic> payload = {
        "sports_id": sportsId,
        "slot_type": slotType,
        "times": times,
      };

      if (slotType == "DAY" && bookingDate != null) {
        payload["booking_date"] = bookingDate;
      } else if (slotType == "MONTH") {
        if (typeMonth != null) payload["type_month"] = typeMonth;
        if (typeYear != null) payload["type_year"] = typeYear;
      }

      final response = await _networkUtils.request(
        endpoint: '/booking/slot',
        method: HttpMethod.post,
        data: payload,
      );

      return response != null &&
          (response.statusCode == 200 || response.statusCode == 201);
    } catch (e, st) {
      if (kDebugMode) {
        print("Booking error: $e");
        print(st);
      }
      return false;
    }
  }
}