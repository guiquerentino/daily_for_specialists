import 'package:daily_for_specialists/domain/repositories/repository_module.dart';
import 'package:daily_for_specialists/domain/services/service_module.dart';
import 'package:daily_for_specialists/modules/articles/bloc/articles_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';

class ArticlesModule extends Module {

  @override
  List<Module> get imports => [
    RepositoryModule(),
    ServiceModule()
  ];

  @override
  void binds(Injector i) {
    i.addSingleton<ArticlesBloc>(ArticlesBloc.new);
    super.binds(i);
  }

  @override
  void routes(RouteManager r) {

  }



}