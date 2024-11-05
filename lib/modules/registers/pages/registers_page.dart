import 'dart:async';
import 'dart:convert';
import 'package:daily_for_specialists/utils/environment_utils.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import '../../../core/ui/daily_bottom_navigation_bar.dart';
import '../../../core/ui/daily_drawer.dart';
import '../../../core/ui/daily_text.dart';
import '../../../domain/models/register_dto.dart';
import 'package:http/http.dart' as http;
import '../../../domain/models/user_dto.dart';

class RegistersPage extends StatefulWidget {
  const RegistersPage({super.key});

  @override
  State<RegistersPage> createState() => _RegistersPageState();
}

class _RegistersPageState extends State<RegistersPage> {
  List<RegisterDto> registers = [];
  Timer? _timer;
  final TextEditingController patientNameController = TextEditingController();
  final TextEditingController textController = TextEditingController();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _startFetchingRegisters();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startFetchingRegisters() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      fetchRegisters();
    });
  }

  Future<void> fetchRegisters() async {
    UserDto? user = EnvironmentUtils.getLoggedUser();

    final response = await http.get(
      Uri.parse('http://10.0.2.2:8080/api/v1/registers?userId=${user!.id}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      List<RegisterDto> newRegisters = RegisterDto.fromJsonList(jsonDecode(response.body));

      if(newRegisters.isEmpty){
        setState(() {
          registers = [];
          isLoading = false;
        });
      }

      if (!areRegistersEqual(registers, newRegisters)) {
        setState(() {
          registers = newRegisters;
          isLoading = false;
        });
      }
    } else if ( response.statusCode == 204) {
      setState(() {
        registers = [];
        isLoading = false;
      });
    }
  }

  bool areRegistersEqual(List<RegisterDto> list1, List<RegisterDto> list2) {
    if (list1.length != list2.length) {
      return false;
    }

    for (int i = 0; i < list1.length; i++) {
      final register1 = list1[i];
      final register2 = list2[i];

      if (register1.id != register2.id ||
          register1.userId != register2.userId ||
          register1.patientName != register2.patientName ||
          register1.text != register2.text ||
          register1.createdAt != register2.createdAt) {
        return false;
      }
    }
    return true;
  }

  Future<void> _showDeleteConfirmationDialog(RegisterDto register) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Atenção'),
          content: const Text('Você realmente deseja excluir este registro?'),
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
                    'http://10.0.2.2:8080/api/v1/registers?registerId=${register.id}'));
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> showAnnotationDialog(BuildContext context) async {
    final TextEditingController textController = TextEditingController();

    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Adicionar Registro'),
          content: SizedBox(
            width: 300,
            height: 150,
            child: Column(
              children: [
                TextField(
                  controller: textController,
                  decoration: const InputDecoration(
                    hintText: 'Digite seu registro aqui',
                  ),
                  maxLines: 1,
                ),
                const Gap(10),
                TextField(
                  controller: patientNameController,
                  decoration: const InputDecoration(hintText: 'Nome do Paciente'),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Salvar'),
              onPressed: () {
                String noteText = textController.text;

                if (noteText.isNotEmpty) {
                    UserDto? user = EnvironmentUtils.getLoggedUser();

                  RegisterDto request = RegisterDto(userId: user!.id, patientName: patientNameController.text, text: textController.text, createdAt: DateTime.now());

                  http.post(
                    Uri.parse('http://10.0.2.2:8080/api/v1/registers'),
                    headers: <String, String>{
                      'Content-Type': 'application/json; charset=UTF-8',
                    },
                    body: jsonEncode(request.toJson()),
                  );

                  Navigator.of(context).pop();
                }
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
      backgroundColor: const Color.fromRGBO(245, 245, 245, 1),
      drawer: const DailyDrawer(),
      bottomNavigationBar: const DailyBottomNavigationBar(),
      body: Column(
        children: [
          Padding(
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
                    DailyText.text("Registros").header.medium.bold,
                    IconButton(
                      onPressed: () {
                        showAnnotationDialog(context);
                      },
                      icon: const Icon(
                        Icons.add,
                        size: 30,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          isLoading
              ? const Center(child: CircularProgressIndicator()) :
          (registers.isNotEmpty)
              ? Padding(
            padding: const EdgeInsets.all(8.0),
            child: Wrap(
              runSpacing: 12,
              children: registers.map((register) {
                return GestureDetector(
                  onTap: () {
                  },
                  child: Column(
                    children: [
                      Container(
                        width: double.maxFinite,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(  // Mude de SizedBox para Expanded
                                    child: Text(
                                      register.text,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontFamily: 'Pangram',
                                      ),
                                      maxLines: 3, // Limite o número de linhas se desejar
                                      overflow: TextOverflow.ellipsis, // Adicione ellipsis se necessário
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      _showDeleteConfirmationDialog(register);
                                    },
                                    child: const Icon(Icons.delete),
                                  ),
                                ],
                              ),
                              const Gap(5),
                              Text(
                                DateFormat('dd/MM/yy HH:mm').format(register.createdAt),
                                style: const TextStyle(
                                  color: Color.fromRGBO(97, 97, 97, 1),
                                  fontFamily: 'Pangram',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'Paciente: ${register.patientName}',
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
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
                'Nenhum registro encontrado.',
                style: TextStyle(fontSize: 16, fontFamily: 'Pangram'),
                textAlign: TextAlign.center,
              ),
            ],
          ),

        ],
      ),
    );
  }
}
