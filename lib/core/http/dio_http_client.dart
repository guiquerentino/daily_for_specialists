import 'package:daily_for_specialists/core/http/http_client_impl.dart';
import 'package:dio/dio.dart';

final class DioHttpClient extends HttpClientImpl{
  DioHttpClient() : super(dio: Dio());
}