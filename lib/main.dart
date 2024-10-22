
import 'dart:convert';

import 'package:daily_for_specialists/core/http/http_client_impl.dart';
import 'package:daily_for_specialists/domain/models/user_dto.dart';
import 'package:daily_for_specialists/modules/app_module.dart';
import 'package:daily_for_specialists/modules/app_widget.dart';
import 'package:daily_for_specialists/utils/environment_utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  await EnvironmentUtils.init();

  runApp(ModularApp(module: AppModule(), child: AppWidget()));
}
