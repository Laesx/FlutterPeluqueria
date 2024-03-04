import 'package:flutter/material.dart';
import 'package:flutter_peluqueria/screens/gestion_peluqueros.dart';

import '../models/models.dart';
import '../screens/screens.dart';

class AppRoutes {
  static const initialRoute = 'login';

  static final menuOptions = <MenuOption>[
    MenuOption(
        route: 'home',
        icon: Icons.home,
        name: 'Inicio',
        screen: const HomeScreen()),
    MenuOption(
        route: 'schedule',
        icon: Icons.calendar_today,
        name: 'Horarios',
        screen: const ScheduleScreen()),
    MenuOption(
        route: 'gestion',
        icon: Icons.people,
        name: 'Gestión',
        screen:  GestionPeluquerosScreen()),
  ];

  static Map<String, Widget Function(BuildContext)> getAppRoutes() {
    return {
      'home': (context) => const HomeScreen(),
      'schedule': (context) => const ScheduleScreen(),
      'gestion': (context) => GestionPeluquerosScreen(),
      'login': (context) => const LoginScreen(),
    };
  }

// Hay que implementarlo
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    return MaterialPageRoute(builder: (context) => const HomeScreen());
  }
}
