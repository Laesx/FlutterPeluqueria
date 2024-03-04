import 'package:flutter/material.dart';
import 'package:flutter_peluqueria/models/models.dart';
import 'package:flutter_peluqueria/services/services.dart';
import 'package:flutter_peluqueria/widgets/widgets.dart';
import 'package:table_calendar/table_calendar.dart';
import '../providers/providers.dart';
import '../utils.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class CalendarReservations extends StatefulWidget {
  const CalendarReservations({super.key});

  @override
  State<CalendarReservations> createState() => _CalendarReservationsState();
}

class _CalendarReservationsState extends State<CalendarReservations> {
  late ValueNotifier<List<Reserva>> _selectedSchedule;
  final CalendarFormat _calendarFormat = CalendarFormat.week;
  final RangeSelectionMode _rangeSelectionMode = RangeSelectionMode.disabled;

  late ReservasServices reservasServices;
  late HorariosServices horariosServices;
  late Usuario usuarioActivo;

  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    reservasServices = Provider.of<ReservasServices>(context);
    horariosServices = Provider.of<HorariosServices>(context);

    usuarioActivo = Provider.of<ConnectedUserProvider>(context).activeUser;
    _selectedSchedule = ValueNotifier(_getReservasPorDia(_selectedDay!));
  }

  @override
  void dispose() {
    _selectedSchedule.dispose();
    super.dispose();
  }

  // Devuelve una lista con todas las reservas que tiene el peluquero activo en un día concreto
  List<Reserva> _getReservasPorDia(DateTime day) {
    List<Reserva> reservas = [];
    // Copia de las reservas para debuggear
    reservas.addAll(reservasServices.reservas);

    // Comprueba que sea el peluquero activo el que tiene la reserva
    reservas.removeWhere((reserva) =>
        reserva.peluquero != usuarioActivo.id ||
        reserva.fecha[0].day != day.day ||
        reserva.fecha[0].month != day.month ||
        reserva.fecha[0].year != day.year);

    return reservas;
  }

  // Esta función es lo que ejecutará el calendario al seleccionar un día
  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
      });
      _selectedSchedule.value = _getReservasPorDia(_selectedDay!);
      // Limpia la selección de hora al cambiar de día
      lastSelection = null;
    }
  }

  // Variable que guardará la ultima hora que se ha seleccionado
  int? lastSelection;

  @override
  Widget build(BuildContext context) {
    // Esta función maneja cuando se selecciona una hora
    onTimePressed(timeSelected) {
      //print(timeSelected.toString());
      //print(lastSelection);
      setState(() {
        if (lastSelection == timeSelected) {
          lastSelection = null;
        } else {
          lastSelection = timeSelected;
        }
      });
      //print(lastSelection);
    }

    return Column(
      children: [
        TableCalendar<Reserva>(
          locale: 'es_ES',
          firstDay: kFirstDay,
          lastDay: kLastDay,
          focusedDay: _focusedDay,
          selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
          calendarFormat: _calendarFormat,
          availableCalendarFormats: const {CalendarFormat.week: 'Week'},
          rangeSelectionMode: _rangeSelectionMode,
          startingDayOfWeek: StartingDayOfWeek.monday,
          calendarStyle: const CalendarStyle(
            outsideDaysVisible: false,
          ),
          headerStyle: const HeaderStyle(
            titleCentered: true,
          ),
          onDaySelected: _onDaySelected,
          onPageChanged: (focusedDay) {
            _focusedDay = focusedDay;
          },
        ),
        const SizedBox(height: 20.0),
        ValueListenableBuilder<List<Reserva>>(
          valueListenable: _selectedSchedule,
          builder: (context, reserva, _) {
            if (reserva.isEmpty) {
              return Container(
                  padding: const EdgeInsets.all(30.0),
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 15,
                          offset: Offset(0, 5),
                        )
                      ]),
                  child: const Text(
                    'Hoy no hay reservas',
                    style: TextStyle(color: Colors.white, fontSize: 20.0),
                  ));
            }
            return Expanded(
                child: ListView.builder(
              itemCount: reserva.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12.0,
                    vertical: 4.0,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: ListTile(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (BuildContext context) {
                          return Container(
                            padding: const EdgeInsets.all(16.0),
                            child: ReservaCard(
                              reserva: reserva[index],
                            ),
                          );
                        },
                      );
                    },
                    title: Text(
                        "Cita ${DateFormat('dd-MM-yyyy').format(reserva[index].fecha[0])}, ${DateFormat('HH:mm').format(reserva[index].fecha[0])}"),
                  ),
                );
              },
            ));
          },
        ),
      ],
    );
  }
}
