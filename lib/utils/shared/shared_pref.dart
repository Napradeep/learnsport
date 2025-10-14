// utils/user_preferences.dart
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sportspark/screens/login/model/user_model.dart';
import 'package:sportspark/screens/login/view/ogin_screen.dart';
import 'package:sportspark/utils/router/router.dart';

class UserPreferences {
  static const String _userKey = 'user_data';
  static const String _tokenKey = 'token';
  static const String _usernameKey = 'username';
  static const String _emailKey = 'email';
  static const String _profilePicKey = 'profile_pic';
  static const String _isLoggedInKey = 'isLoggedIn';
  static const String _userIdKey = 'user_id';
  static const String _roleKey = 'role';

  /// Save user data in SharedPreferences
  static Future<void> saveUser(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = jsonEncode(user.toJson());

    await prefs.setString(_userKey, userJson);
    await prefs.setString(_tokenKey, user.token);
    await prefs.setString(_usernameKey, user.fullName);
    await prefs.setString(_emailKey, user.email);
    await prefs.setString(_profilePicKey, user.profilePicUrl);
    await prefs.setString(_userIdKey, user.userId);
    await prefs.setString(_roleKey, user.role);
    await prefs.setBool(_isLoggedInKey, true);
  }

  /// Get token
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  /// Get user model
  static Future<UserModel?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(_userKey);
    if (userJson != null) {
      try {
        return UserModel.fromJson(jsonDecode(userJson));
      } catch (e) {
        log('Error decoding user data: $e');
      }
    }
    return null;
  }

  /// Get user ID
  static Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userIdKey);
  }

  /// Get role
  static Future<String?> getRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_roleKey);
  }

  /// Clear all user data
  static Future<void> clearUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
    await prefs.remove(_tokenKey);
    await prefs.remove(_usernameKey);
    await prefs.remove(_emailKey);
    await prefs.remove(_profilePicKey);
    await prefs.remove(_userIdKey);
    await prefs.remove(_roleKey);
    await prefs.remove(_isLoggedInKey);
    log("User logged out and data cleared.");
  }

  /// Logout and navigate to login
  static Future<void> logout(BuildContext context) async {
    await clearUser();
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    MyRouter.pushRemoveUntil(screen: LoginScreen());
  }
}
