class UserModel {
  final String? id;
  final String? name;
  final String? email;
  final String? phone;
  final String? role;
  final String? profileImage;
  final String? createdAt;
  final String? updatedAt;
  final String? token;

  const UserModel({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.role,
    this.profileImage,
    this.createdAt,
    this.updatedAt,
    this.token,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    // Handle nested data structure from API response
    final data = json['data'] ?? json;
    
    return UserModel(
      id: data['_id']?.toString(),
      name: data['name']?.toString(),
      email: data['email']?.toString(),
      phone: data['phone']?.toString(),
      role: data['role']?.toString(),
      profileImage: data['profile_image']?.toString(),
      createdAt: data['created_at']?.toString() ?? data['createdAt']?.toString(),
      updatedAt: data['updated_at']?.toString() ?? data['updatedAt']?.toString(),
      token: data['token']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'role': role,
      'profile_image': profileImage,
      'created_at': createdAt,
      'updatedAt': updatedAt,
      'token': token,
    };
  }

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? role,
    String? profileImage,
    String? createdAt,
    String? updatedAt,
    String? token,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      profileImage: profileImage ?? this.profileImage,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      token: token ?? this.token,
    );
  }

  @override
  String toString() {
    return 'UserModel(id: $id, name: $name, email: $email, phone: $phone, role: $role, profileImage: $profileImage, createdAt: $createdAt, updatedAt: $updatedAt, token: $token)';
  }
}