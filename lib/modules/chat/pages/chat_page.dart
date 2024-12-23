import 'dart:async';
import 'dart:convert';

import 'package:daily_for_specialists/core/constants/route_constants.dart';
import 'package:daily_for_specialists/core/ui/daily_app_bar.dart';
import 'package:daily_for_specialists/domain/models/chat_dto.dart';
import 'package:daily_for_specialists/domain/models/user_dto.dart';
import 'package:daily_for_specialists/utils/environment_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:gap/gap.dart';

import '../../../core/ui/daily_bottom_navigation_bar.dart';
import '../../../core/ui/daily_colors.dart';
import '../../../core/ui/daily_drawer.dart';
import 'package:http/http.dart' as http;

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<ChatDTO> chats = [];
  bool _isSearching = false;
  bool _isLoading = true;
  Timer? _timer;

  String _decodeUtf8(String text) {
    return utf8.decode(text.codeUnits);
  }

  Future<void> fetchChats() async {

    UserDto? user = EnvironmentUtils.getLoggedUser();
    int id = user!.id;
    final response = await http.get(
      Uri.parse(
          'http://10.0.2.2:8080/api/v1/chat/psychologist?psychologistId=$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    setState(() {
      _isLoading = false; 
    });

    if (response.statusCode == 200) {
      List<ChatDTO> dto = ChatDTO.fromJsonList(jsonDecode(response.body));

      if (!areChatsEqual(dto, chats)) {
        setState(() {
          chats = dto;
        });
      }
    } else {
    }
  }

  bool areChatsEqual(List<ChatDTO> list1, List<ChatDTO> list2) {
    if (list1.length != list2.length) {
      return false;
    }

    bool isEqual = true;

    for (int i = 0; i < list1.length; i++) {
      final chat1 = list1[i];
      final chat2 = list2[i];

      if (chat1.id != chat2.id ||
          chat1.lastMessage != chat2.lastMessage ||
          chat1.lastMessageTime != chat2.lastMessageTime ||
          chat1.patient!.name != chat2.patient!.name) {
        isEqual = false;
      }
    }

    return isEqual;
  }

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      fetchChats();
    });
  }

  void _onSearchChanged(String query) {
    setState(() {
      _isSearching = query.isNotEmpty;
      chats = chats
          .where((chat) =>
          chat.patient!.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  String _shortenMessage(String message) {
    if (message.length > 30) {
      return "${message.substring(0, 30)}...";
    }
    return message;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DailyColors.pageBackgroundColor,
      bottomNavigationBar: const DailyBottomNavigationBar(),
      drawer: const DailyDrawer(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DailyAppBar(title: "Chat", onSearchChanged: _onSearchChanged),
            ),
            _isLoading
                ? Center(child: CircularProgressIndicator()) // Exibe um carregando enquanto os chats são buscados
                : chats.isEmpty
                ? Column(
              children: [
                const Gap(100),
                Image.asset('assets/emoji_not_found.png'),
                const Gap(10),
                const Text(
                  'Nenhum paciente encontrado',
                  style: TextStyle(fontSize: 16, fontFamily: 'Pangram'),
                  textAlign: TextAlign.center,
                ),
              ],
            )
                : Column(
              children: chats.map((chat) {
                return GestureDetector(
                  onTap: () {
                    Modular.to.navigate(
                      "${RouteConstants.chatDetailsPage}?patientName=${chat.patient!.name}",
                      arguments: chat.id,
                    );
                  },
                  child: Container(
                    width: double.maxFinite,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 55,
                            width: 55,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: DailyColors.primaryColor,
                            ),
                            child: chat.patient!.profilePhoto != null
                                ? ClipOval(
                                child: Image.memory(
                                    chat.patient!.profilePhoto!,
                                    fit: BoxFit.cover))
                                : const Center(
                              child: Icon(
                                Icons.person,
                                color: Colors.white,
                                size: 40,
                              ),
                            ),
                          ),
                          const Gap(10),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(chat.patient!.name,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20)),
                              if (chat.lastMessage != null)
                                Text(_shortenMessage(
                                    _decodeUtf8(chat.lastMessage!))),
                            ],
                          ),
                          const Spacer(),
                          if (chat.lastMessageTime != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 14.0),
                              child: Text(_decodeUtf8(chat.lastMessageTime!),
                                  style: TextStyle(
                                    fontWeight: FontWeight.w300,
                                  )),
                            )
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
