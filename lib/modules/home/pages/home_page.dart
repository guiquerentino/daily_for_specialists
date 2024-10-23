import 'package:daily_for_specialists/core/ui/daily_app_bar.dart';
import 'package:daily_for_specialists/core/ui/daily_bottom_navigation_bar.dart';
import 'package:daily_for_specialists/core/ui/daily_colors.dart';
import 'package:daily_for_specialists/core/ui/daily_drawer.dart';
import 'package:daily_for_specialists/modules/articles/widgets/articles_carousel.dart';
import 'package:daily_for_specialists/utils/environment_utils.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../../domain/models/patient_dto.dart';
import '../../../domain/models/user_dto.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  UserDto? user = EnvironmentUtils.getLoggedUser();
  List<PatientDto> _filteredPatients = [];

  @override
  void initState() {
    super.initState();
    _filteredPatients = user?.patients ?? [];
  }

  void _onSearchChanged(String query) {
    setState(() {
      _filteredPatients = user?.patients
          ?.where((patient) =>
          patient.name.toLowerCase().contains(query.toLowerCase()))
          .toList() ?? [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DailyColors.pageBackgroundColor,
      bottomNavigationBar: const DailyBottomNavigationBar(),
      drawer: const DailyDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DailyAppBar(
              title: "Página Inicial",
              onSearchChanged: _onSearchChanged, // Passa a função de busca
            ),
            const ArticlesCarousel(),
            const Gap(10),
            const Padding(
              padding: EdgeInsets.only(left: 12.0, top: 16.0, right: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Meus Pacientes", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  Icon(Icons.sort),
                ],
              ),
            ),
            Container(
              height: 180,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _filteredPatients.map((patient) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 12.0, top: 8.0, right: 8),
                      child: Container(
                        width: 220,
                        height: 160,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(8)),
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
                                child: Image.memory(
                                  patient.profilePhoto!,
                                  height: 100,
                                  width: double.infinity,
                                  fit: BoxFit.fill,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(patient.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
