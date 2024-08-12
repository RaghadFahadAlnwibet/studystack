class User {
  int? userId;
  final String email;
  final String password;

  User({
    this.userId,
    required this.email,
    required this.password,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        userId: json['id'],
        email: json['email'],
        password: json['password'],
      );

  Map<String, dynamic> toJson() {
    return {'id': userId,'email': email, 'password': password};
  }
}



