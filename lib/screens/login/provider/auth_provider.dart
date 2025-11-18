import 'package:flutter/material.dart';
import 'package:sportspark/screens/home_screen.dart';
import 'package:sportspark/screens/login/model/login_request.dart';
import 'package:sportspark/screens/login/model/register_request.dart';
import 'package:sportspark/screens/login/model/user_model.dart';
import 'package:sportspark/utils/dio/dio.dart';
import 'package:sportspark/utils/shared/shared_pref.dart';
import 'package:sportspark/utils/snackbar/snackbar.dart';

class AuthProvider with ChangeNotifier {
  UserModel? _user;
  UserModel? get user => _user;

  final NetworkUtils network = NetworkUtils();

  /// LOGIN
  Future<bool> login(LoginRequest request) async {
    const String endpoint = '/user/login';

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
        Messenger.alertSuccess("Login successful!");
        return true;
      } else {
        // final message = response?.data?['message'] ?? "Invalid credentials";
        // Messenger.alertError(message);
        return false;
      }
    } catch (e) {
      debugPrint('❌ Login error: $e');
      // Messenger.alertError("Login failed. Please try again.");
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

    try {
      final response = await network.request(
        endpoint: endpoint,
        method: HttpMethod.post,
        data: request.toJson(),
      );

      if (response != null &&
          (response.statusCode == 200 || response.statusCode == 201)) {
        if (response.data is Map<String, dynamic>) {
          final user = UserModel.fromJson(response.data);
          await UserPreferences.saveUser(user);
          _user = user;
          notifyListeners();
        }
        Messenger.alertSuccess("Registration successful!");
        return true;
      } else {
        // final message = response?.data?['message'] ?? "Registration failed";
        // Messenger.alertError(message);
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

    Messenger.alertSuccess("Logged out successfully.");

    if (context.mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => HomeScreen()),
        (route) => false,
      );
    }
  }

  /// FORGOT PASSWORD
  Future<bool> forgotPassword(String email) async {
    try {
      final response = await network.request(
        endpoint: '/user/forgot-password',
        method: HttpMethod.post,
        data: {"email": email},
      );

      if (response != null && response.statusCode == 200) {
        Messenger.alertSuccess(
          response.data['message'] ?? "Password reset email sent.",
        );
        return true;
      } else {
        final message = response?.data?['message'] ?? "Failed to send email.";
        Messenger.alertError(message);
        return false;
      }
    } catch (e) {
      debugPrint('❌ Forgot Password error: $e');
      // Messenger.alertError("Failed to send reset link. Try again later.");
      return false;
    }
  }

  /// UPDATE PASSWORD
  Future<bool> updatePassword(String oldPassword, String newPassword) async {
    try {
      final response = await network.request(
        endpoint: '/user/update-password',
        method: HttpMethod.post,
        data: {"oldPassword": oldPassword, "newPassword": newPassword},
      );

      if (response != null && response.statusCode == 200) {
        Messenger.alertSuccess(
          response.data['message'] ?? "Password updated successfully.",
        );
        return true;
      } else {
        final message = response?.data?['message'] ?? "Password update failed.";
        Messenger.alertError(message);
        return false;
      }
    } catch (e) {
      debugPrint('❌ Update Password error: $e');
      // Messenger.alertError("Password update failed. Try again later.");
      return false;
    }
  }

  /// RESET PASSWORD
  Future<bool> resetPassword(String token, String newPassword) async {
    try {
      final response = await network.request(
        endpoint: '/user/reset-password',
        method: HttpMethod.post,
        data: {"token": token, "newPassword": newPassword},
      );

      if (response != null && response.statusCode == 200) {
        Messenger.alertSuccess(
          response.data['message'] ?? "Password reset successfully.",
        );
        return true;
      } else {
        final message = response?.data?['message'] ?? "Password reset failed.";
        Messenger.alertError(message);
        return false;
      }
    } catch (e) {
      debugPrint('❌ Reset Password error: $e');
      //  Messenger.alertError("Password reset failed. Try again later.");
      return false;
    }
  }
}
