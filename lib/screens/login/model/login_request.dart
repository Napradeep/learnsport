// models/login_request.dart
class LoginRequest {
  String mobile;
  String password;

  LoginRequest({required this.mobile, required this.password});

  Map<String, dynamic> toJson() => {
        'mobile': mobile,
        'password': password,
      };
}