import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:sportspark/screens/sportslist/sports_service.dart';

class SportsProvider extends ChangeNotifier {
  final SportsService _sportsService = SportsService();

  List<Map<String, dynamic>> _sports = [];
  bool _isLoading = false;
  String? _error;

  List<Map<String, dynamic>> get sports => _sports;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadSports() async {
    if (_isLoading) return;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final sports = await _sportsService.fetchSportsList();
      if (sports != null) {
        _sports = sports;
      } else {
        _error = 'Failed to load sports';
      }
    } catch (e) {
      _error = e.toString();
      log('Provider error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void retry() {
    _error = null;
    loadSports();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
