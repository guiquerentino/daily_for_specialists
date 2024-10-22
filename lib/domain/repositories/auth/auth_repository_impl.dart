import 'dart:convert';

import 'package:daily_for_specialists/core/http/http_client.dart';
import 'package:daily_for_specialists/domain/models/create_account_dto.dart';
import 'package:daily_for_specialists/domain/models/login_dto.dart';
import 'package:daily_for_specialists/domain/models/password_recover_dto.dart';
import 'package:daily_for_specialists/domain/repositories/auth/auth_repository.dart';
import 'package:dio/dio.dart';

import '../../models/user_dto.dart';

class AuthRepositoryImpl implements AuthRepository {
  final HttpClient _httpClient;
  final String authPath = 'user/authorize';
  final String recoverPasswordPath = 'user/password';
  final String createAccountPath = 'user';
  AuthRepositoryImpl(this._httpClient);

  @override
  Future<UserDto?> doLogin(LoginDto request) async {
    Response response = await _httpClient.post(authPath, request.toJson());

    if (response.statusCode != 202) {
      return null;
    }

    return UserDto.fromJson(response.data);
  }

  @override
  Future<bool> changePassword(PasswordRecoverDto request) async {
    Response response =
        await _httpClient.put(recoverPasswordPath, request.toJson());

    if (response.statusCode != 200) {
      return false;
    }

    return true;
  }

  @override
  Future<bool> createAccount(CreateAccountDto request) async {
    Response response = await _httpClient.post(createAccountPath, request.toJson());

    if(response.statusCode != 201){
      return false;
    }

    return true;
  }
}
