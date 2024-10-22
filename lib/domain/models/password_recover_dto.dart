class PasswordRecoverDto {
  String email;
  String newPassword;

  PasswordRecoverDto({required this.email, required this.newPassword});

  Map<String, dynamic> toJson() => {'email': email, 'newPassword': newPassword};

  static PasswordRecoverDto fromJson(Map<String, dynamic> json) =>
      PasswordRecoverDto(
          email: json['email'], newPassword: json['newPassword']);
}
