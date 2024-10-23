import 'package:daily_for_specialists/core/http/http_client.dart';
import 'package:daily_for_specialists/domain/models/onboarding_dto.dart';
import 'package:daily_for_specialists/domain/repositories/onboarding/onboarding_repository.dart';
import 'package:dio/dio.dart';

class OnboardingRepositoryImpl implements OnboardingRepository {
  final HttpClient _httpClient;
  final String onboardingPath = 'user/onboarding';
  OnboardingRepositoryImpl(this._httpClient);

  @override
  Future<bool> doProfileOnboarding(OnboardingDto request) async {

    Response response = await _httpClient.put("$onboardingPath?userId=${request.userId}", request.toJson());

    if(response.statusCode != 200){
      return false;
    }

    return true;
  }

}