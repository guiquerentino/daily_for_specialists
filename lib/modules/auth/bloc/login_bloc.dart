import 'dart:convert';
import 'dart:io';

import 'package:daily_for_specialists/domain/models/create_account_dto.dart';
import 'package:daily_for_specialists/domain/models/login_dto.dart';
import 'package:daily_for_specialists/domain/models/password_recover_dto.dart';
import 'package:daily_for_specialists/domain/repositories/auth/auth_repository.dart';
import 'package:daily_for_specialists/modules/auth/bloc/login_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/models/user_dto.dart';
import '../../../domain/services/auth/auth_service.dart';
import '../../../utils/storage_utils.dart';

final class LoginBloc extends Cubit<LoginState> {
  final AuthService _authService;

  LoginBloc(
      {required AuthRepository authRepository,
      required AuthService authService})
      : _authService = authService,
        super(LoginInitial());

  Future<UserDto?> login(LoginDto? loginDto) async {
    try {
      emit(LoginProcessing());

      UserDto? userDto = await _authService.doLoginAndSaveUser(loginDto!);

      if (userDto != null && userDto.role == 1) {
        emit(LoginSuccess());
        return userDto;
      } else {
        emit(LoginError(
            message: "Falha ao fazer login. Verifique suas informações.",
            status: 500));
        return null;
      }
    } on Exception catch (e) {
      emit(LoginError(
          message: "Falha ao fazer login. Verifique suas informações.",
          status: 503));
      return null;
    }
  }

  Future<void> checkSavedLogin() async {
    try {
      emit(LoginProcessing());
      String? savedLogin = await StorageUtils.read('login');

      if (savedLogin != null) {
        LoginDto savedLoginDto = LoginDto.fromJson(jsonDecode(savedLogin));
        UserDto? userDto = await _authService.doLoginAndSaveUser(savedLoginDto);

        if (userDto != null && userDto.role == 1) {
          emit(LoginSuccess());
        } else {
          emit(LoginError(
            message: "Falha ao fazer login automático.",
            status: 500,
          ));
        }
      } else {
        emit(LoginInitial());
      }
    } catch (e) {
      emit(LoginError(
        message: "Erro ao verificar login salvo.",
        status: 500,
      ));
    }
  }

  Future<bool> recoverPassword(String email, String newPassword) async {
    emit(PasswordRecoverInitial());
    try {
      emit(PasswordRecoverProcessing());

      PasswordRecoverDto request =
          PasswordRecoverDto(email: email, newPassword: newPassword);

      bool response = await _authService.changePassword(request);

      if (response == true) {
        emit(PasswordRecoverSucess());
        return true;
      } else {
        emit(PasswordRecoverError(
            message: "Informações inválidas, verifique novamente.",
            status: 500));
        return false;
      }
    } on Exception catch (e, s) {
      emit(PasswordRecoverError(
          message:
              "Erro inesperado ao tentar recuperar senha. Tente novamente.",
          status: 500));
      return false;
    }
  }

  Future<bool> createAccount(String email, String password) async {
    emit(CreateAccountInitial());

    try {
      emit(CreateAccountProcessing());
      CreateAccountDto request =
          CreateAccountDto(email: email, password: password);

      bool response = await _authService.createAccount(request);

      if (response == true) {
        emit(CreateAccountSucess());
        return true;
      } else {
        emit(CreateAccountError(
            message: "Erro ao criar a conta. Verifique as informações.",
            status: 500));
        return false;
      }
    } on Exception catch (e, s) {
      emit(CreateAccountError(
          message: "Erro ao criar a conta. Verifique as informações.",
          status: 500));
      return false;
    }
  }
}
