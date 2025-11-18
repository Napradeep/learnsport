import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:sportspark/utils/dio/dio.dart';

class GalleryService {
  final NetworkUtils _network = NetworkUtils();

  // -----------------------------
  // FETCH GALLERY
  // -----------------------------
  Future<List<dynamic>> fetchGalleryBySport(String sportId) async {
    final response = await _network.request(
      endpoint: "/gallery/list/$sportId",
      method: HttpMethod.get,
    );

    if (response == null) return [];
    if (response.statusCode == 200) {
      log(response.data.toString());
      return response.data["gallery"] ?? [];
    }

    return [];
  }

  // -----------------------------
  // DELETE GALLERY ITEM
  // -----------------------------
  Future<bool> deleteGallery(String id) async {
    final response = await _network.request(
      endpoint: "/gallery/delete/$id",
      method: HttpMethod.delete,
    );

    return response != null && response.statusCode == 200;
  }

  // -----------------------------
  // ADD GALLERY ITEM
  // -----------------------------
  Future<bool> addGallery({
    required String sportId,
    required String eventName,
    required String title,
    required String conductedTime,
    required List<String> youtubeLinks,
    required List<File> files,
  }) async {
    final formData = FormData();

    formData.fields.addAll([
      MapEntry("sports_id", sportId),
      MapEntry("event_name", eventName),
      MapEntry("gallery_title", title),
      MapEntry("conducted_time", conductedTime),
    ]);

    for (var link in youtubeLinks) {
      formData.fields.add(MapEntry("youtube_links", link));
    }

    for (var f in files) {
      formData.files.add(
        MapEntry(
          "files",
          await MultipartFile.fromFile(
            f.path,
            filename: f.path.split("/").last,
          ),
        ),
      );
    }

    final response = await _network.request(
      endpoint: "/gallery/add",
      method: HttpMethod.post,
      data: formData,
      headers: {"Content-Type": "multipart/form-data"},
    );

    final code = response?.statusCode ?? 0;

    // Accept 200 or 201 as success
    return code == 200 || code == 201;
  }
}
