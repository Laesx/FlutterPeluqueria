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
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                'assets/alithebarber.jpg'), // Ruta de tu imagen de fondo
            fit: BoxFit
                .fitWidth, // Ajusta la imagen para que el ancho de la imagen cubra el ancho del contenedor
          ),
        ),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const <Widget>[
              Padding(
                padding: EdgeInsets.only(
                    top: 20, left: 20), // Ajusta el espaciado como desees
                child: Text(
                  'Bienvenido a la peluquería',
                  style: TextStyle(fontSize: 20, color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
