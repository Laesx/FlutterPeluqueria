import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import './hours_screen.dart';
import 'package:flutter_peluqueria/models/models.dart';
import '../services/horarios_services.dart';

class CalendarScreen extends StatefulWidget {
  static bool _isDataLoaded = false;

  static bool get isDataLoaded => _isDataLoaded;
  static set isDataLoaded(bool value) {
    _isDataLoaded = value;
  }

  Horario getOldHorario() {
    return _CalendarScreenState.getOldHorario();
  }

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  List<Horario> oldHorario = [];
  static Horario horario = Horario.empty();

  bool horarioLoaded = false;
  // Create instances of OpeningCalendar and OpeningHours
  late OpeningCalendar openingCalendar;

  @override
  void initState() {
    super.initState();
    loadHorarios();
    // Initialize the OpeningCalendar and OpeningHours instances
    openingCalendar = OpeningCalendar();
  }

  //Nse pk
  void loadHorarios() async {
    oldHorario = await HorariosServices().loadHorarioPelu();
    horario = oldHorario[0];
  }

  static Horario getOldHorario() {
    return horario;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calendario y Horario de Apertura'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Load the horarios
          //Showing the info from oldHorario
          openingCalendar,
          // Use the OpeningCalendar instance
          // Use the OpeningHours instance
          ElevatedButton(
              onPressed: () {
                Horario.showInfo(horario);
                print(horario.festivos);
                openingCalendar.setClosedDays(horario.festivos);
              },
              child: Text('Leer datos')),
          // Botón para guardar cambios
          ElevatedButton(
            onPressed: () {
              // Get the closed days and opening hours from the instances
              List<DateTime> closedDays = openingCalendar.getClosedDays();
              // print the closed days and opening hours
              // Save the closed days and opening hours to a file
              if (OpeningCalendar.pushed()) {
                List<Dia> dias = OpeningHoursManager().getDaysOfWeek();

                Horario newHorario = Horario(
                  festivos: closedDays,
                  lunes: dias[0],
                  martes: dias[1],
                  miercoles: dias[2],
                  jueves: dias[3],
                  viernes: dias[4],
                  sabado: dias[5],
                  domingo: dias[6],
                );
                HorariosServices().saveHorarioPelu(newHorario);
              } else {
                HorariosServices().saveHorarioPelu(horario);
              }
            },
            child: Text('Guardar man'),
          ),
        ],
      ),
    );
  }
}

class OpeningCalendar extends StatefulWidget {
  final Map<DateTime, List<String>> openingCalendar = {};
  final Function(Map<DateTime, List<String>> calendar) onSaveChanges =
      (calendar) {};

  OpeningCalendar({
    Key? key,
  }) : super(key: key);

  static bool pushed() {
    return _OpeningCalendarState.pulsado;
  }

  @override
  _OpeningCalendarState createState() => _OpeningCalendarState();

  List<DateTime> getClosedDays() {
    List<DateTime> closedDays = [];
    openingCalendar.forEach((day, status) {
      if (status.contains('Closed')) {
        closedDays.add(day);
      } else {
        if (day.weekday == DateTime.saturday ||
            day.weekday == DateTime.sunday) {
          closedDays.add(day);
        }
      }
    });
    return closedDays;
  }

  void setClosedDays(List<DateTime> closedDays) {
    openingCalendar.clear(); // Clear the existing map

    // Iterate over all days of the week
    for (int i = 0; i < 7; i++) {
      // Get the date for the current day
      DateTime day = DateTime.now().add(Duration(days: i));

      // If the day is in the list of closed days, set its status to 'Closed'
      if (closedDays.any((closedDay) => closedDay.weekday == day.weekday)) {
        openingCalendar[day] = ['Closed'];
      }
    }
  }
}

class _OpeningCalendarState extends State<OpeningCalendar> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  static bool pulsado = false;

  static bool pushed() {
    return pulsado;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Calendario de Apertura',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          SizedBox(height: 10),
          TableCalendar(
            firstDay:
                DateTime.utc(DateTime.now().year, DateTime.now().month, 1),
            lastDay:
                DateTime.utc(DateTime.now().year, DateTime.now().month + 2, 31),
            focusedDay: DateTime.now(),
            calendarFormat: _calendarFormat,
            onFormatChanged: (format) {
              setState(() {
                _calendarFormat = format;
              });
            },
            weekendDays: [DateTime.saturday, DateTime.sunday],
            daysOfWeekStyle: DaysOfWeekStyle(
              weekendStyle: TextStyle(color: Colors.red),
            ),
            calendarStyle: CalendarStyle(
              weekendTextStyle: TextStyle(color: Colors.red),
            ),
            //Para no poder seleccionar el finde
            selectedDayPredicate: (day) {
              if (day.weekday == DateTime.saturday ||
                  day.weekday == DateTime.sunday) {
                return false;
              }
              return widget.openingCalendar.containsKey(day);
            },
            calendarBuilders: CalendarBuilders(
              defaultBuilder: (context, day, _) {
                if (widget.openingCalendar.containsKey(day) &&
                    widget.openingCalendar[day]!.contains('Closed')) {
                  return Container(
                    margin: const EdgeInsets.all(4.0),
                    padding: const EdgeInsets.only(top: 5.0),
                    alignment: Alignment.center,
                    child: Text(
                      day.day.toString(),
                      style: TextStyle(color: Colors.red),
                    ),
                  );
                }
              },
            ),
            onDaySelected: (selectedDay, focusedDay) {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Select Option'),
                  content: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              widget.openingCalendar.remove(selectedDay);
                            });
                            widget.onSaveChanges(widget.openingCalendar);
                            Navigator.pop(context);
                          },
                          child: Text('Open'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              widget.openingCalendar[selectedDay] = ['Closed'];
                            });
                            widget.onSaveChanges(widget.openingCalendar);
                            Navigator.pop(context);
                          },
                          child: Text('Close'),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                pulsado = true;
              });
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => OpeningHoursManager()),
              );
            },
            child: Text('Open Calendar Manager'),
          ),
        ],
      ),
    );
  }
}
