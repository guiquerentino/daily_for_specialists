import 'package:daily_for_specialists/modules/onboarding/bloc/onboarding_bloc.dart';
import 'package:daily_for_specialists/modules/onboarding/pages/age_onboarding_page.dart';
import 'package:daily_for_specialists/modules/onboarding/pages/gender_onboarding_page.dart';
import 'package:daily_for_specialists/modules/onboarding/pages/name_onboarding_page.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../domain/repositories/repository_module.dart';
import '../../domain/services/service_module.dart';

class OnboardingModule extends Module {

  @override
  List<Module> get imports => [
    RepositoryModule(),
    ServiceModule()
  ];

  @override
  void binds(Injector i) {
    i.addSingleton<OnboardingBloc>(OnboardingBloc.new);
  }

  @override
  void routes(RouteManager r) {
      r.child(Modular.initialRoute, child: (context) => NameOnboardingPage(userId: r.args.data));
      r.child('/gender', child: (context) => GenderOnboardingPage(request: r.args.data));
      r.child('/age', child: (context) => AgeOnboardingPage(request: r.args.data,));
  }

}