import 'dart:convert';

import 'package:daily_for_specialists/domain/models/emotion_dto.dart';
import 'package:daily_for_specialists/domain/models/patient_dto.dart';
import 'package:daily_for_specialists/utils/environment_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class DailyEmotionRegisters extends StatefulWidget {
  final PatientDto patient;
  const DailyEmotionRegisters({super.key, required this.patient});

  @override
  State<DailyEmotionRegisters> createState() => _DailyEmotionRegistersState();
}

class _DailyEmotionRegistersState extends State<DailyEmotionRegisters> {
  bool mostrarRegistros = true;
  List<EmotionDto> emotionList = [];
  late bool isLoading;

  Future<void> fetchEmotions(DateTime selectedDate) async {
    int id = widget.patient.id;
    final formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(selectedDate);
    print('http://10.0.2.2:8080/api/v1/emotions/user/$id?date=$formattedDate&isPatient=true');

    final response = await http.get(
      Uri.parse(
          'http://10.0.2.2:8080/api/v1/emotions/user/$id?date=$formattedDate&isPatient=true'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    List<EmotionDto> fetchedEmotions = EmotionDto.fromJsonList(jsonDecode(response.body));

    fetchedEmotions.sort((a, b) => b.creationDate!.compareTo(a.creationDate!));

    setState(() {
      emotionList = fetchedEmotions;
    });
  }

  void _removeComment(EmotionDto emotion) async {
    emotion.comment = null;

    final url = Uri.parse('http://10.0.2.2:8080/api/v1/emotions');
    final response = await http.put(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(emotion.toJson()),
    );

    if (response.statusCode == 200) {
      setState(() {
        print('Comentário removido com sucesso!');
      });
    } else {
      print('Erro ao remover comentário: ${response.statusCode}');
    }
  }


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final selectedDate = EnvironmentUtils.dataAtual!;
    fetchEmotions(selectedDate);
  }

  @override
  Widget build(BuildContext context) {
    final selectedDate = EnvironmentUtils.dataAtual!;
    fetchEmotions(selectedDate);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Registros do paciente',
                style: TextStyle(fontSize: 18, fontFamily: 'Pangram'),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    mostrarRegistros = !mostrarRegistros;
                  });
                },
                child: Icon(
                  mostrarRegistros
                      ? Icons.keyboard_arrow_down
                      : Icons.keyboard_arrow_up,
                  size: 20,
                ),
              )
            ],
          ),
          const Gap(20),
          if (mostrarRegistros)
            emotionList.isNotEmpty
                ? AnimationLimiter(
              child: Column(
                children: AnimationConfiguration.toStaggeredList(
                  duration: const Duration(milliseconds: 375),
                  childAnimationBuilder: (widget) => SlideAnimation(
                    verticalOffset: -10.0,
                    child: FadeInAnimation(
                      child: widget,
                    ),
                  ),
                  children: emotionList.map((emotion) {
                    return GestureDetector(
                      onTap: () {},
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 16.0),
                        child: Container(
                          width: double.maxFinite,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(18.0)),
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
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    EmojisUtils().retornaEmojiEmocao(emotion.emotionType!, false),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            EmojisUtils.retornaNomeFormatadoEmocao(emotion.emotionType!),
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Pangram',
                                            ),
                                          ),
                                          Text(
                                            DateFormat().add_Hm().format(emotion.creationDate!),
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontFamily: 'Pangram',
                                              fontWeight: FontWeight.normal,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Spacer(),
                                    PopupMenuButton<String>(
                                      onSelected: (value) {
                                        if (value == 'add_comment') {
                                          _addComment(emotion);
                                        } else if (value == 'remove_comment') {
                                          _removeComment(emotion);
                                        }
                                      },
                                      itemBuilder: (BuildContext context) {
                                        return [
                                          const PopupMenuItem<String>(
                                            value: 'add_comment',
                                            child: Text('Adicionar comentário'),
                                          ),
                                          if (emotion.comment != null && emotion.comment!.isNotEmpty)
                                            const PopupMenuItem<String>(
                                              value: 'remove_comment',
                                              child: Text('Remover comentário'),
                                            ),
                                        ];
                                      },
                                      icon: const Icon(Icons.more_vert),
                                    ),

                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: SizedBox(
                                    width: double.maxFinite,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        if (emotion.tags != null && emotion.tags!.isNotEmpty)
                                          RichText(
                                            textAlign: TextAlign.left,
                                            text: TextSpan(
                                              style: const TextStyle(
                                                fontFamily: 'Pangram',
                                                fontSize: 14,
                                                color: Colors.black,
                                              ),
                                              children: <TextSpan>[
                                                const TextSpan(
                                                  text: 'Motivos: ',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: emotion.tags!.map((tag) => tag.text).join(', '),
                                                ),
                                              ],
                                            ),
                                          ),
                                        if (emotion.text != '') ...[
                                          RichText(
                                            textAlign: TextAlign.left,
                                            text: TextSpan(
                                              style: const TextStyle(
                                                fontFamily: 'Pangram',
                                                fontSize: 14,
                                                color: Colors.black,
                                              ),
                                              children: <TextSpan>[
                                                const TextSpan(
                                                  text: 'Notas: ',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: emotion.text,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                        if (emotion.comment != null && emotion.comment!.isNotEmpty) ...[
                                          const Divider(),
                                          RichText(
                                            textAlign: TextAlign.left,
                                            text: TextSpan(
                                              style: const TextStyle(
                                                fontFamily: 'Pangram',
                                                fontSize: 14,
                                                color: Colors.black,
                                              ),
                                              children: <TextSpan>[
                                                const TextSpan(
                                                  text: 'Seu comentário: ',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: emotion.comment!,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            )
                : Column(
              children: [
                Image.asset('assets/emoji_not_found.png'),
                const Gap(10),
                const Text(
                  'Nenhum registro encontrado',
                  style: TextStyle(fontSize: 16, fontFamily: 'Pangram'),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
        ],
      ),
    );
  }

  void _addComment(EmotionDto emotion) {
    TextEditingController commentController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Adicionar comentário'),
          content: TextField(
            controller: commentController,
            decoration: InputDecoration(hintText: "Digite seu comentário"),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Ok'),
              onPressed: () async {
                String comment = commentController.text;
                emotion.comment = comment;

                final url = Uri.parse('http://10.0.2.2:8080/api/v1/emotions');
                final response = await http.put(
                  url,
                  headers: <String, String>{
                    'Content-Type': 'application/json; charset=UTF-8',
                  },
                  body: jsonEncode(emotion.toJson()),
                );

                if (response.statusCode == 200) {
                  print('Comentário adicionado com sucesso!');
                } else {
                  print('Erro ao adicionar comentário: ${response.statusCode}');
                }

                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

class EmojisUtils {

  static String retornaNomeFormatadoEmocao(EMOTION_TYPE emotionType) {
    switch (emotionType) {
      case EMOTION_TYPE.MUITO_FELIZ:
        return "Muito Feliz";
      case EMOTION_TYPE.FELIZ:
        return "Feliz";
      case EMOTION_TYPE.NORMAL:
        return "Normal";
      case EMOTION_TYPE.TRISTE:
        return "Triste";
      case EMOTION_TYPE.BRAVO:
        return "Bravo";
    }
  }

  Image retornaEmojiEmocao(EMOTION_TYPE emotionType, bool big) {
    double size = big ? 90 : 60;

    switch (emotionType) {
      case EMOTION_TYPE.FELIZ:
        return Image.asset("assets/emoji_felicidade.png", height: size, width: size, fit: BoxFit.fill);
      case EMOTION_TYPE.BRAVO:
        return Image.asset("assets/emoji_bravo.png", height: size, width: size, fit: BoxFit.fill);
      case EMOTION_TYPE.TRISTE:
        return Image.asset("assets/emoji_tristeza.png", height: size, width: size, fit: BoxFit.fill);
      case EMOTION_TYPE.NORMAL:
        return Image.asset("assets/emoji_normal.png", height: size, width: size, fit: BoxFit.fill);
      case EMOTION_TYPE.MUITO_FELIZ:
        return Image.asset("assets/emoji_muito_feliz.png", height: size, width: size, fit: BoxFit.fill);
      default:
        return Image.asset("assets/emoji_default.png", height: size, width: size, fit: BoxFit.fill); // Uma imagem padrão caso emotionType não corresponda a nenhum caso
    }
  }
}



