import 'package:daily_for_specialists/domain/models/patient_dto.dart';

class ChatDTO {
  final int? id;
  final PatientDto? patient;
  final String? lastMessage;
  final String? lastMessageTime;

  ChatDTO({
    this.id,
    this.patient,
    this.lastMessage,
    this.lastMessageTime
  });

  factory ChatDTO.fromJson(Map<String, dynamic> json) {
    return ChatDTO(
      id: json['id'],
      patient: json['patient'] != null ? PatientDto.fromJson(json['patient']) : null,
      lastMessage: json['lastMessage'],
      lastMessageTime: json['lastMessageTime']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'patient': patient?.toJson(),
      'lastMessage': lastMessage,
      'lastMessageTime': lastMessageTime
    };
  }

  static List<ChatDTO> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => ChatDTO.fromJson(json)).toList();
  }
}