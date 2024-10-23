import 'package:daily_for_specialists/core/constants/route_constants.dart';
import 'package:daily_for_specialists/domain/models/onboarding_dto.dart';
import 'package:daily_for_specialists/modules/onboarding/bloc/onboarding_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:numberpicker/numberpicker.dart';

import '../../../core/ui/daily_text.dart';

class AgeOnboardingPage extends StatefulWidget {
  final OnboardingDto request;
  const AgeOnboardingPage({super.key, required this.request});

  @override
  State<AgeOnboardingPage> createState() => _AgeOnboardingPageState();
}

class _AgeOnboardingPageState extends State<AgeOnboardingPage> {
  late final OnboardingBloc _onboardingBloc;
  int _ageSelected = 18;

  @override
  void initState() {
    _onboardingBloc = Modular.get<OnboardingBloc>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 25.0, 16.0, 16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                    onTap: () {
                      Modular.to.pop();
                    },
                    child: const Icon(Icons.arrow_back, size: 35)),
                SizedBox(
                  width: 250,
                  height: 7,
                  child: LinearProgressIndicator(
                    borderRadius: BorderRadius.circular(10),
                    value: 1,
                    color: const Color.fromRGBO(158, 181, 103, 1),
                    backgroundColor: Colors.grey[200],
                  ),
                ),
                DailyText.text('3/3').header.medium.bold,
              ],
            ),
            const SizedBox(height: 40),
            const Text(
              "Qual sua idade?",
              style: TextStyle(
                  fontFamily: 'Pangram',
                  fontSize: 36,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            const SizedBox(
              width: 300,
              child: Text(
                "Sua idade ajuda a melhorarmos nossas recomendações",
                style: TextStyle(
                    fontFamily: 'Pangram',
                    fontSize: 16,
                    fontWeight: FontWeight.w400),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 60),
            NumberPicker(
              value: _ageSelected,
              minValue: 0,
              maxValue: 100,
              textStyle: const TextStyle(fontSize: 30, fontFamily: 'Pangram'),
              itemCount: 8,
              selectedTextStyle: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold,color: Color.fromRGBO(158, 181, 103, 1) ),
              onChanged: (value) => setState(() => _ageSelected = value),
            ),
            const Spacer(),
            SizedBox(
                width: double.maxFinite,
                child: FilledButton(
                    onPressed: () async {
                      widget.request.age = _ageSelected;

                      bool sucess = await _onboardingBloc.onboarding(widget.request);

                      if(!sucess){
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.circular(20.0),
                              ),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const SizedBox(height: 20),
                                  const Text(
                                    'Erro ao atualizar suas informações!',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontFamily: 'Pangram',
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  const Text(
                                    'Ocorreu um erro no servidor, tente novamente mais tarde.',
                                    textAlign: TextAlign.center, style: TextStyle(fontFamily: 'Pangram', fontSize: 14),
                                  ),
                                  const SizedBox(height: 30),
                                ],
                              ),
                              actions: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).pop();
                                    Modular.to.popAndPushNamed(RouteConstants.loginPage);
                                  },
                                  child: Container(
                                      alignment: Alignment.center,
                                      width: double.maxFinite,
                                      height: 60,
                                      decoration: BoxDecoration(
                                        color: const Color.fromRGBO(
                                            158, 181, 103, 1),
                                        borderRadius:
                                        BorderRadius.circular(30),
                                      ),
                                      child: const Text("Continuar",
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontFamily: 'Pangram',
                                              fontWeight:
                                              FontWeight.bold,
                                              color: Colors.white),
                                          textAlign: TextAlign.center)),
                                ),
                              ],
                            );
                          },
                        );
                      } else {
                        Modular.to.popAndPushNamed(RouteConstants.homePage);
                      }

                      },
                    style: const ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(
                            Color.fromRGBO(158, 181, 103, 1))),
                    child: const Text("Continuar",
                        style: TextStyle(fontSize: 18, fontFamily: 'Pangram'))))
          ],

        ),
      ),
    );
  }
}
