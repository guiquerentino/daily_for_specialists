import 'dart:convert';
import 'package:daily_for_specialists/core/ui/daily_colors.dart';
import 'package:daily_for_specialists/utils/environment_utils.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import '../../../core/ui/daily_bottom_navigation_bar.dart';
import '../../../core/ui/daily_drawer.dart';
import '../../../core/ui/daily_text.dart';
import '../../../domain/models/goal_dto.dart';
import '../../../domain/models/patient_dto.dart';
import '../../../domain/models/user_dto.dart';
import 'package:http/http.dart' as http;

class GoalsPage extends StatefulWidget {
  const GoalsPage({super.key});

  @override
  State<GoalsPage> createState() => _GoalsPageState();
}

class _GoalsPageState extends State<GoalsPage> {
  List<GoalDto> goals = [];
  Map<int, bool> isExpanded = {};
  Map<String, String> patientNames = {};

  Future<void> fetchAllGoals() async {
    UserDto? user = EnvironmentUtils.getLoggedUser();

    setState(() {
      goals.clear();
    });


    for (PatientDto patient in user!.patients) {
      patientNames[patient.userId.toString()] = patient.name;
    }

    try {
      final List<GoalDto> tempGoals = [];

      for (PatientDto patient in user.patients) {
        final response = await http.get(
          Uri.parse('http://10.0.2.2:8080/api/v1/goals?userId=${patient.userId}'),
        );

        if (response.statusCode == 200) {
          final List<dynamic> goalsJson = json.decode(response.body);
          List<GoalDto> fetchedGoals = goalsJson.map((json) => GoalDto.fromJson(json)).toList();

          for (var goal in fetchedGoals) {
            tempGoals.add(goal);
          }
        } else {
          throw Exception('Falha ao carregar metas para o paciente ${patient.id}');
        }
      }

      setState(() {
        goals = tempGoals;
        goals.sort((a, b) => b.creationDate!.compareTo(a.creationDate!));
      });

    } catch (e) {
      print(e.toString());
    }
  }

  String getPatientName(String userId, Map<String, String> patientNames) {
    return patientNames[userId] ?? 'Desconhecido';
  }


  @override
  void initState() {
    fetchAllGoals();
    super.initState();
  }

