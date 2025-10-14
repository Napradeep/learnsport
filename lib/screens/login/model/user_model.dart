// screens/login/model/user_model.dart
class UserModel {
  String userId;
  String fullName;
  String fatherName;
  String mobile;
  String email;
  String nativePlace;
  String address;
  String countryCode;
  String mobileCode;
  String status;
  String role;
  String token;
  String profilePicUrl;

  UserModel({
    required this.userId,
    required this.fullName,
    required this.fatherName,
    required this.mobile,
    required this.email,
    required this.nativePlace,
    required this.address,
    required this.countryCode,
    required this.mobileCode,
    required this.status,
    required this.role,
    required this.token,
    this.profilePicUrl = '',
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        userId: json['_id'] ?? '',
        fullName: json['name'] ?? '',
        fatherName: json['father_name'] ?? '',
        mobile: json['mobile'] ?? '',
        email: json['email'] ?? '',
        nativePlace: json['native_place'] ?? '',
        address: json['address'] ?? '',
        countryCode: json['country_code'] ?? '',
        mobileCode: json['mobile_code'] ?? '',
        status: json['status'] ?? '',
        role: json['role'] ?? '',
        token: json['token'] ?? '',
        profilePicUrl: json['profile_pic_url'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        '_id': userId,
        'name': fullName,
        'father_name': fatherName,
        'mobile': mobile,
        'email': email,
        'native_place': nativePlace,
        'address': address,
        'country_code': countryCode,
        'mobile_code': mobileCode,
        'status': status,
        'role': role,
        'token': token,
        'profile_pic_url': profilePicUrl,
      };
}
