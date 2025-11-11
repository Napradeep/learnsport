import 'dart:developer';
import 'package:sportspark/utils/dio/dio.dart';
import 'package:sportspark/utils/snackbar/snackbar.dart';

class UserAdminService {
  final NetworkUtils _networkUtils = NetworkUtils();

  Future<Map<String, dynamic>> fetchUsersList({
    int page = 1,
    int limit = 10,
    String? search,
  }) async {
    final params = {
      'page': page,
      'limit': limit,
      if (search != null && search.isNotEmpty) 'search': search,
    };

    try {
      final response = await _networkUtils.request(
        endpoint: '/user/users-list',
        method: HttpMethod.get,
        params: params,
      );

      if (response != null && response.statusCode == 200) {
        log(response.data.toString());
        return {
          'data': response.data['users'] ?? [],
          'pagination': response.data['pagination'] ?? {},
        };
      } else {
        final message = response?.data?['message'] ?? "Unable to fetch users";
        Messenger.alertError(message);
        return {'data': [], 'pagination': {}};
      }
    } catch (e) {
      Messenger.alertError(e.toString());
      return {'data': [], 'pagination': {}};
    }
  }

  Future<Map<String, dynamic>> fetchAdminList({
    int page = 1,
    int limit = 20,
    String? search,
  }) async {
    final params = {
      'page': page,
      'limit': limit,
      if (search != null && search.isNotEmpty) 'search': search,
    };

    try {
      final response = await _networkUtils.request(
        endpoint: '/admin/admin-list',
        method: HttpMethod.get,
        params: params,
      );

      if (response != null && response.statusCode == 200) {
        log(response.data.toString());
        return {
          'data': response.data['admins'] ?? [],
          'pagination': response.data['pagination'] ?? {},
        };
      } else {
        final message = response?.data?['message'] ?? "Unable to fetch admins";
        Messenger.alertError(message);
        return {'data': [], 'pagination': {}};
      }
    } catch (e) {
      Messenger.alertError(e.toString());
      return {'data': [], 'pagination': {}};
    }
  }
}
