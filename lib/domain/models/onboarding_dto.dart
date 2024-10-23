class OnboardingDto {
  int? userId;
  String name;
  int? gender;
  int? age;

  OnboardingDto({required this.name, this.gender, this.age, this.userId});

  Map<String, dynamic> toJson() => {'name': name, 'gender': gender, 'age': age};

  static OnboardingDto fromJson(Map<String, dynamic> json) => OnboardingDto(
      name: json['name'], gender: json['gender'], age: json['age']);
}
