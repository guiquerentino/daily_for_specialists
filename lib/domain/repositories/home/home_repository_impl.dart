import 'package:daily_for_specialists/core/http/http_client.dart';
import 'package:daily_for_specialists/domain/models/emotion_count_dto.dart';
import 'package:daily_for_specialists/domain/repositories/home/home_repository.dart';
import 'package:dio/dio.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HttpClient _httpClient;
  final String emotionCountPath = "emotions";

  HomeRepositoryImpl(this._httpClient);

  @override
  Future<List<EmotionCountDto>?> getChartEmotionCount(
      int psychologistId) async {
    Response response = await _httpClient.get(emotionCountPath,
        queryParameters: {"psychologistId": psychologistId});

    if (response.statusCode != 200) {
      return null;
    }

    return EmotionCountDto.fromJsonList(response.data);
  }
}
