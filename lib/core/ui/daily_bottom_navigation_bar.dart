
import 'package:daily_for_specialists/core/constants/route_constants.dart';
import 'package:daily_for_specialists/core/ui/daily_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:iconsax/iconsax.dart';

final GlobalKey<_DailyBottomNavigationBarState> bottomNavigationBarKey = GlobalKey<_DailyBottomNavigationBarState>();

class DailyBottomNavigationBar extends StatefulWidget {
  const DailyBottomNavigationBar({Key? key}) : super(key: key);

  @override
  State<DailyBottomNavigationBar> createState() => _DailyBottomNavigationBarState();
}

class _DailyBottomNavigationBarState extends State<DailyBottomNavigationBar> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Modular.to.navigate(RouteConstants.homePage);
        break;
      case 1:
        Modular.to.navigate(RouteConstants.healthPage);
        break;
      case 2:
        Modular.to.navigate(RouteConstants.chatPage);
        break;
      case 3:
       // Modular.to.navigate('/profile');
        break;
      default:
        break;
    }
  }

  @override
  void initState() {
    super.initState();

    super.didChangeDependencies();

    String currentRoute = Modular.to.path;
    setState(() {
      if (currentRoute == RouteConstants.homePage) {
        _selectedIndex = 0;
      } else if (currentRoute == RouteConstants.healthPage) {
        _selectedIndex = 1;
        } else if (currentRoute == RouteConstants.chatPage) {
          _selectedIndex = 2;
        // } else if (currentRoute == RouteConstants.profilePage) {
        //   _selectedIndex = 3;
      }
    });

  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
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
      child: ClipRRect(
        borderRadius: BorderRadius.circular(100),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          backgroundColor: Colors.transparent,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Iconsax.home, size: 30),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Iconsax.health, size: 30),
              label: 'Saúde',
            ),
            BottomNavigationBarItem(
              icon: Icon(Iconsax.message, size: 30),
              label: 'Chat',
            ),
            BottomNavigationBarItem(
              icon: Icon(Iconsax.user, size: 30),
              label: 'Perfil',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: DailyColors.primaryColor,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
