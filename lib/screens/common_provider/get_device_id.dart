import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:device_info_plus/device_info_plus.dart';

Future<Map<String, dynamic>> getDeviceDetails() async {
  final deviceInfo = DeviceInfoPlugin();

  try {
    // ---- WEB ----
    if (kIsWeb) {
      final web = await deviceInfo.webBrowserInfo;

      return {
        "platform": "web",
        "device_id": web.vendor ?? "web-device",
        "browser": web.userAgent,
      };
    }

    // ---- ANDROID ----
    if (Platform.isAndroid) {
      final android = await deviceInfo.androidInfo;

      return {
        "platform": "android",
        "device_id": android.id ?? "unknown-android",
        "model": android.model,
        "manufacturer": android.manufacturer,
        "version": android.version.release,
      };
    }

    // ---- IOS ----
    if (Platform.isIOS) {
      final ios = await deviceInfo.iosInfo;

      return {
        "platform": "ios",
        "device_id": ios.identifierForVendor ?? "unknown-ios",
        "model": ios.model,
        "os": ios.systemName,
        "version": ios.systemVersion,
      };
    }

    return {"platform": "other", "device_id": "unknown-device"};

  } catch (e) {
    return {"platform": "error", "device_id": "error-device"};
  }
}
