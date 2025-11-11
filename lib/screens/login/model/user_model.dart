class UserModel {
  final String userId;
  final String name;
  final String fatherName;
  final String mobile;
  final String email;
  final String nativePlace;
  final String address;
  final String countryCode;
  final String mobileCode;
  final String status;
  final String role;
  final String token;

  UserModel({
    required this.userId,
    required this.name,
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
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['_id'] ?? '',
      name: json['name'] ?? '',
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
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': userId,
    'name': name,
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
  };
}
