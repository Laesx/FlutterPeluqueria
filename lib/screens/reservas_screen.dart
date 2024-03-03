import 'package:flutter/material.dart';
import 'package:flutter_peluqueria/widgets/calendar_reservations_test.dart';
import 'package:flutter_peluqueria/widgets/widgets.dart';

class ReservasScreen extends StatelessWidget {
  const ReservasScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reservas'),
      ),
      body: const CalendarReservations(),
    );
  }
}
