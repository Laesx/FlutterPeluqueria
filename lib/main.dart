// Importa todas las pantallas que quieres exportar
// ignore: depend_on_referenced_packages
import 'package:flutter_peluqueria/screens/home_screen.dart';
import 'package:flutter_peluqueria/screens/mi_app_bar.dart';
import 'package:flutter_peluqueria/screens/mi_menu_desplegable.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'screens/screens.dart';

void main() {
  initializeDateFormatting().then((_) => runApp(MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Peluqueria App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ScheduleScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
