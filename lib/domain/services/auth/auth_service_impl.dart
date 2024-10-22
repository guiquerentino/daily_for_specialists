import 'dart:convert';

import 'package:daily_for_specialists/domain/models/create_account_dto.dart';
import 'package:daily_for_specialists/domain/models/login_dto.dart';
import 'package:daily_for_specialists/domain/models/password_recover_dto.dart';
import 'package:daily_for_specialists/domain/models/user_dto.dart';
import 'package:daily_for_specialists/domain/repositories/auth/auth_repository.dart';
import 'package:daily_for_specialists/domain/services/auth/auth_service.dart';
import 'package:daily_for_specialists/utils/environment_utils.dart';
import 'package:daily_for_specialists/utils/storage_utils.dart';

class AuthServiceImpl implements AuthService {
  final AuthRepository _authRepository;
  final String STORAGE_KEY = "login";

  AuthServiceImpl(this._authRepository);

  Future<UserDto?> doLoginAndSaveUser(LoginDto request) async {
    UserDto? response = await _authRepository.doLogin(request);

    if (response != null) {
      EnvironmentUtils.loggedUser = response;
      StorageUtils.save(STORAGE_KEY, jsonEncode(request.toJson()));
      return response;
    }

    return null;
  }

  @override
  Future<bool> changePassword(PasswordRecoverDto request) async {
    return await _authRepository.changePassword(request);
  }

  @override
  Future<bool> createAccount(CreateAccountDto request) async {
    return await _authRepository.createAccount(request);
  }

}
