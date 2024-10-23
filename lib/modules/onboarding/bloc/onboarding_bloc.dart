import 'package:daily_for_specialists/domain/models/onboarding_dto.dart';
import 'package:daily_for_specialists/domain/services/onboarding/onboarding_service.dart';
import 'package:daily_for_specialists/modules/onboarding/bloc/onboarding_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final class OnboardingBloc extends Cubit<OnboardingState> {
  final OnboardingService _onboardingService;

  OnboardingBloc({required OnboardingService onboardingService})
      : _onboardingService = onboardingService,
        super(OnboardingInitial());

  Future<bool> onboarding(OnboardingDto request) async {
    emit(OnboardingInitial());

    try {
      emit(OnboardingProcessing());
      bool response = await _onboardingService.doOnboarding(request);

      if (response == true) {
        emit(OnboardingSuccessful());
        return true;
      }

      emit(OnboardingError(
          message:
              "Erro ao atualizar suas informações. Tente novamente mais tarde",
          status: 500));
      return false;
    } on Exception catch (e) {
      emit(OnboardingError(
          message:
              "Erro ao atualizar suas informações. Tente novamente mais tarde",
          status: 500));
      return false;
    }
  }
}
