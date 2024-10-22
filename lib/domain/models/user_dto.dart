import 'dart:convert';
import 'dart:typed_data';

class UserDto {
  int id;
  int role;
  bool hasOnboarding;
  String email;
  String? name;
  Uint8List? profilePhoto;
  int? gender;
  int? age;
  List<int> patients; // Alterado para não ser null

  UserDto({
    required this.id,
    required this.role,
    required this.hasOnboarding,
    required this.email,
    this.name,
    this.profilePhoto,
    this.age,
    this.gender,
    List<int>? patients,
  }) : patients = patients ?? [];

  Map<String, dynamic> toJson() => {
    'id': id,
    'role': role.toString().split('.').last,
    'hasOnboarding': hasOnboarding,
    'email': email,
    'name': name,
    'profilePhoto':
    profilePhoto != null ? base64Encode(profilePhoto!) : null,
    'gender': gender.toString().split('.').last,
    'age': age,
    'patients': patients,
  };

  static UserDto fromJson(Map<String, dynamic> json) => UserDto(
    id: json['id'],
    role: _getAccountRole(json['role']),
    hasOnboarding: json['hasOnboarding'],
    email: json['email'],
    name: json['name'],
    profilePhoto: json['profilePhoto'] != null
        ? base64Decode(json['profilePhoto'])
        : null,
    gender: _getGenderFromString(json['gender']),
    age: json['age'],
    patients: List<int>.from(json['patients'] ?? []),
  );

  static int _getAccountRole(String? type) {
    switch (type) {
      case "PATIENT":
        return 0;
      case "PSYCHOLOGIST":
        return 1;
      default:
        throw const FormatException("Invalid account role");
    }
  }

  static int? _getGenderFromString(String? gender) {
    switch (gender) {
      case "MALE":
        return 1;
      case "FEMALE":
        return 0;
      case "NONE":
        return 2;
      default:
        return null;
    }
  }
}
