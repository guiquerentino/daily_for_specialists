import 'package:daily_for_specialists/domain/repositories/repository_module.dart';
import 'package:daily_for_specialists/domain/services/articles/articles_service.dart';
import 'package:daily_for_specialists/domain/services/articles/articles_service_impl.dart';
import 'package:daily_for_specialists/domain/services/auth/auth_service.dart';
import 'package:daily_for_specialists/domain/services/auth/auth_service_impl.dart';
import 'package:daily_for_specialists/domain/services/onboarding/onboarding_service.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'home/home_service.dart';
import 'home/home_service_impl.dart';
import 'onboarding/onboarding_service_impl.dart';

class ServiceModule extends Module {

  @override
  List<Module> get imports => [
    RepositoryModule()
  ];

  @override
  void binds(Injector i) {
    i.add<AuthService>(AuthServiceImpl.new);
    i.add<OnboardingService>(OnboardingServiceImpl.new);
    i.add<ArticlesService>(ArticlesServiceImpl.new);
    i.add<HomeService>(HomeServiceImpl.new);
    super.binds(i);
  }



}