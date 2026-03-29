class SignupRequest {
  final String name;
  final String email;
  final String phone;
  final String password;
  final String role;
  final String? shopName;
  final String? gstNumber;

  const SignupRequest({
    required this.name,
    required this.email,
    required this.phone,
    required this.password,
    required this.role,
    this.shopName,
    this.gstNumber,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'name': name,
      'email': email,
      'phone': phone,
      'password': password,
      'role': role,
    };

    // Add optional fields only if role is seller
    if (role == 'seller') {
      if (shopName != null) data['shop_name'] = shopName;
      if (gstNumber != null) data['gst_number'] = gstNumber;
    }

    return data;
  }

  @override
  String toString() {
    return 'SignupRequest(name: $name, email: $email, phone: $phone, role: $role, shopName: $shopName, gstNumber: $gstNumber)';
  }
}