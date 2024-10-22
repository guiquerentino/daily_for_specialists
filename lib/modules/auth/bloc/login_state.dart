sealed class LoginState {}

final class LoginInitial extends LoginState {}

final class LoginProcessing extends LoginState {}

final class LoginSuccess extends LoginState {}

final class LoginError extends LoginState {
  final String message;
  final int status;

  LoginError({
    required this.message,
    required this.status,
  });
}

final class PasswordRecoverInitial extends LoginState {}

final class PasswordRecoverProcessing extends LoginState {}

final class PasswordRecoverSucess extends LoginState {}

final class PasswordRecoverError extends LoginState {
  final String message;
  final int status;

  PasswordRecoverError({
    required this.message,
    required this.status,
  });

}

final class CreateAccountInitial extends LoginState {}

final class CreateAccountProcessing extends LoginState {}

final class CreateAccountSucess extends LoginState {}

final class CreateAccountError extends LoginState {
  final String message;
  final int status;

  CreateAccountError({
    required this.message,
    required this.status,
  });
}