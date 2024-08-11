class Users {
  final int? userId;
  final String email;
  final String password;

  Users({
    this.userId,
    required this.email,
    required this.password,
  });

  factory Users.fromJson(Map<String, dynamic> json) => Users(
        email: json['email'],
        password: json['password'],
      );

  Map<String, dynamic> toJson() {
    return {'email': email, 'password': password};
  }
}
