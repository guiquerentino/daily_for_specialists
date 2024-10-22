class CreateAccountDto {
  String email;
  String password;
  int role;

  CreateAccountDto(
      {required this.email, required this.password, this.role = 1});

  Map<String,dynamic> toJson() => {
    'email': email,
    'password': password,
    'role': 1
  };

  static CreateAccountDto fromJson(Map<String, dynamic> json) => CreateAccountDto(email: json['email'], password: json['password']);

}
