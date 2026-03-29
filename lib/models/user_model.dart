class UserModel {
  final String? id;
  final String? name;
  final String? email;
  final String? role;
  final String? token;

  const UserModel({
    this.id,
    this.name,
    this.email,
    this.role,
    this.token,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    // Handle nested data structure from API response
    final data = json['data'] ?? json;
    
    return UserModel(
      id: data['_id']?.toString(),
      name: data['name']?.toString(),
      email: data['email']?.toString(),
      role: data['role']?.toString(),
      token: data['token']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'email': email,
      'role': role,
      'token': token,
    };
  }

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? role,
    String? token,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      token: token ?? this.token,
    );
  }

  @override
  String toString() {
    return 'UserModel(id: $id, name: $name, email: $email, role: $role, token: $token)';
  }
}