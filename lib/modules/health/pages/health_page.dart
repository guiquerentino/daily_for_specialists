import 'dart:math';

import 'package:daily_for_specialists/core/ui/daily_button.dart';
import 'package:daily_for_specialists/core/ui/daily_colors.dart';
import 'package:daily_for_specialists/modules/health/bloc/health_bloc.dart';
import 'package:daily_for_specialists/modules/health/bloc/health_state.dart';
import 'package:daily_for_specialists/utils/environment_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:gap/gap.dart';

import '../../../core/constants/route_constants.dart';
import '../../../core/ui/daily_bottom_navigation_bar.dart';
import '../../../core/ui/daily_drawer.dart';
import '../../../core/ui/daily_text.dart';
import '../../../domain/models/user_dto.dart';

class HealthPage extends StatefulWidget {
  const HealthPage({super.key});

  @override
  State<HealthPage> createState() => _HealthPageState();
}

class _HealthPageState extends State<HealthPage> {
  final controllers = List.generate(6, (_) => TextEditingController());
  final focusNodes = List.generate(6, (_) => FocusNode());
  late final HealthBloc _healthBloc;

  @override
  void dispose() {
    for (var controller in controllers) {
      controller.dispose();
    }
    for (var focusNode in focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  @override
  void initState() {
    _healthBloc = Modular.get<HealthBloc>();
    super.initState();
  }

  String getCodeFromTextFields() {
    return controllers.map((controller) => controller.text).join();
  }

  void _submitCode(int id, String code) {
    final code = getCodeFromTextFields();
    if (code.length == 6) {
      _healthBloc.doConnection(id, code.toUpperCase());
    } else {
     return;
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const DailyDrawer(),
      resizeToAvoidBottomInset: false,
      backgroundColor: DailyColors.pageBackgroundColor,
      bottomNavigationBar: const DailyBottomNavigationBar(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(22.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Builder(
                  builder: (context) {
                    return GestureDetector(
                        onTap: () {
                          Scaffold.of(context).openDrawer();
                        },
                        child: const Icon(Icons.menu, size: 34));
                  }
                ),
                const Text("Área Saúde",
                    style:
                        TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
                Container()
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(30, 8, 0, 0),
            alignment: Alignment.topLeft,
            child: const Text("Explorar",
                textAlign: TextAlign.start,
                style: TextStyle(
                    fontSize: 24,
                    fontFamily: 'Pangram',
                    fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            direction: Axis.horizontal,
            children: [
              GestureDetector(
                onTap: () {
                  Modular.to.navigate(RouteConstants.chatPage);
                },
                child: Container(
                  height: 100,
                  width: 110,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white,
                  ),
                  child: Column(
                    children: [
                      Image.asset('assets/article_illustration5.png',
                          height: 70, width: 70),
                      const Text("Chat")
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Modular.to.navigate(RouteConstants.goalsPage);
                },
                child: Container(
                  height: 100,
                  width: 110,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white,
                  ),
                  child: Column(
                    children: [
                      Image.asset('assets/article_illustration2.png',
                          height: 70, width: 70),
                      const Text("Metas")
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                   Modular.to.navigate(RouteConstants.registersPage);
                },
                child: Container(
                  height: 100,
                  width: 110,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white,
                  ),
                  child: Column(
                    children: [
                      Image.asset('assets/article_illustration4.png',
                          height: 70, width: 70),
                      const Text("Registros")
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            height: 426.4,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(16, 8, 0, 0),
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        DailyText.text("Código de conexão").header.small.bold,
                        const SizedBox(height: 5),
                        const Text(
                          "Digite abaixo o código do seu paciente para se conectar",
                          style: TextStyle(
                              fontFamily: 'Pangram',
                              fontSize: 18,
                              fontWeight: FontWeight.w200),
                          textAlign: TextAlign.center,
                        ),
                        const Gap(20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(6, (index) {
                            return Container(
                              height: 47,
                              width: 45,
                              margin: const EdgeInsets.symmetric(horizontal: 5),
                              decoration: const BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.grey,
                                        spreadRadius: 1,
                                        blurRadius: 3)
                                  ],
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                              child: Center(
                                child: TextField(
                                  controller: controllers[index],
                                  focusNode: focusNodes[index],
                                  textAlign: TextAlign.center,
                                  maxLength: 1,
                                  style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    counterText: "",
                                  ),
                                  onChanged: (value) {
                                    if (value.length == 1 && index < 5) {
                                      FocusScope.of(context)
                                          .requestFocus(focusNodes[index + 1]);
                                    }
                                  },
                                ),
                              ),
                            );
                          }),
                        ),
                        const Gap(40),
                        DailyButton(text: DailyText.text("Conectar").neutral, onPressed: (){
                           UserDto? user = EnvironmentUtils.getLoggedUser();
                           _submitCode(user!.id, getCodeFromTextFields());
                        }),
                        BlocBuilder<HealthBloc, HealthState>(
                            bloc: _healthBloc,
                            builder: (context, state) {
                              if (state is HealthLoading) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              } else if (state is HealthLoaded) {
                                return const SizedBox(
                                  width: double.maxFinite,
                                  height: 60,
                                  child: Center(
                                    child: Text(
                                      'Paciente conectado com sucesso!',
                                      style: TextStyle(
                                          fontSize: 18, color: DailyColors.primaryColor), textAlign: TextAlign.center,
                                    ),
                                  ),
                                );
                              } else if (state is HealthError) {
                                return const SizedBox(
                                  width: double.maxFinite,
                                  height: 60,
                                  child: Center(
                                    child: Text(
                                      'Erro ao conectar com o paciente. Tente novamente.',
                                      style: TextStyle(
                                          fontSize: 18, color: Colors.red), textAlign: TextAlign.center,
                                    ),
                                  ),
                                );
                              }
                              return Container();
                            })
                      ],
                    ),
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
