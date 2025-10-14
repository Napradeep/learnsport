// models/register_request.dart
class RegisterRequest {
  String name;
  String fatherName;
  String mobile;
  String email;
  String nativePlace;
  String aadharNumber;
  String address;
  String countryCode;
  String mobileCode;
  String password;

  RegisterRequest({
    required this.name,
    required this.fatherName,
    required this.mobile,
    required this.email,
    required this.nativePlace,
    required this.aadharNumber,
    required this.address,
    required this.countryCode,
    required this.mobileCode,
    required this.password,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'father_name': fatherName,
        'mobile': mobile,
        'email': email,
        'native_place': nativePlace,
        'aadhar_number': aadharNumber,
        'address': address,
        'country_code': countryCode,
        'mobile_code': mobileCode,
        'password': password,
      };
}