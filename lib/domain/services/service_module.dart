import 'package:daily_for_specialists/domain/repositories/repository_module.dart';
import 'package:daily_for_specialists/domain/services/auth/auth_service.dart';
import 'package:daily_for_specialists/domain/services/auth/auth_service_impl.dart';
import 'package:flutter_modular/flutter_modular.dart';

class ServiceModule extends Module {

  @override
  List<Module> get imports => [
    RepositoryModule()
  ];

  @override
  void binds(Injector i) {
    i.add<AuthService>(AuthServiceImpl.new);
    super.binds(i);
  }



}