import 'package:daily_for_specialists/core/constants/http_constants.dart';
import 'package:daily_for_specialists/core/http/http_client.dart';
import 'package:daily_for_specialists/utils/environment_utils.dart';
import 'package:dio/dio.dart';

class HttpClientImpl implements HttpClient{
  final Dio _dio;

  final _defaultOptions = BaseOptions(
    baseUrl: EnvironmentUtils.getAPIUrl(),
    connectTimeout: const Duration(seconds: HttpConstants.CONNECT_TIMEOUT),
    receiveTimeout: const Duration(seconds: HttpConstants.RECEIVE_TIMEOUT)
  );

  HttpClientImpl({required Dio dio, BaseOptions? baseOptions}) : _dio = dio {
    _dio.options = baseOptions ?? _defaultOptions;
  }

  Future<Response> get(String url, {Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await _dio.get(url, queryParameters: queryParameters);
      return response;
    } on DioException catch (e) {
      throw Exception('Erro ao realizar GET: ${e.message}');
    }
  }

  Future<Response> post(String url, Map<String, dynamic> data) async {
    try {
      final response = await _dio.post(url, data: data);
      return response;
    } on DioException catch (e) {
      throw Exception('Erro ao realizar POST: ${e.message}');
    }
  }

  Future<Response> put(String url, Map<String, dynamic> data) async {
    try {
      final response = await _dio.put(url, data: data);
      return response;
    } on DioException catch (e) {
      throw Exception('Erro ao realizar PUT: ${e.message}');
    }
  }

  Future<Response> delete(String url, {Map<String, dynamic>? data}) async {
    try {
      final response = await _dio.delete(url, data: data);
      return response;
    } on DioException catch (e) {
      throw Exception('Erro ao realizar DELETE: ${e.message}');
    }
  }
}
