import 'package:flutter/foundation.dart';
import 'package:sportspark/utils/dio/dio.dart';

class BookingProvider with ChangeNotifier {
  final NetworkUtils _networkUtils = NetworkUtils();
  bool isLoading = false;
  List<Map<String, dynamic>> availableSlots = [];

  /// ✅ Fetch available slots (using correct endpoint)
  Future<void> fetchAvailableSlots(String sportsId) async {
    isLoading = true;
    notifyListeners();

    try {
      final response = await _networkUtils.request(
        endpoint: '/booking/available-slots',
        method: HttpMethod.get,
        params: {'sports_id': sportsId},
      );

      if (response != null &&
          response.statusCode == 200 &&
          response.data != null &&
          response.data['slots'] != null) {
        availableSlots = List<Map<String, dynamic>>.from(
          response.data['slots'],
        );
      } else {
        availableSlots = [];
      }
    } catch (e, st) {
      if (kDebugMode) {
        print("Fetch slots error: $e");
        print(st);
      }
      availableSlots = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// ✅ Book slots
  Future<bool> bookSlots(
    String sportsId,
    List<Map<String, dynamic>> bookings,
  ) async {
    try {
      final response = await _networkUtils.request(
        endpoint: '/booking/slot',
        method: HttpMethod.post,
        data: {"sports_id": sportsId, "bookings": bookings},
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
