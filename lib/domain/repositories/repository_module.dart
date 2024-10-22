import 'package:daily_for_specialists/core/http/dio_http_client.dart';
import 'package:daily_for_specialists/core/http/http_client.dart';
import 'package:daily_for_specialists/domain/repositories/auth/auth_repository.dart';
import 'package:daily_for_specialists/domain/repositories/auth/auth_repository_impl.dart';
import 'package:flutter_modular/flutter_modular.dart';

class RepositoryModule extends Module {
  @override
  void binds(Injector i) {
    i.add<HttpClient>(() => DioHttpClient());
    i.add<AuthRepository>(AuthRepositoryImpl.new);
    super.binds(i);
  }
}
