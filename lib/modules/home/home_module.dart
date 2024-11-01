import 'package:daily_for_specialists/domain/repositories/repository_module.dart';
import 'package:daily_for_specialists/domain/services/service_module.dart';
import 'package:daily_for_specialists/modules/auth/bloc/login_bloc.dart';
import 'package:daily_for_specialists/modules/home/pages/home_page.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../articles/bloc/articles_bloc.dart';
import 'bloc/home_bloc.dart';

class HomeModule extends Module {

  @override
  List<Module> get imports => [
    RepositoryModule(),
    ServiceModule()
  ];

  @override
  void binds(Injector i) {
    i.addSingleton<ArticlesBloc>(ArticlesBloc.new);
    i.addSingleton<HomeBloc>(HomeBloc.new);
    i.addSingleton<LoginBloc>(LoginBloc.new);
  }

  @override
  void routes(RouteManager r) {
    r.child(Modular.initialRoute, child: (context) => HomePage());
  }

}