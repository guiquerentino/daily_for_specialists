class GoalDto {
  int? id;
  int? userId;
  String title;
  String createdBy;
  DateTime? creationDate;
  bool isDone;
  bool isAllDay;
  DateTime scheduledTime;

  GoalDto({
    this.id,
    this.userId,
    required this.title,
    required this.createdBy,
    required this.isDone,
    required this.isAllDay,
    DateTime? creationDate,
    required this.scheduledTime,
  }) : creationDate = creationDate ?? DateTime.now();

  factory GoalDto.fromJson(Map<String, dynamic> json) {
    return GoalDto(
        id: json['id'],
        userId: json['userId'],
        isDone: json['isCompleted'],
        title: json['title'],
        isAllDay: json['isAllDay'],
        createdBy: json['createdBy'],
        creationDate: DateTime.parse(json['createdAt']),
        scheduledTime: DateTime.parse(json['scheduledTime']));
  }

  GoalDto copyWith({
    int? id,
    String? title,
    bool? isDone,
    DateTime? scheduledTime,
    String? createdBy,
    int? userId,
    bool? isAllDay
  }) {
    return GoalDto(
      id: id ?? this.id,
      isAllDay: isAllDay ?? this.isAllDay,
      title: title ?? this.title,
      isDone: isDone ?? this.isDone,
      scheduledTime: scheduledTime ?? this.scheduledTime,
      createdBy: createdBy ?? this.createdBy,
      userId: userId ?? this.userId,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'isCompleted': isDone,
      'isAllDay': isAllDay,
      'createdBy': createdBy,
      'createdAt': creationDate?.toIso8601String(),
      'scheduledTime': scheduledTime?.toIso8601String(),
    };
  }

  static List<GoalDto> fromJsonList(List<dynamic> jsonList) {
    return jsonList
        .map((json) => GoalDto.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}
