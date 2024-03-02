import 'package:flutter/material.dart';
import '/screens/calendario_screen.dart';
import '/screens/hours_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mi Aplicación de Calendario',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
      routes: {
        '/screens/calendario_screen': (context) => CalendarScreen(),
        '/screens/hours_screen': (context) => OpeningHoursManager(),
      },
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mi Aplicación de Calendario'),
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/screens/calendario_screen');
            },
            child: Text('Ver Calendario'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/screens/hours_screen');
            },
            child: Text('Ver Horarios de Apertura'),
          ),
        ],
      ),
    );
  }
}
