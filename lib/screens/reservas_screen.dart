import 'package:flutter/material.dart';
import 'package:flutter_peluqueria/screens/screens.dart';
import 'package:flutter_peluqueria/widgets/widgets.dart';

class ReservasScreen extends StatelessWidget {
  const ReservasScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MiAppBar(),
      drawer: MiMenuDesplegable(),
      body: const CalendarReservations(),
    );
  }
}
