import 'package:flutter/material.dart';
import 'package:flutter_peluqueria/models/models.dart';
import 'package:flutter_peluqueria/services/services.dart';
import 'package:flutter_peluqueria/widgets/botones.dart';
import 'package:flutter_peluqueria/widgets/widgets.dart';
import 'package:table_calendar/table_calendar.dart';
import '../utils.dart';
import 'package:provider/provider.dart';

class CalendarReservationsTest extends StatefulWidget {
  const CalendarReservationsTest({super.key});

  @override
  State<CalendarReservationsTest> createState() =>
      _CalendarReservationsTestState();
}

class _CalendarReservationsTestState extends State<CalendarReservationsTest> {
  late ValueNotifier<List<String>> _selectedSchedule;
  final CalendarFormat _calendarFormat = CalendarFormat.week;
  final RangeSelectionMode _rangeSelectionMode = RangeSelectionMode.disabled;

  late ReservasServices reservasServices;
  late HorariosServices horariosServices;

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
    //_selectedSchedule = ValueNotifier(_horarioDia(_getScheduleForDay(_selectedDay!), _selectedDay!));
    _selectedSchedule = ValueNotifier(_getHorarioPeluString(_selectedDay!));
  }

  @override
  void dispose() {
    _selectedSchedule.dispose();
    super.dispose();
  }

  Horario _getScheduleForDay(DateTime day) {
    Horario horario = Horario.empty();

    if (reservasServices.isLoading || horariosServices.isLoading) {
      // Return a default Horario object or handle it accordingly
      return Horario.empty(); // Assuming Horario has a default constructor
    }

    // En caso de que no se encuentre de la otra forma.
    //horario = horariosServices.horarios.first.horario;

    //reservasServices.getReservasByDate(day);

    horariosServices.horarios.forEach((horarioPeluquero) {
      if (horarioPeluquero.peluquero == 'test') {
        horario = (horarioPeluquero.horario);
      }
    });

    return horario;
  }

  Horario _getHorarioPelu() {
    Horario horario = Horario.empty();

    if (reservasServices.isLoading || horariosServices.isLoading) {
      // Return a default Horario object or handle it accordingly
      return Horario.empty(); // Assuming Horario has a default constructor
    }

    // En caso de que no se encuentre de la otra forma.
    //horario = horariosServices.horarios.first.horario;

    horariosServices.horarioPelu.forEach((horarioPelu) {
      horario = horarioPelu;
    });

    return horario;
  }

  Map<String, dynamic> _getHorarioPeluqueria() {
    Map<String, dynamic> horario = {};

    if (reservasServices.isLoading || horariosServices.isLoading) {
      // Return a default Horario object or handle it accordingly
      return horario; // Assuming Horario has a default constructor
    }

    // En caso de que no se encuentre de la otra forma.
    //horario = horariosServices.horarios.first.horario;

    horariosServices.horarioPelu.forEach((horarioPelu) {
      horario = horarioPelu.toMap();
    });

    print(horario.toString());

    return horario;
  }

  List<String> _getHorarioPeluString(DateTime day) {
    List<String> horario = [];

    Map<String, dynamic> horarioMapa = {};

    if (reservasServices.isLoading || horariosServices.isLoading) {
      // Return a default Horario object or handle it accordingly
      return horario; // Assuming Horario has a default constructor
    }

    horariosServices.horarioPelu.forEach((horarioPelu) {
      horarioMapa = horarioPelu.toMap();
    });

    // Esto es probablemente de los peores codigos que he escrito en mi vida
    // Los modelos estan mapeados como la más absoluta mierda pero bueno
    horarioMapa.forEach((key, value) {
      if (key == diaSemana(day)) {
        horario.addAll(getTimes(value['empieza_man'], value['acaba_man']));
        horario.addAll(getTimes(value['empieza_tarde'], value['acaba_tarde']));
      }
    });

    print(horario.toString());

    return horario;
  }

  // Esta funcion es para parsear el tiempo en strings...
  // Devuelve algo así como ['08:00', '08:30', '09:00', '09:30', '10:00']
  List<String> getTimes(String startTime, String endTime) {
    List<String> times = [];

    var startHour = int.parse(startTime.split(':')[0]);
    var startMinute = int.parse(startTime.split(':')[1]);

    var endHour = int.parse(endTime.split(':')[0]);
    var endMinute = int.parse(endTime.split(':')[1]);

    for (var hour = startHour; hour <= endHour; hour++) {
      for (var minute = 0; minute < 60; minute += 30) {
        if (hour == startHour && minute < startMinute ||
            hour == endHour && minute > endMinute) {
          continue;
        }
        times.add(
            '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}');
      }
    }

    return times;
  }

  Dia _horarioDia(Horario horario, DateTime day) {
    switch (day.weekday) {
      case DateTime.monday:
        return horario.lunes;
      case DateTime.tuesday:
        return horario.martes;
      case DateTime.wednesday:
        return horario.miercoles;
      case DateTime.thursday:
        return horario.jueves;
      case DateTime.friday:
        return horario.viernes;
      case DateTime.saturday:
        return horario.sabado;
      case DateTime.sunday:
        return horario.domingo;
      default:
        return Dia.empty();
    }
  }

  String diaSemana(DateTime dia) {
    switch (dia.weekday) {
      case DateTime.monday:
        return 'lunes';
      case DateTime.tuesday:
        return 'martes';
      case DateTime.wednesday:
        return 'miercoles';
      case DateTime.thursday:
        return 'jueves';
      case DateTime.friday:
        return 'viernes';
      case DateTime.saturday:
        return 'sabado';
      case DateTime.sunday:
        return 'domingo';
      default:
        return 'error';
    }
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
      });

      //_selectedSchedule.value = _horarioDia(_getScheduleForDay(_selectedDay!), _selectedDay!);

      _selectedSchedule.value = _getHorarioPeluString(_selectedDay!);
    }
  }

  @override
  Widget build(BuildContext context) {
    //reservasServices = Provider.of<ReservasServices>(context);
    //horariosServices = Provider.of<HorariosServices>(context);

    //final horarioPelu = _getHorarioPeluString(day);

    return Column(
      children: [
        TableCalendar<Dia>(
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
            // Use `CalendarStyle` to customize the UI
            outsideDaysVisible: false,
          ),
          onDaySelected: _onDaySelected,
          onPageChanged: (focusedDay) {
            _focusedDay = focusedDay;
          },
        ),
        const SizedBox(height: 8.0),
        // Si se quita el Expanded, el ValueListenableBuilder no funciona
        // dios sabra porque
        Expanded(
          child: ValueListenableBuilder<List<String>>(
            valueListenable: _selectedSchedule,
            builder: (context, dia, _) {
              return GridView.builder(
                itemCount: dia.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4, mainAxisSpacing: 5, crossAxisSpacing: 5),
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 4.0,
                      vertical: 4.0,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: ListTile(
                      onTap: () => _getHorarioPeluqueria(),
                      // Esto está muy mal hecho
                      title: Text(dia[index].toString()),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
