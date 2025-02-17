class Mentor {
  final String? firstName;
  final String? lastName;
  final String? email;
  final int? id;
  final String? image;
  final String? company;
  final String? expertise;

  Mentor({
    this.firstName,
    this.lastName,
    this.email,
    this.id,
    this.image,
    this.company,
    this.expertise,
  });

  factory Mentor.fromJson(Map<String, dynamic> json) {
    return Mentor(
      firstName: json['first_name'] ?? "Unknown",
      lastName: json['last_name'] ?? "User",
      email: json['email'] ?? "No email",
      id: json['id'] as int?,
      image: json['image'] ?? "",
      company: json['company'] as String? ?? "Not specified",
      expertise: json['expertise'] ?? "General",
    );
  }
}
