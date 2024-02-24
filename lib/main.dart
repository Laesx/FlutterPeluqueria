import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'screens/screens.dart';

void main() {
  initializeDateFormatting().then((_) => runApp(MyApp()));
}

class MyApp extends StatelessWidget {
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
