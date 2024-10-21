import 'package:daily_for_specialists/modules/splash/pages/splash_screen.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AppModule extends Module {

  @override
  void binds(Injector i) {
    super.binds(i);
  }

  @override
  void routes(RouteManager r) {
    r.child('/', child: (context) => SplashScreen());
  }

}