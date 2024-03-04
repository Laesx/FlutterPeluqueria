import 'package:flutter/material.dart';
import 'package:flutter_peluqueria/models/models.dart';
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
  late ValueNotifier<List<DatosBotonHora>> _selectedSchedule;
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
    _selectedSchedule = ValueNotifier(_getHorarioPelu(_selectedDay!));
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

  bool _isFestivo(DateTime day) {
    bool esFestivo = false;
    for (var horarioPelu in horariosServices.horarioPelu) {
      for (var festivo in horarioPelu.festivos) {
        if (festivo.day == day.day &&
            festivo.month == day.month &&
            festivo.year == day.year) {
          esFestivo = true;
        }
      }
    }

    for (var horarioPeluquero in horariosServices.horarios) {
      if (horarioPeluquero.peluquero == usuarioActivo.id) {
        for (var festivo in horarioPeluquero.horario.festivos) {
          if (festivo.day == day.day &&
              festivo.month == day.month &&
              festivo.year == day.year) {
            esFestivo = true;
          }
        }
      }
    }

    return esFestivo;
  }

  // Esta función devuelve una lista de DatosBotonHora con todos los datos
  // de las horas disponibles y ocupadas
  List<DatosBotonHora> _getHorarioPelu(DateTime day) {
    List<DatosBotonHora> horario = [];
    Map<String, dynamic> horarioMapa = {};

    // Esto creo que no hace falta
    if (reservasServices.isLoading || horariosServices.isLoading) {
      // Return a default Horario object or handle it accordingly
      return horario; // Assuming Horario has a default constructor
    }

    // Comprobar si el día es festivo
    if (_isFestivo(day)) {
      return horario;
    }

    horariosServices.horarioPelu.forEach((horarioPelu) {
      horarioMapa = horarioPelu.toMap();
    });

    List<String> horarioString = [];

    horarioMapa.forEach((key, value) {
      if (key == diaSemana(day)) {
        horarioString
            .addAll(getTimes(value['empieza_man'], value['acaba_man']));
        horarioString
            .addAll(getTimes(value['empieza_tarde'], value['acaba_tarde']));
      }
    });

    // Esta sección es para comprobar las horas que tiene el peluquero
    // para luego contrastarlas con las horas de la peluqueria en si.
    List<String> horasPeluquero = [];
    Map<String, dynamic> horarioPeluqueroMapa = horariosServices.horarios
        .firstWhere((horario) => horario.peluquero == usuarioActivo.id)
        .horario
        .toMap();

    horarioPeluqueroMapa.forEach((key, value) {
      if (key == diaSemana(day)) {
        horasPeluquero
            .addAll(getTimes(value['empieza_man'], value['acaba_man']));
        horasPeluquero
            .addAll(getTimes(value['empieza_tarde'], value['acaba_tarde']));
      }
    });

    List<Reserva> reservas = _getReservasPorDia(day);
    // Comprobamos las horas ocupadas
    // (las horas en las que el peluquero tiene reservas o no trabaja)
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
      if (horasPeluquero.isNotEmpty) {
        if (!horasPeluquero.contains(hora)) {
          ocupada = true;
        }
      }
      horario.add(DatosBotonHora(hora, ocupada));
    }
    //print(horario.toString());
    return horario;
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
      for (var minute = 0; minute < 60; minute += 15) {
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
      _selectedSchedule.value = _getHorarioPelu(_selectedDay!);
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
        TableCalendar<DatosBotonHora>(
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
        ValueListenableBuilder<List<DatosBotonHora>>(
            valueListenable: _selectedSchedule,
            builder: (context, dia, _) {
              if (dia.isEmpty) {
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
                      'Hoy no tienes que trabajar!!',
                      style: TextStyle(color: Colors.white, fontSize: 20.0),
                    ));
              }
              return Column(
                children: [
                  Wrap(
                    spacing: 20.0,
                    runSpacing: 20.0,
                    children: [
                      for (int i = 0; i < dia.length; i++) ...[
                        BotonHora(
                          enabledTimes: null,
                          disabled: dia[i].ocupada,
                          label: dia[i].hora,
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
                  ),
                  const SizedBox(height: 50.0),
                  // Cuando el dia no está vacio, muestra el botón de siguiente
                  if (dia.isNotEmpty)
                    // Pequeña animación para que no aparezca de golpe
                    AnimatedOpacity(
                      opacity: lastSelection != null ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 150),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.black,
                          padding: EdgeInsets.symmetric(horizontal: 100),
                        ),
                        onPressed: () {
                          // El boton no hace nada
                        },
                        child:
                            Text('Siguiente', style: TextStyle(fontSize: 18)),
                      ),
                    ),
                ],
              );
            }),
      ],
    );
  }
}

class DatosBotonHora {
  final String hora;
  final bool ocupada;

  DatosBotonHora(this.hora, this.ocupada);
}
