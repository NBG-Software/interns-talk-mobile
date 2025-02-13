class User {
  String? id;
  String? firstName;
  String? lastName;
  String? email;
  DateTime? emailVerifiedAt;
  String? password;
  String? role;
  String? profilePicture;
  DateTime? deletedAt;
  DateTime? createdAt;
  DateTime? updatedAt;

  User({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.emailVerifiedAt,
    this.password,
    this.role,
    this.profilePicture,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String?,
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      email: json['email'] as String?,
      emailVerifiedAt: json['email_verified_at'] ??
          DateTime.parse(json['email_verified_at']),
      password: json['password'] as String?,
      role: json['role'] as String?,
      profilePicture: json['profile_picture'] as String?,
      deletedAt: json['deleted_at'] ?? DateTime.parse(json['deleted_at']),
      createdAt: json['created_at'] ?? DateTime.parse(json['created_at']),
      updatedAt: json['updated_at'] ?? DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'email_verified_at': emailVerifiedAt?.toIso8601String(),
      'password': password,
      'role': role,
      'profile_picture': profilePicture,
      'deleted_at': deletedAt?.toIso8601String(),
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  static List<User> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => User.fromJson(json)).toList();
  }
}
