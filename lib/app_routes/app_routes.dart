import 'package:flutter/material.dart';
import 'package:flutter_peluqueria/screens/gestion_peluqueros.dart';
import 'package:flutter_peluqueria/services/auth_services.dart';

import '../models/models.dart';
import '../screens/screens.dart';
import '../screens/register_screen.dart';

class AppRoutes {
  static const initialRoute = 'gestion';

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
        screen: GestionPeluquerosScreen()),
    MenuOption(
      route: 'horario',
      icon: Icons.calendar_today,
      name: 'Horario',
      screen: CalendarScreen(),
    ),
    MenuOption(
      route: 'reservas',
      icon: Icons.calendar_today,
      name: 'Reservas',
      screen: const ReservasScreen(),
    ),
    MenuOption(
      route: 'registro',
      icon: Icons.app_registration_outlined,
      name: 'Registro',
      screen: const RegisterScreen(),
    )
  ];

  static Map<String, Widget Function(BuildContext)> getAppRoutes() {
    return {
      'home': (context) => const HomeScreen(),
      'schedule': (context) => const ScheduleScreen(),
      'gestion': (context) => GestionPeluquerosScreen(),
      'login': (context) => const LoginScreen(),
      'reservas': (context) => const ReservasScreen(),
      'horario': (context) => CalendarScreen(),
      'registro': (context) => const RegisterScreen(),
    };
  }

// Hay que implementarlo
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    return MaterialPageRoute(builder: (context) => const HomeScreen());
  }
}
