import 'package:dio/dio.dart';

abstract interface class HttpClient {

  Future<Response> get(String url, {Map<String, dynamic>? queryParameters});
  Future<Response> post(String url, Map<String, dynamic>? data);
  Future<Response> put(String url, Map<String, dynamic> data);
  Future<Response> delete(String url, {Map<String, dynamic>? data});

  }