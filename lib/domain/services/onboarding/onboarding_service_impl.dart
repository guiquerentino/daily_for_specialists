import 'package:daily_for_specialists/domain/models/onboarding_dto.dart';
import 'package:daily_for_specialists/domain/models/user_dto.dart';
import 'package:daily_for_specialists/domain/repositories/onboarding/onboarding_repository.dart';
import 'package:daily_for_specialists/domain/services/onboarding/onboarding_service.dart';
import 'package:daily_for_specialists/utils/environment_utils.dart';

class OnboardingServiceImpl implements OnboardingService {
  final OnboardingRepository _onboardingRepository;

  OnboardingServiceImpl(this._onboardingRepository);

  @override
  Future<bool> doOnboarding(OnboardingDto request) async {
    if (await _onboardingRepository.doProfileOnboarding(request)) {
      UserDto? userDto = EnvironmentUtils.getLoggedUser();

      if (userDto != null) {
        userDto.age = request.age!;
        userDto.gender = request.gender!;
        userDto.name = request.name;

        EnvironmentUtils.loggedUser = userDto;

        return true;
      }

      return false;
    }
    return false;
  }
}
