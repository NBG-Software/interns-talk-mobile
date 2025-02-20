class User {
  int id;
  String? firstName;
  String? lastName;
  String? email;
  String? emailVerifiedAt;
  String? password;
  String? role;
  String? profilePicture;
  String? deletedAt;
  String? createdAt;
  String? updatedAt;

  User({
    required this.id,
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
      id: json['id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      email: json['email'],
      emailVerifiedAt: json['email_verified_at'],
      password: json['password'],
      role: json['role'],
      profilePicture: json['image'],
      deletedAt: json['deleted_at'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'email_verified_at': emailVerifiedAt,
      'password': password,
      'role': role,
      'profile_picture': profilePicture,
      'deleted_at': deletedAt,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  static List<User> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => User.fromJson(json)).toList();
  }
}
