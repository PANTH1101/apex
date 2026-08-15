class AuthResponse {
  final String token;
  final int userId;
  final String name;
  final String email;
  final String role;

  AuthResponse({
    required this.token,
    required this.userId,
    required this.name,
    required this.email,
    required this.role,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      token: json['token'],
      userId: json['userId'],
      name: json['name'],
      email: json['email'],
      role: json['role'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'userId': userId,
      'name': name,
      'email': email,
      'role': role,
    };
  }
}
