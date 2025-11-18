import 'package:flutter/material.dart';
import 'gallery_service.dart';

class GalleryProvider extends ChangeNotifier {
  final GalleryService _service = GalleryService();

  List<Map<String, dynamic>> _gallery = [];
  bool _loading = false;

  bool get loading => _loading;
  List<Map<String, dynamic>> get gallery => _gallery;

  // --------------------------
  // LOAD GALLERY
  // --------------------------
  Future<void> loadGallery(String sportId) async {
    _loading = true;

    // Do NOT notify during build → postpone
    Future.microtask(() => notifyListeners());

    try {
      final data = await _service.fetchGalleryBySport(sportId);
      _gallery = List<Map<String, dynamic>>.from(data);
    } catch (_) {
      _gallery = [];
    }

    _loading = false;
    notifyListeners();
  }

  // --------------------------
  // DELETE ITEM
  // --------------------------
  Future<bool> deleteItem(String id) async {
    final ok = await _service.deleteGallery(id);

    if (ok) {
      _gallery.removeWhere((g) => g["_id"] == id);
      notifyListeners();
    }
    return ok;
  }
}
