import 'dart:developer';
import 'package:sportspark/utils/dio/dio.dart';

class SportsService {
  final NetworkUtils _networkUtils = NetworkUtils();

  Future<List<Map<String, dynamic>>?> fetchSportsList() async {
    try {
      final response = await _networkUtils.request<Map<String, dynamic>>(
        endpoint: '/sports/list',
        method: HttpMethod.get,
      );

      if (response?.statusCode == 200) {
        final data = response?.data?['sports'] as List<dynamic>?;
        if (data != null) {
          log('✅ Fetched ${data} ');
          log('✅ Fetched ${data.length} sports');
          return List<Map<String, dynamic>>.from(data);
        }
      }
      log('❌ Failed to fetch sports: ${response?.statusMessage}');
      return null;
    } catch (e) {
      log('💥 Error fetching sports: $e');
      return null;
    }
  }
}
