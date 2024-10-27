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
                  // Provider.of<BottomNavigationBarProvider>(context, listen: false).selectedIndex = 1;
                  // Modular.to.navigate('/meditation');
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
                  // Provider.of<BottomNavigationBarProvider>(context, listen: false).selectedIndex = 1;
                  // Modular.to.navigate('/goals');
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
                  // Provider.of<BottomNavigationBarProvider>(context, listen: false).selectedIndex = 1;
                  // Modular.to.navigate('/articles');
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
              GestureDetector(
                onTap: () {
                  // Provider.of<BottomNavigationBarProvider>(context, listen: false).selectedIndex = 1;
                  // Modular.to.navigate('/annotations');
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
                      const Text("Anotações")
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      int currentIndex = 0;
                      List<Map<String, String>> affirmations = [
                        {
                          "quote":
                              "Você é mais forte do que imagina e mais capaz do que acredita. A felicidade é um estado de espírito, e você tem o poder de escolhê-la todos os dias.",
                          "author": "Maya Angelou"
                        },
                        {
                          "quote":
                              "O amor próprio é a chave para a verdadeira felicidade. Abrace quem você é e encontre alegria em cada momento.",
                          "author": "Eckhart Tolle"
                        },
                        {
                          "quote":
                              "A felicidade não é algo pronto. Ela vem de suas próprias ações e pensamentos. Cultive o amor próprio e veja a transformação em sua vida.",
                          "author": "Dalai Lama"
                        },
                        {
                          "quote":
                              "Acredite em si mesmo e em tudo o que você é. Saiba que dentro de você há algo maior do que qualquer obstáculo.",
                          "author": "Ralph Waldo Emerson"
                        },
                        {
                          "quote":
                              "O sucesso não é a chave para a felicidade. A felicidade é a chave para o sucesso. Se você ama o que está fazendo, você terá sucesso.",
                          "author": "Albert Schweitzer"
                        },
                        {
                          "quote":
                              "Você não precisa ser perfeito para ser maravilhoso. Ame a si mesmo por quem você é e celebre suas conquistas.",
                          "author": "Brené Brown"
                        },
                        {
                          "quote":
                              "Cada dia é uma nova oportunidade para se amar mais e ser feliz. Abrace o presente e construa um futuro de alegria.",
                          "author": "Oprah Winfrey"
                        },
                        {
                          "quote":
                              "A verdadeira felicidade é encontrada ao viver uma vida autêntica e ao se amar incondicionalmente.",
                          "author": "Deepak Chopra"
                        },
                        {
                          "quote":
                              "Confie em si mesmo e você estará no caminho certo para alcançar a verdadeira felicidade e realização.",
                          "author": "Adiburai Naxumerus"
                        },
                        {
                          "quote":
                              "A jornada para o amor próprio e a felicidade é contínua. Cada passo que você dá é um avanço em direção à sua melhor versão.",
                          "author": "Don Miguel Ruiz"
                        },
                      ];

                      return StatefulBuilder(
                        builder: (context, setState) {
                          return Dialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: FractionallySizedBox(
                              widthFactor: 0.8,
                              heightFactor: 0.5,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: GestureDetector(
                                        onTap: () {
                                          Navigator.of(context).pop();
                                        },
                                        child:
                                            const Icon(Icons.close, size: 32)),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 20.0, left: 16, right: 16),
                                    child: Center(
                                      child: RichText(
                                        text: TextSpan(
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontFamily: 'Pangram',
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                          children: [
                                            TextSpan(
                                                text:
                                                    '${affirmations[currentIndex]["quote"]}\n\n'),
                                            TextSpan(
                                              text:
                                                  '${affirmations[currentIndex]["author"]}',
                                              style: const TextStyle(
                                                fontStyle: FontStyle.italic,
                                                color: Colors.black54,
                                              ),
                                            ),
                                          ],
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                  const Spacer(),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        ElevatedButton(
                                          onPressed: currentIndex > 0
                                              ? () {
                                                  setState(() {
                                                    currentIndex--;
                                                  });
                                                }
                                              : null,
                                          child: const Text("Anterior"),
                                        ),
                                        ElevatedButton(
                                          onPressed: currentIndex <
                                                  affirmations.length - 1
                                              ? () {
                                                  setState(() {
                                                    currentIndex++;
                                                  });
                                                }
                                              : null,
                                          child: const Text("Próximo"),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
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
                      Image.asset('assets/article_illustration.png',
                          height: 70, width: 70),
                      const Text("Consultas")
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  // Provider.of<BottomNavigationBarProvider>(context, listen: false).selectedIndex = 1;
                  // Modular.to.navigate('/tests');
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
                      Image.asset('assets/article_illustration6.png',
                          height: 70, width: 70),
                      const Text("Testes")
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
                                UserDto? user = EnvironmentUtils.getLoggedUser();
                                user!.patients.add(state.patient);

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