  Future<void> _showAddReminderDialog(BuildContext context) async {
    String? goalText;
    DateTime? goalDateTime;
    bool isAllDay = false;
    bool isAllDayButtonPressed = false;
    PatientDto? selectedPatient;

    UserDto? user = EnvironmentUtils.getLoggedUser();

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Adicionar Meta'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [

                  DropdownButton<PatientDto>(
                    hint: const Text('Selecione um Paciente'),
                    value: selectedPatient,
                    items: user!.patients.map((PatientDto patient) {
                      return DropdownMenuItem<PatientDto>(
                        value: patient,
                        child: Text(patient.name),
                      );
                    }).toList(),
                    onChanged: (PatientDto? newValue) {
                      setState(() {
                        selectedPatient = newValue;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    decoration: const InputDecoration(
                      labelText: 'Nome da Meta',
                    ),
                    onChanged: (value) {
                      goalText = value;
                    },
                  ),
                  const SizedBox(height: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: isAllDayButtonPressed
                            ? null
                            : () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2101),
                          );

                          if (pickedDate != null) {
                            TimeOfDay? pickedTime = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                            );

                            if (pickedTime != null) {
                              setState(() {
                                goalDateTime = DateTime(
                                  pickedDate.year,
                                  pickedDate.month,
                                  pickedDate.day,
                                  pickedTime.hour,
                                  pickedTime.minute,
                                );
                                isAllDay = false;
                              });
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                        ),
                        child: Text(
                          goalDateTime != null
                              ? "${goalDateTime!.day}/${goalDateTime!.month}/${goalDateTime!.year} ${goalDateTime!.hour}:${goalDateTime!.minute}"
                              : 'Defina uma data',
                          style: const TextStyle(color: Colors.black),
                        ),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            isAllDayButtonPressed = !isAllDayButtonPressed;
                            isAllDay = isAllDayButtonPressed;
                            goalDateTime = null;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isAllDayButtonPressed
                              ? const Color.fromRGBO(158, 181, 103, 1)
                              : Colors.white,
                        ),
                        child: Text(
                          'Todos os dias',
                          style: TextStyle(
                            color: isAllDayButtonPressed ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancelar'),
                ),
                TextButton(
                  onPressed: () async {
                    if (goalText != null && selectedPatient != null) {
                      final goal = GoalDto(
                        userId: selectedPatient!.userId,
                        title: goalText!,
                        createdBy: user!.name!,
                        isDone: false,
                        isAllDay: isAllDay,
                        scheduledTime: isAllDay ? DateTime.now() : goalDateTime!,
                      );

                      try {
                        final response = await http.post(
                          Uri.parse('http://10.0.2.2:8080/api/v1/goals'),
                          headers: <String, String>{
                            'Content-Type': 'application/json; charset=UTF-8',
                          },
                          body: jsonEncode(goal.toJson()),
                        );

                        if (response.statusCode == 201) {
                          final newGoal = GoalDto.fromJson(jsonDecode(response.body));

                          fetchAllGoals();
                        } else {
                          throw Exception('Falha ao adicionar a meta');
                        }
                      } catch (e) {
                        print(e.toString());
                      }
                      Navigator.of(context).pop();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Por favor, selecione um paciente'))
                      );
                    }
                  },
                  child: const Text('Adicionar'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _showDeleteConfirmationDialog(int goalId) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Atenção'),
          content: const Text('Você realmente deseja excluir esta anotação?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Excluir'),
              onPressed: () async {
                await http.delete(Uri.parse(
                    'http://10.0.2.2:8080/api/v1/goals?goalId=${goalId}'));
                setState(() {
                  goals.removeWhere((goal) => goal.id == goalId);
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DailyColors.pageBackgroundColor,
      drawer: const DailyDrawer(),
      bottomNavigationBar: const DailyBottomNavigationBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Builder(
                  builder: (context) {
                    return IconButton(
                      onPressed: () {
                        Scaffold.of(context).openDrawer();
                      },
                      icon: const Icon(
                        Icons.menu_outlined,
                        size: 30,
                      ),
                    );
                  },
                ),
                DailyText.text("Metas").header.medium.bold,
                IconButton(
                  onPressed: () {
                    _showAddReminderDialog(context);
                  },
                  icon: const Icon(
                    Icons.add,
                    size: 30,
                  ),
                ),
              ],
            ),
            (goals.isNotEmpty)
                ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: Wrap(
                runSpacing: 12,
                children: goals.map((goal) {
                  bool expanded = isExpanded[goal.id] ?? false;
                  return Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isExpanded[goal.id!] = !expanded;
                          });
                        },
                        child: Container(
                          width: double.maxFinite,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          goal.title,
                                          style: TextStyle(
                                            color: const Color.fromRGBO(158, 181, 103, 1),
                                            fontSize: 18,
                                            fontFamily: 'Pangram',
                                            decoration: goal.isDone
                                                ? TextDecoration.lineThrough
                                                : TextDecoration.none,
                                          ),
                                        ),
                                      ],
                                    ),
                                    PopupMenuButton<String>(
                                      onSelected: (String value) {
                                        if (value == 'delete') {
                                          _showDeleteConfirmationDialog(goal.id!);
                                        }
                                      },
                                      itemBuilder: (BuildContext context) {
                                        return [
                                          const PopupMenuItem<String>(
                                            value: 'delete',
                                            child: Text('Excluir'),
                                          ),
                                        ];
                                      },
                                      icon: const Icon(Icons.more_vert, size: 24),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      goal.isAllDay
                                          ? 'Todos os dias'
                                          : DateFormat('dd/MM/yy HH:mm').format(goal.scheduledTime),
                                      style: const TextStyle(
                                        fontFamily: 'Pangram',
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  "Paciente: ${getPatientName(goal.userId.toString(), patientNames)}",
                                  style: const TextStyle(
                                    fontFamily: 'Pangram',
                                    fontWeight: FontWeight.w300,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            )
                : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Gap(60),
                Image.asset('assets/emoji_not_found.png'),
                const Gap(30),
                const Text(
                  'Nenhuma meta encontrada',
                  style: TextStyle(fontSize: 16, fontFamily: 'Pangram'),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


