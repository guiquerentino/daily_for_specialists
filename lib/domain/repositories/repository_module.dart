import 'package:daily_for_specialists/core/http/dio_http_client.dart';
import 'package:daily_for_specialists/core/http/http_client.dart';
import 'package:daily_for_specialists/domain/repositories/articles/articles_repository.dart';
import 'package:daily_for_specialists/domain/repositories/auth/auth_repository.dart';
import 'package:daily_for_specialists/domain/repositories/auth/auth_repository_impl.dart';
import 'package:daily_for_specialists/domain/repositories/onboarding/onboarding_repository.dart';
import 'package:daily_for_specialists/domain/repositories/onboarding/onboarding_repository_impl.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'articles/articles_repository_impl.dart';
import 'home/home_repository.dart';
import 'home/home_repository_impl.dart';

class RepositoryModule extends Module {
  @override
  void binds(Injector i) {
    i.add<HttpClient>(() => DioHttpClient());
    i.add<AuthRepository>(AuthRepositoryImpl.new);
    i.add<OnboardingRepository>(OnboardingRepositoryImpl.new);
    i.add<ArticlesRepository>(ArticlesRepositoryImpl.new);
    i.add<HomeRepository>(HomeRepositoryImpl.new);
    super.binds(i);
  }
}
