import 'package:daily_for_specialists/domain/repositories/repository_module.dart';
import 'package:daily_for_specialists/domain/services/service_module.dart';
import 'package:daily_for_specialists/modules/registers/pages/registers_page.dart';
import 'package:flutter_modular/flutter_modular.dart';

class RegistersModule extends Module {

  @override
  List<Module> get imports => [
    RepositoryModule(),
    ServiceModule()
  ];

  @override
  void routes(RouteManager r) {
    r.child(Modular.initialRoute, child: (context) => RegistersPage());
  }

}