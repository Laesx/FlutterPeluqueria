import 'package:flutter/material.dart';
import 'package:flutter_peluqueria/models/models.dart';
import 'package:flutter_peluqueria/models/usuario.dart';
import 'package:flutter_peluqueria/services/services.dart';
import 'package:table_calendar/table_calendar.dart';
import '../providers/providers.dart';
import '../utils.dart';
import 'package:provider/provider.dart';

import 'boton_hora.dart';

class CalendarioPeluquero extends StatefulWidget {
  const CalendarioPeluquero({super.key});

  @override
  State<CalendarioPeluquero> createState() => _CalendarioPeluqueroState();
}

class _CalendarioPeluqueroState extends State<CalendarioPeluquero> {
  late ValueNotifier<List<String>> _selectedSchedule;
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
    //_selectedSchedule = ValueNotifier(_horarioDia(_getScheduleForDay(_selectedDay!), _selectedDay!));
    _selectedSchedule = ValueNotifier(_getHorarioPeluString(_selectedDay!));
  }

  @override
  void dispose() {
    _selectedSchedule.dispose();
    super.dispose();
  }

  // TODO Por implementar
  // La idea es que luego el _getHorarioPeluString
  // llame a esta funcion y devuelva botones u otra cosa que no sea solo texto
  List<Reserva> _getReservasPorDia(DateTime day) {
    List<Reserva> reservas = [];

    Future<List<Reserva>> reservasDia = reservasServices.getReservasByDate(day);

    // Comprueba que sea el peluquero activo el que tiene la reserva
    reservasDia.then((value) {
      for (var reserva in value) {
        if (reserva.peluquero == usuarioActivo.id) {
          reservas.add(reserva);
        }
      }
    });

    return reservas;
  }

  // Esta función devuelve una lista con todas las horas que está abierta
  // la peluqueria en un día concreto
  List<String> _getHorarioPeluString(DateTime day) {
    List<String> horario = [];
    Map<String, dynamic> horarioMapa = {};

    // Esto creo que no hace falta
    if (reservasServices.isLoading || horariosServices.isLoading) {
      // Return a default Horario object or handle it accordingly
      return horario; // Assuming Horario has a default constructor
    }

    // Esto es para comprobar si el día es festivo, primero de los festivos de la peluqueria
    for (var horarioPelu in horariosServices.horarioPelu) {
      for (var festivo in horarioPelu.festivos) {
        if (festivo.day == day.day &&
            festivo.month == day.month &&
            festivo.year == day.year) {
          return horario;
        }
      }
    }

    // Ahora los festivos del peluquero en si
    for (var horarioPeluquero in horariosServices.horarios) {
      if (horarioPeluquero.peluquero == usuarioActivo.id) {
        for (var festivo in horarioPeluquero.horario.festivos) {
          if (festivo.day == day.day &&
              festivo.month == day.month &&
              festivo.year == day.year) {
            return horario;
          }
        }
      }
    }

    horariosServices.horarioPelu.forEach((horarioPelu) {
      horarioMapa = horarioPelu.toMap();
    });

    horarioMapa.forEach((key, value) {
      if (key == diaSemana(day)) {
        horario.addAll(getTimes(value['empieza_man'], value['acaba_man']));
        horario.addAll(getTimes(value['empieza_tarde'], value['acaba_tarde']));
      }
    });
    //print(horario.toString());
    return horario;
  }

  List<BotonHora> _getHorarioPelu(DateTime day) {
    List<BotonHora> horario = [];
    Map<String, dynamic> horarioMapa = {};

    // Esto creo que no hace falta
    if (reservasServices.isLoading || horariosServices.isLoading) {
      // Return a default Horario object or handle it accordingly
      return horario; // Assuming Horario has a default constructor
    }

    // Esto es para comprobar si el día es festivo, primero de los festivos de la peluqueria
    for (var horarioPelu in horariosServices.horarioPelu) {
      for (var festivo in horarioPelu.festivos) {
        if (festivo.day == day.day &&
            festivo.month == day.month &&
            festivo.year == day.year) {
          return horario;
        }
      }
    }

    // Ahora los festivos del peluquero en si
    for (var horarioPeluquero in horariosServices.horarios) {
      if (horarioPeluquero.peluquero == usuarioActivo.id) {
        for (var festivo in horarioPeluquero.horario.festivos) {
          if (festivo.day == day.day &&
              festivo.month == day.month &&
              festivo.year == day.year) {
            return horario;
          }
        }
      }
    }

    horariosServices.horarioPelu.forEach((horarioPelu) {
      horarioMapa = horarioPelu.toMap();
    });

    List<Reserva> reservas = _getReservasPorDia(day);
    List<String> horarioString = [];

    horarioMapa.forEach((key, value) {
      if (key == diaSemana(day)) {
        horarioString
            .addAll(getTimes(value['empieza_man'], value['acaba_man']));
        horarioString
            .addAll(getTimes(value['empieza_tarde'], value['acaba_tarde']));
      }
    });

    //List<int> horasOcupadas = [];

    // Comprobamos las horas ocupadas
    for (int i = 0; i < horarioString.length; i++) {
      var hora = horarioString[i];
      bool ocupada = false;
      for (var reserva in reservas) {
        if (reserva.fecha[0].hour.toString().padLeft(2, '0') +
                ':' +
                reserva.fecha[0].minute.toString().padLeft(2, '0') ==
            hora) {
          ocupada = true;
        }
      }
      horario.add(BotonHora(
        enabledTimes: null,
        label: hora,
        value: i,
        timeSelected: lastSelection,
        onPressed: (timeSelected) {
          onTimePressed(timeSelected);
        },
        singleSelection: true,
        disabled: ocupada,
      ));
    }
    //print(horario.toString());
    return horario;
  }

  // Funcion para cuando se pulsa una hora
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

  // Esta funcion es para parsear el tiempo en strings...
  // Devuelve algo así como ['08:00', '08:30', '09:00', '09:30', '10:00']
  List<String> getTimes(String startTime, String endTime) {
    List<String> times = [];

    // Comprobamos que no este vacio o que este cerrado en algun tramo
    if (startTime.isEmpty ||
        endTime.isEmpty ||
        startTime == 'cerrado' ||
        endTime == 'cerrado') {
      return times;
    }

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

  // Devuelve el día de la semana en string, al pasarle un DateTime del día
  // Esto a lo mejor tendría que llevarlo a el modelo en si como una funcion estatica?
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

  // Esta función es lo que ejecutará el calendario al seleccionar un día
  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
      });
      _selectedSchedule.value = _getHorarioPeluString(_selectedDay!);
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
            outsideDaysVisible: false,
          ),
          onDaySelected: _onDaySelected,
          onPageChanged: (focusedDay) {
            _focusedDay = focusedDay;
          },
        ),
        const SizedBox(height: 20.0),
        ValueListenableBuilder<List<String>>(
            valueListenable: _selectedSchedule,
            builder: (context, dia, _) {
              return Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: [
                  for (int i = 0; i < dia.length; i++) ...[
                    BotonHora(
                      enabledTimes: null,
                      label: dia[i],
                      value: i,
                      timeSelected: lastSelection,
                      // Esto es lo que se ejecuta al seleccionar una hora
                      onPressed: (timeSelected) {
                        onTimePressed(timeSelected);
                      },
                      singleSelection: true,
                    ),
                  ],
                ],
              );
            }),
      ],
    );
  }
}
