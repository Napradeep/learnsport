import 'package:flutter/foundation.dart';
import 'package:sportspark/screens/search_provider/user_admin_service.dart';

class UserProvider with ChangeNotifier {
  final UserAdminService _service = UserAdminService();

  List<dynamic> _users = [];
  List<dynamic> get users => _users;

  List<dynamic> _admins = [];
  List<dynamic> get admins => _admins;

  bool _isLoadingUsers = false;
  bool get isLoadingUsers => _isLoadingUsers;

  bool _isLoadingAdmins = false;
  bool get isLoadingAdmins => _isLoadingAdmins;

  int _userCurrentPage = 1;
  int get userCurrentPage => _userCurrentPage;

  int _userTotalPages = 1;
  int get userTotalPages => _userTotalPages;

  bool get hasMoreUsers => _userCurrentPage < _userTotalPages;

  String _userSearchQuery = "";

  int _adminCurrentPage = 1;
  int get adminCurrentPage => _adminCurrentPage;

  int _adminTotalPages = 1;
  int get adminTotalPages => _adminTotalPages;

  bool get hasMoreAdmins => _adminCurrentPage < _adminTotalPages;

  String _adminSearchQuery = "";

  /// 🚀 Fetch Users
  Future<void> fetchUsers({
    int page = 1,
    int limit = 10,
    String? search,
  }) async {
    if (page > 1 && _isLoadingUsers) return;
    _isLoadingUsers = true;
    notifyListeners();

    bool resetList = false;
    if (search != null) {
      if (search != _userSearchQuery) {
        resetList = true;
        _userSearchQuery = search;
      }
    }

    if (page == 1 || resetList) {
      _users = [];
      _userCurrentPage = 1;
    }

    _userCurrentPage = page;

    final result = await _service.fetchUsersList(
      page: page,
      limit: limit,
      search: _userSearchQuery,
    );

    final data = result['data'] as List<dynamic>;
    final pagination = result['pagination'] as Map<String, dynamic>;

    if (page == 1 || resetList) {
      _users = data;
    } else {
      _users.addAll(data);
    }

    _userTotalPages = pagination['totalPages'] ?? 1;

    _isLoadingUsers = false;
    notifyListeners();
  }

  /// 🚀 Load More Users
  Future<void> loadMoreUsers({int limit = 10}) async {
    if (hasMoreUsers) {
      await fetchUsers(
        page: _userCurrentPage + 1,
        limit: limit,
        search: _userSearchQuery,
      );
    }
  }

  /// 🚀 Fetch Admins
  Future<void> fetchAdmins({
    int page = 1,
    int limit = 20,
    String? search,
  }) async {
    if (page > 1 && _isLoadingAdmins) return;
    _isLoadingAdmins = true;
    notifyListeners();

    bool resetList = false;
    if (search != null) {
      if (search != _adminSearchQuery) {
        resetList = true;
        _adminSearchQuery = search;
      }
    }

    if (page == 1 || resetList) {
      _admins = [];
      _adminCurrentPage = 1;
    }

    _adminCurrentPage = page;

    final result = await _service.fetchAdminList(
      page: page,
      limit: limit,
      search: _adminSearchQuery,
    );

    final data = result['data'] as List<dynamic>;
    final pagination = result['pagination'] as Map<String, dynamic>;

    if (page == 1 || resetList) {
      _admins = data;
    } else {
      _admins.addAll(data);
    }

    _adminTotalPages = pagination['totalPages'] ?? 1;

    _isLoadingAdmins = false;
    notifyListeners();
  }

  /// 🚀 Load More Admins
  Future<void> loadMoreAdmins({int limit = 20}) async {
    if (hasMoreAdmins) {
      await fetchAdmins(
        page: _adminCurrentPage + 1,
        limit: limit,
        search: _adminSearchQuery,
      );
    }
  }

  /// 📌 Search User by name/email
  Future<void> searchUsers(String query) async {
    await fetchUsers(page: 1, limit: 20, search: query);
  }

  /// 📌 Search Admin by name/email
  Future<void> searchAdmins(String query) async {
    await fetchAdmins(page: 1, limit: 20, search: query);
  }

  Future<void> refreshDataSilently({required bool isUserTab}) async {
    try {
      if (isUserTab) {
        final result = await _service.fetchUsersList(page: 1, limit: 10);
        final data = result['data'] as List<dynamic>;
        final pagination = result['pagination'] as Map<String, dynamic>;
        _users = data;
        _userTotalPages = pagination['totalPages'] ?? 1;
      } else {
        final result = await _service.fetchAdminList(page: 1, limit: 10);
        final data = result['data'] as List<dynamic>;
        final pagination = result['pagination'] as Map<String, dynamic>;
        _admins = data;
        _adminTotalPages = pagination['totalPages'] ?? 1;
      }
      notifyListeners();
    } catch (e) {
      if (kDebugMode) print("Background refresh failed: $e");
    }
  }

  /// 🔄 Clear search and reset to page 1
  void clearSearch({bool forUsers = true}) {
    if (forUsers) {
      _userSearchQuery = "";
      fetchUsers(page: 1);
    } else {
      _adminSearchQuery = "";
      fetchAdmins(page: 1);
    }
  }
}
