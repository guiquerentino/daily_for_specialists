import 'package:daily_for_specialists/domain/repositories/repository_module.dart';
import 'package:daily_for_specialists/domain/services/service_module.dart';
import 'package:daily_for_specialists/modules/auth/bloc/login_bloc.dart';
import 'package:daily_for_specialists/modules/splash/pages/splash_screen.dart';
import 'package:flutter_modular/flutter_modular.dart';

class SplashModule extends Module {

  List<Module> get imports => [
    RepositoryModule(),
    ServiceModule()
  ];

  @override
  void binds(Injector i) {
    i.addSingleton<LoginBloc>(LoginBloc.new);
    super.binds(i);
  }

  @override
  void routes(RouteManager r) {
    r.child(Modular.initialRoute, child: (context) => const SplashScreen());
  }

}