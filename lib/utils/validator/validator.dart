class InputValidator {
  static String? validatePassword(String? password) {
    if (password == null || password.isEmpty) return 'Please enter password';
    if (password.length < 8) return 'Password must be at least 8 characters';
    if (!RegExp(r'[A-Z]').hasMatch(password)) return 'Include one uppercase';
    if (!RegExp(r'[a-z]').hasMatch(password)) return 'Include one lowercase';
    if (!RegExp(r'[0-9]').hasMatch(password)) return 'Include one number';
    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password)) {
      return 'Include one special character';
    }
    return null;
  }

  static String? validateEmail(String? email) {
    if (email == null || email.isEmpty) return 'Please enter email';
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      return 'Enter a valid email';
    }
    return null;
  }

  static String? validateEnquiry(String enquiry) {
    if (enquiry.isEmpty) {
      return 'Please enter your enquiry';
    }
    return null;
  }

  static String? validateAadhar(String? aadhar) {
    if (aadhar == null || aadhar.isEmpty) return 'Please enter Aadhar number';
    if (!RegExp(r'^[0-9]{12}$').hasMatch(aadhar)) {
      return 'Enter valid 12-digit Aadhar number';
    }
    return null;
  }

  static String? validateName(String? name) {
    if (name == null || name.isEmpty) return 'Please enter name';
    if (name.length < 2) return 'Name must be at least 2 characters';
    return null;
  }

  static String? validateFatherName(String? name) {
    if (name == null || name.isEmpty) return 'Please enter father name';
    if (name.length < 2) return 'Name must be at least 2 characters';
    return null;
  }

  static String? validateMobile(String? mobile) {
    if (mobile == null || mobile.isEmpty) return 'Please enter mobile number';
    if (!RegExp(r'^[0-9]{10}$').hasMatch(mobile)) {
      return 'Enter a valid 10-digit mobile number';
    }
    return null;
  }

  /// ✅ Validate Address
  static String? validateAddress(String? address) {
    if (address == null || address.isEmpty) return 'Please enter address';
    if (address.length < 5) return 'Address must be at least 5 characters';
    return null;
  }

  /// ✅ Validate Native Place
  static String? validateNativePlace(String? nativePlace) {
    if (nativePlace == null || nativePlace.isEmpty) {
      return 'Please enter native place';
    }
    if (nativePlace.length < 2) return 'Native place must be at least 2 characters';
    if (!RegExp(r"^[a-zA-Z\s]+$").hasMatch(nativePlace)) {
      return 'Native place must contain only letters';
    }
    return null;
  }
}
