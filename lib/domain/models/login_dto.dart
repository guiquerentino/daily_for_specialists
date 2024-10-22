class LoginDto {
  final String email;
  final String password;

  LoginDto({required this.email, required this.password});

  Map<String, dynamic> toJson() => {'email': email, 'password': password};

  static LoginDto fromJson(Map<String, dynamic> json) =>
      LoginDto(email: json['email'], password: json['password']);
}
