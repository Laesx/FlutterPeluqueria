import 'package:flutter/material.dart';
import 'mi_app_bar.dart';
import 'mi_menu_desplegable.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MiAppBar(),
      drawer: MiMenuDesplegable(),
      body: Center(
        child: Text('¡Bienvenido a mi app!'),
      ),
    );
  }
}
