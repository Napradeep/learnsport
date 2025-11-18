import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:sportspark/utils/dio/dio.dart';
import 'package:sportspark/utils/snackbar/snackbar.dart';

class AddSportsProvider with ChangeNotifier {
  final NetworkUtils _networkUtils = NetworkUtils();

  List<Map<String, dynamic>> _sports = [];
  bool _isLoading = false;

  List<Map<String, dynamic>> get sports => _sports;
  bool get isLoading => _isLoading;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  // Fetch sports with optional refresh control
  Future<void> fetchSports({bool forceRefresh = false}) async {
    if (!forceRefresh && _sports.isNotEmpty) return;

    _isLoading = true;
    notifyListeners();

    try {
      final res = await _networkUtils.request(
        endpoint: '/sports/list',
        method: HttpMethod.get,
      );

      if (res?.statusCode == 200) {
        final json = res?.data as Map<String, dynamic>;
        if (json['message'] == 'Sports grounds fetched successfully') {
          _sports = List<Map<String, dynamic>>.from(json['sports']);
          log(sports.toString());
        } else {
          _sports = [];
        }
      } else {
        _sports = [];
        Messenger.alertError('Failed to load sports');
      }
    } catch (e) {
      _sports = [];
      Messenger.alertError('Network error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Add Sport – Instant UI + Fallback
  Future<bool> addSport({
    required String name,
    required String about,
    required String actualPrice,
    required String finalPrice,
    required String groundName,
    required String lightingHalf,
    required String lightingFull,
    required String status,
    File? image,
    File? banner,
    File? webBanner,
  }) async {
    try {
      final form = FormData.fromMap({
        'name': name,
        'about': about,
        'actual_price_per_slot': actualPrice,
        'final_price_per_slot': finalPrice,
        'ground_name': groundName,
        'sport_lighting_price_half': lightingHalf,
        'sport_lighting_price_full': lightingFull,
        'status': status,
        if (image != null)
          'image': await MultipartFile.fromFile(
            image.path,
            filename: 'sport_image.jpg',
          ),
        if (banner != null)
          'banner': await MultipartFile.fromFile(
            banner.path,
            filename: 'sport_banner.jpg',
          ),
        if (webBanner != null)
          'web_banner': await MultipartFile.fromFile(
            webBanner.path,
            filename: 'sport_banner.jpg',
          ),
      });

      final res = await _networkUtils.request(
        endpoint: '/sports/add',
        method: HttpMethod.post,
        data: form,
      );

      if (res?.statusCode == 200 || res?.statusCode == 201) {
        final data = res?.data as Map<String, dynamic>?;
        final newSport = data?['sport'] as Map<String, dynamic>?;

        if (newSport != null) {
          // Insert at top for instant visibility
          _sports.insert(0, newSport);
          notifyListeners();
        } else {
          await fetchSports(forceRefresh: true);
        }

        Messenger.alert(msg: 'Sport added successfully');
        return true;
      } else {
        Messenger.alertError(res?.data['message'] ?? 'Failed to add sport');
        return false;
      }
    } catch (e) {
      Messenger.alertError('Add failed: $e');
      return false;
    }
  }

  Future<bool> updateUserStatus({
    required String id,
    required String status,
  }) async {
    try {
      final body = {'status': status};

      final res = await _networkUtils.request(
        endpoint: '/user/update/$id',
        method: HttpMethod.put,
        data: body,
      );

      if (res?.statusCode == 200) {
        final responseData = res?.data;

        // Handle both string and JSON responses
        if (responseData is String) {
          if (responseData.toLowerCase().contains('success')) {
            Messenger.alertSuccess('User status updated to $status');
            notifyListeners();
            return true;
          }
        } else if (responseData is Map<String, dynamic>) {
          final message =
              responseData['message']?.toString().toLowerCase() ?? '';
          if (message.contains('success')) {
            Messenger.alertSuccess('User status updated to $status');
            notifyListeners();
            return true;
          }
        }

        Messenger.alertError('Unexpected response format from server.');
        return false;
      } else {
        Messenger.alertError(
          res?.data['message'] ?? 'Failed to update user status',
        );
        return false;
      }
    } catch (e) {
      Messenger.alertError('Update failed: $e');
      return false;
    }
  }

  Future<bool> updateSport({
    required String id,
    required String name,
    required String about,
    required String actualPrice,
    required String finalPrice,
    required String groundName,
    required String lightingHalf,
    required String lightingFull,
    required String status,
    File? image,
    File? banner,
    File? webBanner,
  }) async {
    try {
      final form = FormData.fromMap({
        'name': name,
        'about': about,
        'actual_price_per_slot': actualPrice,
        'final_price_per_slot': finalPrice,
        'ground_name': groundName,
        'sport_lighting_price_half': lightingHalf,
        'sport_lighting_price_full': lightingFull,
        'status': status,
        if (image != null)
          'image': await MultipartFile.fromFile(
            image.path,
            filename: 'sport_image.jpg',
          ),
        if (banner != null)
          'banner': await MultipartFile.fromFile(
            banner.path,
            filename: 'sport_banner.jpg',
          ),
        if (webBanner != null)
          'web_banner': await MultipartFile.fromFile(
            webBanner.path,
            filename: 'sport_banner.jpg',
          ),
      });

      final res = await _networkUtils.request(
        endpoint: '/sports/update/$id',
        method: HttpMethod.put,
        data: form,
      );

      if (res?.statusCode == 200) {
        final data = res?.data as Map<String, dynamic>?;
        final updatedSport = data?['sport'] as Map<String, dynamic>?;

        if (updatedSport != null) {
          final index = _sports.indexWhere((s) => s['_id'] == id);
          if (index != -1) {
            _sports[index] = updatedSport;
            notifyListeners();
          }
        } else {
          await fetchSports(forceRefresh: true);
        }

        Messenger.alert(msg: 'Sport updated successfully');
        return true;
      } else {
        // Messenger.alertError(res?.data['message'] ?? 'Failed to update sport');
        return false;
      }
    } catch (e) {
      Messenger.alertError('Update failed: $e');
      return false;
    }
  }

  // Delete Sport – Instant UI Removal
  Future<bool> deleteSport(String id) async {
    try {
      final res = await _networkUtils.request(
        endpoint: '/sports/delete/$id',
        method: HttpMethod.delete,
      );

      if (res?.statusCode == 200) {
        // Local removal for instant UI refresh
        final beforeLength = _sports.length;
        _sports.removeWhere((s) => s['_id'] == id);
        final afterLength = _sports.length;

        if (beforeLength != afterLength) {
          notifyListeners();
        }

        Messenger.alertSuccess('Sport deleted');
        return true;
      } else {
        Messenger.alertError('Delete failed');
        return false;
      }
    } catch (e) {
      Messenger.alertError('Error: $e');
      return false;
    }
  }
}
