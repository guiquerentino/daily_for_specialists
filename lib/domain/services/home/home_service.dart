import 'package:daily_for_specialists/domain/models/emotion_count_dto.dart';

abstract interface class HomeService {
  Future<List<EmotionCountDto>?> returnEmotionCount(int psychologistId);
}