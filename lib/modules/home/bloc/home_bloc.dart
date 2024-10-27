import 'package:daily_for_specialists/domain/models/emotion_count_dto.dart';
import 'package:daily_for_specialists/modules/home/bloc/home_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/services/home/home_service.dart';

final class HomeBloc extends Cubit<HomeState> {
  final HomeService _homeService;

  HomeBloc({required HomeService homeService})
      : _homeService = homeService,
        super((HomeInitial()));

  Future<void> loadChartsInfo(int psychologistId) async {
    emit(HomeInitial());

    try {
      emit(HomeLoading());
      List<EmotionCountDto>? response =
          await _homeService.returnEmotionCount(psychologistId);

      if (response != null) {
        emit(HomeLoaded(emotionCount: response));
      } else {
        emit(HomeError(message: "Erro ao recuperar dados de gráficos"));
      }
    } on Exception catch (s) {
      emit(HomeError(message: "Erro ao recuperar dados de gráficos"));
    }
  }
}
