import 'package:daily_for_specialists/domain/models/onboarding_dto.dart';

abstract interface class OnboardingService {

  Future<bool> doOnboarding(OnboardingDto request);

}