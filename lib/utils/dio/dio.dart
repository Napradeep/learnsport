import 'dart:developer';
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
        const publicEndpoints = [
          '/user/login',
          '/user/register',
          '/admin/login',
          '/admin/register',
          '/super-admin/register',
        ];

        final isPublic = publicEndpoints.any((e) => options.path.contains(e));

        if (!isPublic) {
          final token = await UserPreferences.getToken();
          print(token);
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
        }

        log("➡️ [${options.method}] ${options.uri}");
        if (options.data != null) log("📦 Data: ${options.data}");
        

        return handler.next(options);
      },
      onResponse: (response, handler) {
        log("✅ [${response.statusCode}] ${response.requestOptions.uri}");
        return handler.next(response);
      },
      onError: (error, handler) {
        final msg = _handleError(error);
        return handler.next(error);
      },
    );
  }

  // 🔥 This returns proper API error message
  String _handleError(DioException error) {
    final data = error.response?.data;

    String? apiMessage;

    if (data is Map<String, dynamic>) {
      apiMessage = data["message"];
    } else if (data is String) {
      apiMessage = data;
    }

    apiMessage ??= "Something went wrong";

    log("⚠️ API Error Message: $apiMessage");
    Messenger.alertError(apiMessage);

    return apiMessage;
  }

  Future<Response?> request<T>({
    required String endpoint,
    required HttpMethod method,
    Map<String, dynamic>? params,
    dynamic data,
    Map<String, dynamic>? headers,
  }) async {
    try {
      return await _dio.request(
        endpoint,
        data: data,
        queryParameters: params,
        options: Options(method: method.name.toUpperCase()),
      );
    } on DioException catch (e) {
      final msg = _handleError(e);

      return Response(
        requestOptions: RequestOptions(),
        data: {"message": msg},
        statusCode: e.response?.statusCode,
      );
    }
  }
}
