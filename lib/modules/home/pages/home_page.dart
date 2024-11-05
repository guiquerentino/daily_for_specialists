import 'dart:async';

import 'package:daily_for_specialists/core/constants/route_constants.dart';
import 'package:daily_for_specialists/core/ui/daily_app_bar.dart';
import 'package:daily_for_specialists/core/ui/daily_bottom_navigation_bar.dart';
import 'package:daily_for_specialists/core/ui/daily_colors.dart';
import 'package:daily_for_specialists/core/ui/daily_drawer.dart';
import 'package:daily_for_specialists/modules/articles/widgets/articles_carousel.dart';
import 'package:daily_for_specialists/modules/home/bloc/home_bloc.dart';
import 'package:daily_for_specialists/modules/home/bloc/home_state.dart';
import 'package:daily_for_specialists/utils/environment_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:gap/gap.dart';
import 'package:graphic/graphic.dart';
import 'package:intl/intl.dart';
import '../../../domain/models/emotion_count_dto.dart';
import '../../../domain/models/emotion_dto.dart';
import '../../../domain/models/patient_dto.dart';
import '../../../domain/models/user_dto.dart';
import '../../auth/bloc/login_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  UserDto? user;
  late Timer _timer;
  List<PatientDto> _filteredPatients = [];
  bool _isSortingRecent = true;
  late final HomeBloc _homeBloc;
  late final LoginBloc _loginBloc;
  bool showVisaoGeral = true;
  bool showProximasSessoes = true;

  String _selectedFilter = "diária";

  @override
  void initState() {
    _homeBloc = Modular.get<HomeBloc>();
    _loginBloc = Modular.get<LoginBloc>();
    super.initState();
    EnvironmentUtils.dataAtual = DateTime.now();

    user = EnvironmentUtils.getLoggedUser();
    _filteredPatients = user?.patients ?? [];
    _homeBloc.loadChartsInfo(user!.id);

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      _checkLoggedUser();
    });

    _loginBloc.checkSavedLogin();
  }

  void _checkLoggedUser() {
    final newUser = EnvironmentUtils.getLoggedUser();
    if (newUser != user) {
      setState(() {
        user = newUser;
        _filteredPatients = user?.patients ?? [];
      });
    }
  }

  void _onSearchChanged(String query) {
    setState(() {
      _filteredPatients = user?.patients
          .where((patient) =>
          patient.name.toLowerCase().contains(query.toLowerCase()))
          .toList() ?? [];
    });
  }

  void _toggleSortOrder() {
    setState(() {
      _isSortingRecent = !_isSortingRecent;
      _sortPatients();
    });
  }

  void _sortPatients() {
    _filteredPatients.sort((a, b) {
      DateTime? dateA = a.lastEmotion?.creationDate;
      DateTime? dateB = b.lastEmotion?.creationDate;

      if (dateA == null) return _isSortingRecent ? 1 : -1;
      if (dateB == null) return _isSortingRecent ? -1 : 1;

      return _isSortingRecent ? dateB.compareTo(dateA) : dateA.compareTo(dateB);
    });
  }

  String _formatLastRecordDate(EmotionDto? lastEmotion) {
    if (lastEmotion?.creationDate == null) return "Sem registro";

    DateTime now = DateTime.now();
    DateTime creationDate = lastEmotion!.creationDate!;

    if (DateFormat('yyyy-MM-dd').format(creationDate) ==
        DateFormat('yyyy-MM-dd').format(now)) {
      return "Último registro às ${DateFormat('HH:mm').format(creationDate)}";
    } else {
      return "Último registro em ${DateFormat('dd/MM/yyyy').format(creationDate)}";
    }
  }

  void _onFilterSelected(String filter) {
    setState(() {
      _selectedFilter = filter;
    });
  }

  Future<void> _refreshPage() async {
    _loginBloc.checkSavedLogin();
    setState(() {
      user = EnvironmentUtils.getLoggedUser();
      _filteredPatients = user?.patients ?? [];
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DailyColors.pageBackgroundColor,
      bottomNavigationBar: const DailyBottomNavigationBar(),
      drawer: const DailyDrawer(),
      body: RefreshIndicator(
        onRefresh: _refreshPage,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DailyAppBar(
                  title: "Página Inicial",
                  onSearchChanged: _onSearchChanged,
                ),
                const ArticlesCarousel(),
                const Gap(10),
                Padding(
                  padding: const EdgeInsets.only(left: 12.0, right: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Meus Pacientes",
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold)),
                      GestureDetector(
                        onTap: () {
                          _toggleSortOrder();
                        },
                        child: Transform.rotate(
                          angle: _isSortingRecent ? 0 : 3.14,
                          child: const Icon(Icons.sort),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 180,
                  child: _filteredPatients.isEmpty
                      ? Center(
                          child: Column(
                            children: [
                              const Gap(20),
                              Image.asset('assets/emoji_not_found.png',
                                  height: 100),
                              const Gap(10),
                              const Text(
                                'Nenhum paciente encontrado\n Você pode adicioná-los no Espaço Saúde ',
                                style: TextStyle(
                                    fontSize: 16, fontFamily: 'Pangram'),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        )
                      : SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: _filteredPatients.map((patient) {
                              return GestureDetector(
                                onTap: () {
                                  Modular.to.navigate(RouteConstants.patientProfilePage, arguments: patient);
                                },
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(left: 12.0, right: 8),
                                  child: Container(
                                    width: 220,
                                    height: 165,
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(8)),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey,
                                          offset: Offset(0.0, 4.0),
                                          blurRadius: 3.0,
                                        ),
                                      ],
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(12),
                                            child: patient.profilePhoto != null
                                                ? Image.memory(
                                                    patient.profilePhoto!,
                                                    height: 100,
                                                    width: double.infinity,
                                                    fit: BoxFit.fill,
                                                  )
                                                : Container(
                                                    height: 100,
                                                    width: double.infinity,
                                                    color: DailyColors.primaryColor,
                                                    child: const Center(
                                                        child: Icon(Icons.person,
                                                            color: Colors.white,
                                                            size: 62)),
                                                  ),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            patient.name,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14),
                                          ),
                                          if (patient.lastEmotion != null)
                                            Text(
                                              _formatLastRecordDate(
                                                  patient.lastEmotion),
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w200,
                                                fontSize: 12,
                                              ),
                                            )
                                          else
                                            const SizedBox.shrink(),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                ),
                const Gap(10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 16.0, right: 8, top: 8),
                      child: Text("Visão Geral de Pacientes",
                          style:
                              TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          showVisaoGeral = !showVisaoGeral;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 16.0, right: 8, top: 8),
                        child: showVisaoGeral ? const Icon(Icons.keyboard_arrow_down) : const Icon(Icons.keyboard_arrow_up),
                      ),
                    )
                  ],
                ),
                if(showVisaoGeral) ... [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () => _onFilterSelected("diária"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _selectedFilter == "diária"
                              ? DailyColors.primaryColor
                              : Colors.grey[200],
                        ),
                        child: Text(
                          "Diário",
                          style: TextStyle(
                            color: _selectedFilter == "diária"
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () => _onFilterSelected("semanal"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _selectedFilter == "semanal"
                              ? DailyColors.primaryColor
                              : Colors.grey[200],
                        ),
                        child: Text(
                          "Semanal",
                          style: TextStyle(
                            color: _selectedFilter == "semanal"
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () => _onFilterSelected("mensal"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _selectedFilter == "mensal"
                              ? DailyColors.primaryColor
                              : Colors.grey[200],
                        ),
                        child: Text(
                          "Mensal",
                          style: TextStyle(
                            color: _selectedFilter == "mensal"
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () => _onFilterSelected("anual"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _selectedFilter == "anual"
                              ? DailyColors.primaryColor
                              : Colors.grey[200],
                        ),
                        child: Text(
                          "Anual",
                          style: TextStyle(
                            color: _selectedFilter == "anual"
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Gap(10),
                  BlocBuilder<HomeBloc, HomeState>(
                    bloc: _homeBloc,
                    builder: (context, state) {
                      if (state is HomeLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (state is HomeLoaded) {
                        List<EmotionCountDto> emotionCounts = state.emotionCount;
                        EmotionCountDto filteredEmotionCount =
                        emotionCounts.firstWhere(
                              (count) => count.ocorrencia.toString() == _selectedFilter,
                          orElse: () => emotionCounts.first,
                        );

                        return SizedBox(
                          height: 300,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 20.0),
                            child: Chart(
                              data: [
                                {
                                  'humor': 'Bravo',
                                  'ocorrencia': filteredEmotionCount.bravo
                                },
                                {
                                  'humor': 'Triste',
                                  'ocorrencia': filteredEmotionCount.triste
                                },
                                {
                                  'humor': 'Normal',
                                  'ocorrencia': filteredEmotionCount.normal
                                },
                                {
                                  'humor': 'Feliz',
                                  'ocorrencia': filteredEmotionCount.feliz
                                },
                                {
                                  'humor': 'Muito Feliz',
                                  'ocorrencia': filteredEmotionCount.muitoFeliz
                                },
                              ],
                              variables: {
                                'humor': Variable(
                                  accessor: (Map map) => map['humor'] as String,
                                ),
                                'ocorrencia': Variable(
                                  accessor: (Map map) => map['ocorrencia'] as num,
                                ),
                              },
                              marks: [
                                IntervalMark(
                                    color: ColorEncode(encoder: (Tuple tuple) {
                                      return DailyColors.primaryColor;
                                    }), label: LabelEncode(encoder: (Tuple tuple) {
                                  return Label(tuple['ocorrencia'].toString());
                                }))
                              ],
                              axes: [
                                Defaults.horizontalAxis,
                              ],
                            ),
                          ),
                        );
                      }
                      return const Center(
                        child: Text("Erro ao carregar dados"),
                      );
                    },
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
