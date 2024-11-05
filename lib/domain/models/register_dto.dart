import 'dart:convert';

class RegisterDto {
  final int? id;
  final int userId;
  final String patientName;
  final String text;
  final DateTime createdAt;

  RegisterDto({
    this.id,
    required this.userId,
    required this.patientName,
    required this.text,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'patientName': patientName,
      'text': text,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory RegisterDto.fromJson(Map<String, dynamic> json) {
    return RegisterDto(
      id: json['id'] as int?,
      userId: json['userId'] as int,
      patientName: json['patientName'] as String,
      text: json['text'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  static List<RegisterDto> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => RegisterDto.fromJson(json)).toList();
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is RegisterDto &&
        other.id == id &&
        other.userId == userId &&
        other.patientName == patientName &&
        other.text == text &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
    userId.hashCode ^
    patientName.hashCode ^
    text.hashCode ^
    createdAt.hashCode;
  }
}
