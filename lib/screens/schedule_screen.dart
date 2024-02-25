import 'package:flutter/material.dart';
import 'package:flutter_peluqueria/widgets/calendar_reservations_test.dart';
import 'package:flutter_peluqueria/widgets/widgets.dart';

class ScheduleScreen extends StatelessWidget {
  const ScheduleScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('TestScreen'),
        ),
        body: CalendarReservationsTest());
  }
}
