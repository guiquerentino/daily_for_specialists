import 'package:daily_for_specialists/core/constants/route_constants.dart';
import 'package:daily_for_specialists/domain/repositories/repository_module.dart';
import 'package:daily_for_specialists/domain/services/service_module.dart';
import 'package:daily_for_specialists/modules/auth/pages/account_created_page.dart';
import 'package:daily_for_specialists/modules/auth/pages/create_account_page.dart';
import 'package:daily_for_specialists/modules/auth/pages/forgot_password_page.dart';
import 'package:daily_for_specialists/modules/auth/pages/login_page.dart';
import 'package:daily_for_specialists/modules/auth/pages/password_changed_page.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'bloc/login_bloc.dart';

class AuthModule extends Module {

  @override
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
    r.child('/', child: (context) => LoginPage());
    r.child('/forgot-password', child: (context) => ForgotPasswordPage());
    r.child('/password-changed', child: (context) => PasswordChangedPage());
    r.child('/create-account', child: (context) => CreateAccountPage());
    r.child('/account-created', child: (context) => AccountCreatedPage());

  }
}
