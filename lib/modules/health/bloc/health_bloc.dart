import 'package:daily_for_specialists/core/http/http_client.dart';
import 'package:daily_for_specialists/domain/models/patient_dto.dart';
import 'package:daily_for_specialists/modules/health/bloc/health_state.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final class HealthBloc extends Cubit<HealthState> {
  final HttpClient _httpClient;
  final String codePath = 'patients';

  HealthBloc({
    required HttpClient httpClient,
  })  : _httpClient = httpClient,
        super(HealthInitial());

  Future<void> doConnection(int psychologistId, String code) async {
    emit(HealthInitial());

    try {
      emit(HealthLoading());

      Response response = await _httpClient.post(
          "$codePath?userId=$psychologistId&code=$code", null);

      if (response.statusCode != 200) {
        emit(HealthError(
            message: "Erro ao realizar conexão. Tente novamente mais tarde."));
      } else {
        PatientDto patient = PatientDto.fromJson(response.data);
        emit(HealthLoaded(patient: patient));
      }
    } on Exception catch (s) {
      emit(HealthError(message: s.toString()));
    }
  }
}
