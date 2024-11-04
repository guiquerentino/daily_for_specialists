import 'package:daily_for_specialists/core/constants/route_constants.dart';
import 'package:daily_for_specialists/utils/environment_utils.dart';
import 'package:daily_for_specialists/utils/storage_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:gap/gap.dart';
import 'package:iconsax/iconsax.dart';

import '../../domain/models/user_dto.dart';
import 'daily_colors.dart';
import 'daily_text.dart';

class DailyDrawer extends StatelessWidget {
  const DailyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    UserDto? user = EnvironmentUtils.getLoggedUser();
    double screenWidth = MediaQuery.of(context).size.width;

    return Drawer(

      backgroundColor: Colors.white,
      width: screenWidth * 0.85,
      child: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                GestureDetector(
                  onTap: () {
                    // Provider.of<BottomNavigationBarProvider>(context, listen: false).selectedIndex = 3;
                    // Modular.to.navigate('/profile');
                  },
                  child: SizedBox(
                    height: 90,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: user?.profilePhoto == null
                                  ? DailyColors.primaryColor
                                  : Colors.black,
                              shape: BoxShape.circle,
                            ),
                            child: user?.profilePhoto != null
                                ? Image.memory(user!.profilePhoto!)
                                : const Center(
                              child: Icon(
                                Icons.person,
                                color: Colors.white,
                                size: 40,
                              ),
                            ),
                          ),
                          const Gap(15),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(user != null ? user.name! : 'Usuário',
                                  style: const TextStyle(
                                      fontSize: 18, fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.start),
                              Text(user != null ? user.email : 'email@email.com',
                                  style: const TextStyle(
                                      fontSize: 16, fontWeight: FontWeight.w200)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Iconsax.health),
                  title: DailyText.text("Espaço Saúde").body.large.bold,
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    size: 18,
                  ),
                  onTap: () {
                     Modular.to.navigate(RouteConstants.healthPage);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.message_outlined),
                  title: DailyText.text("Chat").body.large.bold,
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    size: 18,
                  ),
                  onTap: () {
                     Modular.to.navigate(RouteConstants.chatPage);
                  },
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.note_outlined),
                  title: DailyText.text("Registros").body.large.bold,
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    size: 18,
                  ),
                  onTap: () {
                    // Provider.of<BottomNavigationBarProvider>(context, listen: false).selectedIndex = 0;
                    // Modular.to.navigate('/annotations');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.equalizer),
                  title: DailyText.text("Metas").body.large.bold,
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    size: 18,
                  ),
                  onTap: () {
                    // Provider.of<BottomNavigationBarProvider>(context, listen: false).selectedIndex = 0;
                    // Modular.to.navigate('/goals');
                  },
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.newspaper_outlined),
                  title: DailyText.text("Artigos").body.large.bold,
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    size: 18,
                  ),
                  onTap: () {
                    // Provider.of<BottomNavigationBarProvider>(context, listen: false).selectedIndex = 0;
                    // Modular.to.navigate('/articles');
                  },
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.settings_outlined),
                  title: DailyText.text("Preferências").body.large.bold,
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    size: 18,
                  ),
                  onTap: () {
                    Modular.to.navigate('/profile/settings');
                  },
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(
              Icons.exit_to_app_rounded,
              color: Colors.red,
            ),
            title: const Text(
              "Sair",
              style: TextStyle(color: Colors.red),
            ),
            onTap: () async {
              StorageUtils.delete('login');
              EnvironmentUtils.loggedUser = null;

              Modular.to.navigate(RouteConstants.loginPage);
            },
          ),
          Container(
            width: double.maxFinite,
            height: 84,
            color: DailyColors.primaryColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Gap(10),
                Container(
                  height: 47,
                  width: 47,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30.0)),
                  child: const Icon(
                    Icons.lightbulb,
                    color: Color.fromRGBO(255, 152, 31, 1),
                  ),
                ),
                const Gap(10),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DailyText.text("Adquira a versão Premium")
                        .body
                        .neutral
                        .large
                        .bold,
                    DailyText.text(
                        "Aproveite todos os benefícios do aplicativo.")
                        .body
                        .neutral
                        .small
                        .bold,
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
