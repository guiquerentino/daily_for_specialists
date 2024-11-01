import 'package:daily_for_specialists/domain/repositories/repository_module.dart';
import 'package:daily_for_specialists/domain/services/service_module.dart';
import 'package:daily_for_specialists/modules/chat/pages/chat_details_message.dart';
import 'package:daily_for_specialists/modules/chat/pages/chat_page.dart';
import 'package:flutter_modular/flutter_modular.dart';

class ChatModule extends Module {

  @override
  List<Module> get imports => [
    RepositoryModule(),
    ServiceModule()
  ];

  @override
  void binds(Injector i) {
    super.binds(i);
  }

  @override
  void routes(RouteManager r) {
    r.child(Modular.initialRoute, child: (context) => ChatPage());
    r.child('/messages', child: (context) => ChatDetailsMessage(chatId: r.args.data, patientName: r.args.queryParams['patientName']));
  }

}