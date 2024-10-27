import 'dart:convert';

class EmotionDto {
  int? id;
  int? ownerId;
  String? text;
  String? comment;
  EMOTION_TYPE? emotionType;
  DateTime? creationDate;
  List<Tags>? tags;

  EmotionDto({
    this.id,
    this.ownerId,
    this.text,
    this.emotionType,
    this.creationDate,
    this.tags,
    this.comment,
  });

  factory EmotionDto.fromJson(Map<String, dynamic> json) {
    return EmotionDto(
      id: json['id'],
      ownerId: json['ownerId'],
      text: json['text'],
      comment: json['comment'],
      emotionType: json['emotionType'] != null
          ? EMOTION_TYPE.values.firstWhere(
            (e) => e.toString() == 'EMOTION_TYPE.${json['emotionType']}',
        orElse: () => EMOTION_TYPE.FELIZ,
      )
          : null,
      creationDate: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      tags: (json['tags'] is String)
          ? (jsonDecode(json['tags']) as List<dynamic>)
          .map((tagJson) => Tags.fromJson(tagJson as Map<String, dynamic>))
          .toList()
          : (json['tags'] as List<dynamic>?)
          ?.map((tagJson) => Tags.fromJson(tagJson as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': ownerId,
      'text': text,
      'comment': comment,
      'emotionType': emotionType?.toString().split('.').last,
      'createdAt': creationDate?.toIso8601String(),
      'tags': tags?.map((e) => e.toJson()).toList(),
    };
  }


  static EmotionDto fromUtf8Json(String jsonString) {
    final decodedBytes = utf8.decode(jsonString.codeUnits);
    final Map<String, dynamic> jsonData = json.decode(decodedBytes);
    return EmotionDto.fromJson(jsonData);
  }

  static List<EmotionDto> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => EmotionDto.fromJson(json as Map<String, dynamic>)).toList();
  }
}

enum EMOTION_TYPE {
  BRAVO,
  TRISTE,
  FELIZ,
  NORMAL,
  MUITO_FELIZ,
}

class Tags {
  int id;
  String emote;
  String text;

  Tags({required this.id, required this.emote, required this.text});

  factory Tags.fromJson(Map<String, dynamic> json) {
    return Tags(id: json['id'], emote: json['emote'], text: json['text']);
  }

  static List<Tags> fromJsonList(List<dynamic> jsonList) {
    return jsonList
        .map((json) => Tags.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'emote': emote, 'text': text};
  }
}


