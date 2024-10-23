import 'package:daily_for_specialists/domain/models/create_account_dto.dart';
import 'package:daily_for_specialists/domain/models/login_dto.dart';
import 'package:daily_for_specialists/domain/models/password_recover_dto.dart';
import '../../models/user_dto.dart';

abstract interface class AuthService {

  Future<UserDto?> doLoginAndSaveUser(LoginDto request);
  Future<bool> changePassword(PasswordRecoverDto request);
  Future<bool> createAccount(CreateAccountDto request);

}