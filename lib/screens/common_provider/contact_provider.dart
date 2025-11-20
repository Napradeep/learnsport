


import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:sportspark/screens/common_provider/get_device_id.dart';
import 'package:sportspark/utils/dio/dio.dart';

class ContactProvider with ChangeNotifier {
  final NetworkUtils _network = NetworkUtils();

  bool _isSubmitting = false;
  bool get isSubmitting => _isSubmitting;

  bool _isLoadingPending = false;
  bool _isLoadingCompleted = false;

  bool get isLoadingPending => _isLoadingPending;
  bool get isLoadingCompleted => _isLoadingCompleted;

  bool get isLoading => _isLoadingPending || _isLoadingCompleted;

  bool _isLoadingUserPending = false;
  bool _isLoadingUserCompleted = false;

  bool get isLoadingUser => _isLoadingUserPending || _isLoadingUserCompleted;

  List<Map<String, dynamic>> _adminPending = [];
  List<Map<String, dynamic>> _adminCompleted = [];

  List<Map<String, dynamic>> _userPending = [];
  List<Map<String, dynamic>> _userCompleted = [];

  List<Map<String, dynamic>> get adminPending => _adminPending;
  List<Map<String, dynamic>> get adminCompleted => _adminCompleted;

  List<Map<String, dynamic>> get userPending => _userPending;
  List<Map<String, dynamic>> get userCompleted => _userCompleted;

  int _adminPendingPage = 1;
  int _adminCompletedPage = 1;
  int _userPendingPage = 1;
  int _userCompletedPage = 1;

  bool _hasMoreAdminPending = true;
  bool _hasMoreAdminCompleted = true;

  bool _hasMoreUserPending = true;
  bool _hasMoreUserCompleted = true;

  bool get hasMoreAdminPending => _hasMoreAdminPending;
  bool get hasMoreAdminCompleted => _hasMoreAdminCompleted;

  bool get hasMoreUserPending => _hasMoreUserPending;
  bool get hasMoreUserCompleted => _hasMoreUserCompleted;

  // Normalize API model
  Map<String, dynamic> normalize(Map<String, dynamic> item) {
    return {
      "_id": item["_id"],
      "name": item["name"],
      "email": item["email"],
      "mobile": item["mobile"],
      "message": item["message"],
      "reply": item["reply"],
      "reply_status": item["reply_status"],
      "admin_read_status": item["admin_read_status"] ?? "UNREAD",
      "user_read_status": item["user_read_status"] ?? "UNREAD",
      "contact_type": item["contact_type"],
      "father_name": item["father_name"],
      "native_place": item["native_place"],
      "createdAt": item["createdAt"],
    };
  }

  // USER SUBMIT ENQUIRY
  Future<bool> submitEnquiry(Map<String, dynamic> payload) async {
    _isSubmitting = true;
    notifyListeners();

    try {
      final device = await getDeviceDetails();
      payload["device_id"] = device["device_id"];

      final res = await _network.request(
        endpoint: "/contact/submit",
        method: HttpMethod.post,
        data: payload,
      );

      return res?.statusCode == 200 || res?.statusCode == 201;
    } catch (e) {
      log("submitEnquiry Error: $e");
      return false;
    } finally {
      _isSubmitting = false;
      notifyListeners();
    }
  }

