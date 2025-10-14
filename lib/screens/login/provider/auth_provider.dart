import 'package:flutter/material.dart';
import 'package:sportspark/screens/login/model/login_request.dart';
import 'package:sportspark/screens/login/model/register_request.dart';
import 'package:sportspark/screens/login/model/user_model.dart';
import 'package:sportspark/utils/dio/dio.dart';
import 'package:sportspark/utils/shared/shared_pref.dart';

class AuthProvider with ChangeNotifier {
  UserModel? _user;
  UserModel? get user => _user;

  /// LOGIN
  Future<bool> login(LoginRequest request, String role) async {
    String endpoint;
    switch (role) {
      case 'admin':
        endpoint = '/admin/login';
        break;
      case 'superadmin':
        endpoint = '/super-admin/login';
        break;
      default:
        endpoint = '/user/login';
    }

    final network = NetworkUtils();
    try {
      final response = await network.request(
        endpoint: endpoint,
        method: HttpMethod.post,
        data: request.toJson(),
      );

      if (response != null &&
          (response.statusCode == 200 || response.statusCode == 201)) {
        final user = UserModel.fromJson(response.data);
        await UserPreferences.saveUser(user);
        _user = user;
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('❌ Login error: $e');
      return false;
    }
  }

  /// REGISTER
  Future<bool> register(RegisterRequest request, String role) async {
    String endpoint;
    switch (role) {
      case 'admin':
        endpoint = '/admin/register';
        break;
      case 'superadmin':
        endpoint = '/super-admin/register';
        break;
      default:
        endpoint = '/user/register';
    }

    final network = NetworkUtils();
    try {
      final response = await network.request(
        endpoint: endpoint,
        method: HttpMethod.post,
        data: request.toJson(),
      );

      if (response != null &&
          (response.statusCode == 200 || response.statusCode == 201)) {
        debugPrint('✅ Registration successful: ${response.data}');

        // Only parse user if backend returned a Map (JSON), otherwise skip saving
        if (response.data is Map<String, dynamic>) {
          final user = UserModel.fromJson(response.data);
          await UserPreferences.saveUser(user);
          _user = user;
          notifyListeners();
        }

        return true;
      } else {
        debugPrint('❌ Registration failed: ${response?.statusCode}');
        return false;
      }
    } catch (e) {
      debugPrint('❌ Register error: $e');
      return false;
    }
  }

  /// LOGOUT
  Future<void> logout(BuildContext context) async {
    await UserPreferences.logout(context);
    _user = null;
    notifyListeners();
  }
}
