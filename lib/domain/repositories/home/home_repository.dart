import 'package:daily_for_specialists/domain/models/emotion_count_dto.dart';

abstract interface class HomeRepository {
  Future<List<EmotionCountDto>?> getChartEmotionCount(int psychologistId);
}