import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../domain/models/user_dto.dart';

class EnvironmentUtils {
  static UserDto? loggedUser;

  static get(String key){
    return dotenv.env[key];
  }

  static getAPIUrl() {
    return get('API_URL');
  }

  static init() async {
    await dotenv.load(fileName: ".env");
  }

  static UserDto? getLoggedUser() => loggedUser;

}