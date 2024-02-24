// Importa todas las pantallas que quieres exportar
// ignore: depend_on_referenced_packages
import 'package:flutter_peluqueria/screens/home_screen.dart';
import 'package:flutter_peluqueria/screens/mi_app_bar.dart';
import 'package:flutter_peluqueria/screens/mi_menu_desplegable.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MiAppBar(),
      drawer: MiMenuDesplegable(),
      body: Center(
        child: Text(
          'Welcome to $title',
          style: Theme.of(context).textTheme.headline6,
        ),
      ),
    );
  }
}
