import 'package:daily_for_specialists/domain/models/onboarding_dto.dart';

abstract interface class OnboardingRepository {

  Future<bool> doProfileOnboarding(OnboardingDto request);

}