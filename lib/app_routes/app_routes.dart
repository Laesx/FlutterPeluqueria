import 'package:flutter/material.dart';
import 'package:flutter_peluqueria/screens/gestion_peluqueros.dart';

import '../screens/screens.dart';

class AppRoutes {
  static const initialRoute = 'home';

  static Map<String, Widget Function(BuildContext)> getAppRoutes() {
    return {
      'home': (context) => const HomeScreen(),
      'schedule': (context) => const ScheduleScreen(),
      'gestion': (context) => GestionPeluquerosScreen(),
    };
  }

// Hay que implementarlo
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    return MaterialPageRoute(builder: (context) => const HomeScreen());
  }
}
