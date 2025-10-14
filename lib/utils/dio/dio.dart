// utils/network_utils.dart
import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:sportspark/utils/shared/shared_pref.dart';
import 'package:sportspark/utils/snackbar/snackbar.dart';

enum HttpMethod { get, post, put, delete, patch }

class NetworkUtils {
  static final NetworkUtils _instance = NetworkUtils._internal();

  factory NetworkUtils() => _instance;

  static const String _baseUrl = 'https://learn-fornt-app.vercel.app/v1';

  late final Dio _dio;

  NetworkUtils._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: _baseUrl,
        connectTimeout: const Duration(seconds: 60),
        receiveTimeout: const Duration(seconds: 60),
        headers: {'Content-Type': 'application/json'},
      ),
    )..interceptors.add(_createInterceptor());
  }

  InterceptorsWrapper _createInterceptor() {
    return InterceptorsWrapper(
      onRequest: (options, handler) async {
        final path = options.path;

        // 🔓 Public endpoints (no token needed)
        final publicEndpoints = [
          '/user/login',
          '/user/register',
          '/admin/login',
          '/super-admin/register',
          '/admin/register',
        ];

        final isPublic = publicEndpoints.any(
          (endpoint) => path.contains(endpoint),
        );

        if (!isPublic) {
          final token = await UserPreferences.getToken();

          if (token == null) {
            log('🚫 Missing token for secured request: $path');
            return handler.reject(
              DioException(
                requestOptions: options,
                error: 'Missing access token.',
                type: DioExceptionType.badResponse,
              ),
            );
          }

          options.headers.addAll({'Authorization': 'Bearer $token'});
        } else {
          options.headers = {'Content-Type': 'application/json'};
          log('🌐 Public endpoint: $path — no Authorization header added');
        }

        // Debug logs
        log("➡️ [${options.method}] ${options.uri}");
        if (options.data != null) log("📦 Data: ${options.data}");
        if (options.queryParameters.isNotEmpty) {
          log("🧭 Query: ${options.queryParameters}");
        }

        return handler.next(options);
      },
      onResponse: (response, handler) {
        log("✅ [${response.statusCode}] ${response.requestOptions.uri}");
        return handler.next(response);
      },
      onError: (error, handler) {
        log("❌ Error [${error.response?.statusCode}] - ${error.message}");
        _handleError(error);
        return handler.next(error);
      },
    );
  }

  /// Generic request method
  Future<Response?> request<T>({
    required String endpoint,
    required HttpMethod method,
    Map<String, dynamic>? params,
    dynamic data,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final response = await _dio.request<T>(
        endpoint,
        queryParameters: params,
        data: data,
        options: Options(method: method.name.toUpperCase(), headers: headers),
      );
      return response;
    } on DioException catch (e) {
      _handleError(e);
      return null;
    }
  }

  /// Error handler with UI feedback
  void _handleError(DioException error) {
    final statusCode = error.response?.statusCode;

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        Messenger.alertError('Request timed out. Please try again.');
        break;

      case DioExceptionType.badResponse:
        if (statusCode == 401) {
          Messenger.alertError('Unauthorized. Please login again.');
        } else if (statusCode != null && statusCode >= 500) {
          Messenger.alertError('Server error. Please try again later.');
        } else {
          Messenger.alertError('Something went wrong. Try again.');
        }
        break;

      case DioExceptionType.cancel:
        Messenger.alertError('Request was cancelled.');
        break;

      case DioExceptionType.unknown:
        if (error.error is SocketException) {
          Messenger.alertError('No Internet connection.');
        } else {
          Messenger.alertError('Unexpected error occurred.');
        }
        break;

      default:
        Messenger.alertError('Something went wrong.');
    }
  }

  /// ✅ Check network availability
  Future<bool> isNetworkAvailable() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      return result.isNotEmpty && result.first.rawAddress.isNotEmpty;
    } catch (_) {
      return false;
    }
  }
}
