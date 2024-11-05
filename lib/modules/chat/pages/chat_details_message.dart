import 'dart:async';
import 'dart:convert';
import 'package:daily_for_specialists/core/constants/route_constants.dart';
import 'package:daily_for_specialists/core/ui/daily_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:collection/collection.dart';

class ChatDetailsMessage extends StatefulWidget {
  final int chatId;
  final String? patientName;
  const ChatDetailsMessage({super.key, required this.chatId, required this.patientName});

  @override
  State<ChatDetailsMessage> createState() => _ChatDetailsMessageState();
}

class _ChatDetailsMessageState extends State<ChatDetailsMessage> {
  List<ChatMessageDto> messages = [];
  final TextEditingController _messageController = TextEditingController();
  Timer? _timer;
  bool _isLoading = true; 

  @override
  void initState() {
    super.initState();
    fetchMessages();
    _timer = Timer.periodic(Duration(seconds: 5), (timer) {
      fetchMessages();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> fetchMessages() async {

    int id = widget.chatId;

    final response = await http.get(
      Uri.parse('http://10.0.2.2:8080/api/v1/chat?chatId=$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      List<ChatMessageDto> newMessages = ChatMessageDto.fromJsonList(jsonDecode(response.body));

      if (!ListEquality().equals(messages, newMessages)) {
        setState(() {
          messages = newMessages;
        });
      }
    } else {
      print('Failed to load messages');
    }

    setState(() {
      _isLoading = false;
    });
  }

  String _decodeUtf8(String text) {
    return utf8.decode(text.codeUnits);
  }

  String _formatDate(DateTime date) {
    return DateFormat('dd/MM/yy HH:mm').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Modular.to.pushNamed(RouteConstants.chatPage);
          },
          child: Icon(Icons.arrow_back_outlined),
        ),
        title: Text(widget.patientName!),
      ),
      body: RefreshIndicator( // Wrap o conteúdo com RefreshIndicator
        onRefresh: fetchMessages,
        child: Column(
          children: [
            Expanded(
              child: _isLoading // Verifica se está carregando
                  ? Center(child: CircularProgressIndicator())
                  : messages.isNotEmpty
                  ? ListView.builder(
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final message = messages[index];
                  final bool isPsychologist = message.sender == 'psychologist';

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                    child: Align(
                      alignment: isPsychologist ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        padding: const EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                          color: isPsychologist ? DailyColors.primaryColor : Colors.grey[300],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _decodeUtf8(message.content),
                              style: TextStyle(
                                color: isPsychologist ? Colors.white : Colors.black,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _formatDate(message.sentAt!),
                              style: TextStyle(
                                fontSize: 10,
                                color: isPsychologist ? Colors.white70 : Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              )
                  : Container()
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: "Digite sua mensagem...",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.send, color: DailyColors.primaryColor),
                    onPressed: () async {
                      ChatMessageDto request = ChatMessageDto(
                        chatId: widget.chatId,
                        sender: 'psychologist',
                        content: _messageController.text,
                      );

                      final response = await http.post(
                        Uri.parse('http://10.0.2.2:8080/api/v1/chat'),
                        headers: <String, String>{
                          'Content-Type': 'application/json; charset=UTF-8',
                        },
                        body: jsonEncode(request.toJson()),
                      );

                      if (response.statusCode == 200) {
                        fetchMessages();
                        _messageController.clear();
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatMessageDto {
  final int? id;
  final int chatId;
  final String sender;
  final String content;
  final DateTime? sentAt;

  ChatMessageDto({
    this.id,
    required this.chatId,
    required this.sender,
    required this.content,
    this.sentAt,
  });

  factory ChatMessageDto.fromJson(Map<String, dynamic> json) {
    return ChatMessageDto(
      id: json['id'] as int,
      chatId: json['chatId'] as int,
      sender: json['sender'] as String,
      content: json['content'] as String,
      sentAt: DateTime.parse(json['sentAt'] as String),
    );
  }

  static List<ChatMessageDto> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => ChatMessageDto.fromJson(json)).toList();
  }

  Map<String, dynamic> toJson() {
    return {
      'chatId': chatId,
      'sender': sender,
      'content': content,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is ChatMessageDto &&
              runtimeType == other.runtimeType &&
              id == other.id &&
              chatId == other.chatId &&
              sender == other.sender &&
              content == other.content &&
              sentAt == other.sentAt;

  @override
  int get hashCode =>
      id.hashCode ^ chatId.hashCode ^ sender.hashCode ^ content.hashCode ^ sentAt.hashCode;

}
