import 'package:flutter/foundation.dart';
import 'package:sportspark/screens/admin/profile_service/profile_service.dart';

class ProfileProvider with ChangeNotifier {
  final ProfileService _service = ProfileService();

  Map<String, dynamic> _user = {};
  Map<String, dynamic> get user => _user;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isUpdating = false;
  bool get isUpdating => _isUpdating;

  Future<void> fetchProfile() async {
    _setLoading(true);
    final result = await _service.fetchProfile();
    _user = result ?? {};
    _setLoading(false);
    notifyListeners();
  }

  Future<bool> updateProfile(Map<String, dynamic> data, String Id) async {
    _setUpdating(true);
    final success = await _service.updateProfile(data, Id);
    if (success) {
      _user = {..._user, ...data};
    }
    _setUpdating(false);
    notifyListeners();
    return success;
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setUpdating(bool value) {
    _isUpdating = value;
    notifyListeners();
  }
}
