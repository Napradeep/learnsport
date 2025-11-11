import 'package:sportspark/utils/dio/dio.dart';
import 'package:sportspark/utils/snackbar/snackbar.dart';

class ProfileService {
  final NetworkUtils _networkUtils = NetworkUtils();

  Future<Map<String, dynamic>?> fetchProfile() async {
    final response = await _networkUtils.request(
      endpoint: '/user/profile',
      method: HttpMethod.get,
    );

    if (response != null && response.statusCode == 200) {
      print(response.data.toString());
      return response.data['user'] ?? {};
    } else {
      Messenger.alertError("Unable to fetch profile");
      return null;
    }
  }

  Future<bool> updateProfile(Map<String, dynamic> data, String Id) async {
    final response = await _networkUtils.request(
      endpoint: '/user/update/$Id',

      method: HttpMethod.put,
      data: data,
    );

    if (response != null && response.statusCode == 200) {
      Messenger.alertSuccess("Profile updated successfully");
      return true;
    } else {
      Messenger.alertError("Unable to update profile");
      return false;
    }
  }
}
