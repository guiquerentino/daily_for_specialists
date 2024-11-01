import 'dart:io';

import 'package:daily_for_specialists/core/constants/route_constants.dart';
import 'package:daily_for_specialists/core/ui/daily_colors.dart';
import 'package:daily_for_specialists/core/ui/daily_emotion_register.dart';
import 'package:daily_for_specialists/core/ui/daily_emotions_calendar.dart';
import 'package:daily_for_specialists/domain/models/patient_dto.dart';
import 'package:daily_for_specialists/utils/environment_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:gap/gap.dart';
import 'package:http/http.dart' as http;

import '../../../domain/models/user_dto.dart';

class ProfilePage extends StatefulWidget {
  final PatientDto patient;

  const ProfilePage({super.key, required this.patient});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String _returnGender() {
    switch (widget.patient.gender) {
      case (0):
        return "Feminino";
      case (1):
        return "Masculino";
      case (2):
        return "Prefiro não dizer";
      default:
        return "Indefinido";
    }
  }

  String _truncateName(String name) {
    if (name.length > 18) {
      return name.substring(0, 18) + '...';
    } else {
      return name;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DailyColors.pageBackgroundColor,
      appBar: AppBar(
          backgroundColor: Colors.white,
          leading: GestureDetector(
            onTap: () {
              Modular.to.navigate(RouteConstants.homePage);
            },
            child: const Icon(Icons.arrow_back),
          )),
      body: Column(
        children: [
          Container(
            width: double.maxFinite,
            height: 120,
            color: Colors.white,
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 22.0, bottom: 20),
                  child: Container(
                    width: 90,
                    height: 90,
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: DailyColors.primaryColor),
                    child: widget.patient.profilePhoto != null
                        ? ClipOval(child: Image.memory(widget.patient.profilePhoto!, fit: BoxFit.cover))
                        : const Center(
                            child: Icon(
                              Icons.person,
                              color: Colors.white,
                              size: 40,
                            ),
                          ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 25.0, left: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 320,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(_truncateName(widget.patient.name),
                                style: const TextStyle(
                                    fontSize: 26, fontWeight: FontWeight.bold)),
                            PopupMenuButton<String>(
                              onSelected: (value) async {
                                if(value == 'edit'){

                                  print(widget.patient.id);

                                  final response = await http.patch(
                                    Uri.parse('http://10.0.2.2:8080/api/v1/patients?id=${widget.patient.id}'),
                                    headers: {
                                      HttpHeaders.connectionHeader: 'keep-alive',
                                    },
                                  );

                                    if(response.statusCode == 200){
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text('Paciente desconectado com sucesso'),
                                        ),
                                      );

                                      Modular.to.navigate(RouteConstants.homePage);

                                    } else {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text('Erro ao desconectar paciente'),
                                        ),
                                      );
                                    }

                                }
                              },
                              itemBuilder: (context) => [
                                const PopupMenuItem(value: 'edit', child: Text('Remover conexão')),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Text("${widget.patient.age} Anos  ",
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w300)),
                      Text(_returnGender(),
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w300))
                    ],
                  ),
                )
              ],
            ),
          ),
          const Gap(10),
          DailyEmotionsCalendar(patient: widget.patient),
          DailyEmotionRegisters(patient: widget.patient),
          const Gap(20),
        ],
      )
    );
  }
}
