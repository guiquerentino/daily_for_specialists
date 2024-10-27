import 'dart:developer';

import 'package:daily_for_specialists/domain/repositories/repository_module.dart';
import 'package:daily_for_specialists/domain/services/service_module.dart';
import 'package:daily_for_specialists/modules/health/pages/health_page.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'bloc/health_bloc.dart';

class HealthModule extends Module {

  @override
  List<Module> get imports => [
    RepositoryModule(),
    ServiceModule()
  ];

  @override
  void binds(Injector i) {
    i.add<HealthBloc>(HealthBloc.new);
    super.binds(i);
  }

  @override
  void routes(RouteManager r) {
    r.child(Modular.initialRoute, child: (context) => HealthPage());
    super.routes(r);
  }

}