import 'dart:convert';
import 'dart:typed_data';

import 'emotion_dto.dart';

class PatientDto {
  int id;
  String name;
  int age;
  int gender;
  Uint8List? profilePhoto;
  int meditationExperience;
  EmotionDto? lastEmotion;

  PatientDto(
      {required this.id,
      required this.name,
      required this.age,
      required this.gender,
      required this.profilePhoto,
      this.lastEmotion,
      required this.meditationExperience});

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'age': age,
        'gender': gender.toString().split('.').last,
        'profilePhoto':
            profilePhoto != null ? base64Encode(profilePhoto!) : null,
        'meditationExperience': meditationExperience.toString().split('.').last,
        'lastEmotion': lastEmotion
      };

  static PatientDto fromJson(Map<String, dynamic> json) => PatientDto(
      id: json['id'],
      name: json['name'],
      age: json['age'],
      lastEmotion: json['lastEmotion'] != null
          ? EmotionDto.fromJson(json['lastEmotion'])
          : null,
      gender: _getGenderFromString(json['gender']),
      profilePhoto: json['profilePhoto'] != null
          ? base64Decode(json['profilePhoto'])
          : null,
      meditationExperience: _getMeditationExperienceFromString(json['meditationExperience'])
  );


  static int _getGenderFromString(String? gender) {
    switch (gender) {
      case "MALE":
        return 1;
      case "FEMALE":
        return 0;
      case "NONE":
        return 2;
      default:
        return 2;
    }
  }

  static int _getMeditationExperienceFromString(String? experience) {
    switch (experience) {
      case "REGULARLY":
        return 0;
      case "OCCASIONALLY":
        return 1;
      case "LONG_TIME":
        return 2;
      case "NEVER":
        return 3;
      default:
        return 3;
    }
  }

  static List<PatientDto> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => PatientDto.fromJson(json)).toList();
  }
}
