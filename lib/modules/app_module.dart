import 'package:daily_for_specialists/domain/repositories/repository_module.dart';
import 'package:daily_for_specialists/domain/services/service_module.dart';
import 'package:daily_for_specialists/modules/articles/articles_module.dart';
import 'package:daily_for_specialists/modules/auth/auth_module.dart';
import 'package:daily_for_specialists/modules/chat/chat_module.dart';
import 'package:daily_for_specialists/modules/goals/goals_module.dart';
import 'package:daily_for_specialists/modules/health/health_module.dart';
import 'package:daily_for_specialists/modules/home/home_module.dart';
import 'package:daily_for_specialists/modules/onboarding/onboarding_module.dart';
import 'package:daily_for_specialists/modules/profile/profile_module.dart';
import 'package:daily_for_specialists/modules/registers/registers_module.dart';
import 'package:daily_for_specialists/modules/settings/settings_module.dart';
import 'package:daily_for_specialists/modules/splash/splash_module.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AppModule extends Module {

  List<Module> get imports => [
    RepositoryModule(),
    ServiceModule()
  ];

  @override
  void binds(Injector i) {
    super.binds(i);
  }

  @override
  void routes(RouteManager r) {
    r.module(Modular.initialRoute, module: SplashModule());
    r.module('/auth', module: AuthModule());
    r.module('/home', module: HomeModule());
    r.module('/onboarding', module: OnboardingModule());
    r.module('/health', module: HealthModule());
    r.module('/chat', module: ChatModule());
    r.module('/profile', module: ProfileModule());
    r.module('/settings', module: SettingsModule());
    r.module('/articles', module: ArticlesModule());
    r.module('/registers', module: RegistersModule());
    r.module('/goals', module: GoalsModule());
  }

}