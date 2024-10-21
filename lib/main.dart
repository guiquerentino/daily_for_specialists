import 'package:daily_for_specialists/modules/app_module.dart';
import 'package:daily_for_specialists/modules/app_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

void main() {
  runApp(ModularApp(module: AppModule(), child: AppWidget()));
}

