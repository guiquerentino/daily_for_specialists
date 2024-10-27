import 'package:daily_for_specialists/domain/models/emotion_count_dto.dart';
import 'package:daily_for_specialists/domain/services/home/home_service.dart';
import '../../repositories/home/home_repository.dart';

class HomeServiceImpl implements HomeService {
  final HomeRepository _homeRepository;

  HomeServiceImpl(this._homeRepository);

  @override
  Future<List<EmotionCountDto>?> returnEmotionCount(int psychologistId) async {
    return await _homeRepository.getChartEmotionCount(psychologistId);
  }

}