  // ADMIN FETCH
  Future<void> fetchAdminEnquiries(String type, String role) async {
    final bool isPending = type == "pending";
    final page = isPending ? _adminPendingPage : _adminCompletedPage;

    if (isPending) {
      _isLoadingPending = true;
    } else {
      _isLoadingCompleted = true;
    }
    notifyListeners();

    try {
      final response = await _network.request(
        endpoint: "/contact/admin-enquiries",
        method: HttpMethod.get,
        //read_status=UNREAD   UNREAD or READ
        params: {"reply_status" : isPending ? "UNREAD" : "READ" , "page" : page}
        //{"reply_status": isPending ? "PENDING" : "REPLIED", "page": page},
      );
      //admin_read_status

      final List list = response?.data["enquiries"] ?? [];
      log(list.toString());
      final totalPages = response?.data["pagination"]["totalPages"] ?? 1;

      final normalized = list.map((e) => normalize(e)).toList();

      if (isPending) {
        if (page == 1) _adminPending.clear();
        _adminPending.addAll(normalized);
        _adminPendingPage++;
        _hasMoreAdminPending = _adminPendingPage <= totalPages;
      } else {
        if (page == 1) _adminCompleted.clear();
        _adminCompleted.addAll(normalized);
        _adminCompletedPage++;
        _hasMoreAdminCompleted = _adminCompletedPage <= totalPages;
      }
    } catch (e) {
      log("Admin Fetch Error: $e");
    } finally {
      _isLoadingPending = false;
      _isLoadingCompleted = false;
      notifyListeners();
    }
  }

  // USER FETCH
  Future<void> fetchUserEnquiries(String status) async {
    final device = await getDeviceDetails();
    final id = device["device_id"];

    final bool isPending = status == "PENDING";
    final page = isPending ? _userPendingPage : _userCompletedPage;

    if (isPending) {
      _isLoadingUserPending = true;
    } else {
      _isLoadingUserCompleted = true;
    }
    notifyListeners();

    try {
      final response = await _network.request(
        endpoint: "/contact/user-enquiries/$id",
        method: HttpMethod.get,
        params: {"reply_status": status, "page": page},
      );

      final List list = response?.data["contacts"] ?? [];
      final totalPages = response?.data["pagination"]["pages"] ?? 1;

      final normalized = list.map((e) => normalize(e)).toList();

      if (isPending) {
        if (page == 1) _userPending.clear();
        _userPending.addAll(normalized);
        _userPendingPage++;
        _hasMoreUserPending = _userPendingPage <= totalPages;
      } else {
        if (page == 1) _userCompleted.clear();
        _userCompleted.addAll(normalized);
        _userCompletedPage++;
        _hasMoreUserCompleted = _userCompletedPage <= totalPages;
      }
    } catch (e) {
      log("User Fetch Error: $e");
    } finally {
      _isLoadingUserPending = false;
      _isLoadingUserCompleted = false;
      notifyListeners();
    }
  }

  // ADMIN REPLY
  Future<bool> replyToEnquiry(String id, String reply) async {
    try {
      final response = await _network.request(
        endpoint: "/contact/reply/$id",
        method: HttpMethod.post,
        data: {"reply": reply},
      );

      return response?.statusCode == 200;
    } catch (e) {
      log("Reply Error: $e");
      return false;
    }
  }

  // MARK ADMIN READ
  Future<bool> markAdminRead(String id) async {
    try {
      final res = await _network.request(
        endpoint: "/contact/mark-admin-read/$id",
        method: HttpMethod.put,
      );

      return res?.statusCode == 200;
    } catch (e) {
      log("markAdminRead Error: $e");
      return false;
    }
  }

  // MARK USER READ
  Future<bool> markUserRead(String id) async {
    try {
      final res = await _network.request(
        endpoint: "/contact/mark-user-read/$id",
        method: HttpMethod.post,
      );

      return res?.statusCode == 200;
    } catch (e) {
      log("markUserRead Error: $e");
      return false;
    }
  }

  // CLEAR
  void clearAll() {
    _adminPending.clear();
    _adminCompleted.clear();
    _userPending.clear();
    _userCompleted.clear();

    _adminPendingPage = 1;
    _adminCompletedPage = 1;
    _userPendingPage = 1;
    _userCompletedPage = 1;

    _hasMoreAdminPending = true;
    _hasMoreAdminCompleted = true;
    _hasMoreUserPending = true;
    _hasMoreUserCompleted = true;

    notifyListeners();
  }
}
