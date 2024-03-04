import 'package:flutter/material.dart';
import 'package:flutter_peluqueria/screens/screens.dart';
import 'package:flutter_peluqueria/widgets/widgets.dart';

class ReservasScreen extends StatefulWidget {
  const ReservasScreen({Key? key}) : super(key: key);

  @override
  State<ReservasScreen> createState() => _ReservasScreenState();
}

class _ReservasScreenState extends State<ReservasScreen> {
  String peluqueroBusqueda = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MiAppBar(),
      drawer: MiMenuDesplegable(),
      //body: const CalendarReservations(),

      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Filtrar reservas por peluquero',
              ),
              onChanged: (peluquero) {
                setState(() {
                  peluqueroBusqueda = peluquero;
                });
              },
            ),
          ),
          Expanded(
            child: CalendarReservations(peluqueroBusqueda: peluqueroBusqueda),
          ),
        ],
      ),
    );
  }
}
