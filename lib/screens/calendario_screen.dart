import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import './hours_screen.dart';
import '../models/horario.dart';

class OpeningHoursCalendarScreen extends StatefulWidget {
  @override
  _OpeningHoursCalendarScreenState createState() =>
      _OpeningHoursCalendarScreenState();
}

class _OpeningHoursCalendarScreenState
    extends State<OpeningHoursCalendarScreen> {
  // Create instances of OpeningCalendar and OpeningHours
  late OpeningCalendar openingCalendar;

  @override
  void initState() {
    super.initState();

    // Initialize the OpeningCalendar and OpeningHours instances
    openingCalendar = OpeningCalendar();
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
          openingCalendar,
          // Use the OpeningCalendar instance
          // Use the OpeningHours instance

          // Botón para guardar cambios
          ElevatedButton(
            onPressed: () {
              // Get the closed days and opening hours from the instances
              List<DateTime> closedDays = openingCalendar.getClosedDays();
              // print the closed days and opening hours
              print(closedDays);
              // Save the closed days and opening hours to a file
              List<Dia> dias = OpeningHoursManager().getDaysOfWeek();
              OpeningHoursManager().printDays();
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
}

class _OpeningCalendarState extends State<OpeningCalendar> {
  CalendarFormat _calendarFormat = CalendarFormat.month;

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
/*
extension on TimeOfDay {
  String format24Hour(BuildContext context) {
    final MaterialLocalizations localizations =
        MaterialLocalizations.of(context);
    final String formattedTimeOfDay =
        localizations.formatTimeOfDay(this, alwaysUse24HourFormat: true);
    return formattedTimeOfDay;
  }
}

class OpeningHoursManager extends StatefulWidget {
  @override
  _OpeningHoursManagerState createState() => _OpeningHoursManagerState();
}

class _OpeningHoursManagerState extends State<OpeningHoursManager> {
  final List<String> _daysOfWeek = [
    'Lunes',
    'Martes',
    'Miércoles',
    'Jueves',
    'Viernes',
    'Sábado',
    'Domingo',
  ];

  Map<String, TimeOfDay> _morningOpeningTimes = {};
  Map<String, TimeOfDay> _morningClosingTimes = {};
  Map<String, TimeOfDay> _afternoonOpeningTimes = {};
  Map<String, TimeOfDay> _afternoonClosingTimes = {};
  Map<String, bool> _morningClosed = {};
  Map<String, bool> _afternoonClosed = {};

  @override
  void initState() {
    super.initState();
    _daysOfWeek.forEach((day) {
      _morningOpeningTimes[day] = TimeOfDay(hour: 9, minute: 0);
      _morningClosingTimes[day] = TimeOfDay(hour: 12, minute: 0);
      _afternoonOpeningTimes[day] = TimeOfDay(hour: 13, minute: 0);
      _afternoonClosingTimes[day] = TimeOfDay(hour: 17, minute: 0);
      _morningClosed[day] = false;
      _afternoonClosed[day] = false;
    });
  }

  void printSchedule() {
    for (String day in _daysOfWeek) {
      print('$day:');
      print(
          '  Mañana: ${_morningClosed[day]! ? "cerrado" : "${_morningOpeningTimes[day]!.format24Hour(context)} - ${_morningClosingTimes[day]!.format24Hour(context)}"}');
      print(
          '  Tarde: ${_afternoonClosed[day]! ? "cerrado" : "${_afternoonOpeningTimes[day]!.format24Hour(context)} - ${_afternoonClosingTimes[day]!.format24Hour(context)}"}');
    }
  }

  Future<void> _selectTime(BuildContext context, String day, bool isMorning,
      bool isOpeningTime) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isOpeningTime
          ? (isMorning
              ? _morningOpeningTimes[day]!
              : _afternoonOpeningTimes[day]!)
          : (isMorning
              ? _morningClosingTimes[day]!
              : _afternoonClosingTimes[day]!),
    );
    if (picked != null)
      setState(() {
        if (isOpeningTime) {
          if (isMorning) {
            _morningOpeningTimes[day] = picked;
          } else {
            _afternoonOpeningTimes[day] = picked;
          }
        } else {
          if (isMorning) {
            _morningClosingTimes[day] = picked;
          } else {
            _afternoonClosingTimes[day] = picked;
          }
        }
      });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: _daysOfWeek.length,
            itemBuilder: (context, index) {
              String day = _daysOfWeek[index];
              return Card(
                child: ListTile(
                  title: Text(day),
                  subtitle: Text(
                    'Mañana: ${_morningClosed[day]! ? "cerrado" : "${_morningOpeningTimes[day]!.format24Hour(context)} - ${_morningClosingTimes[day]!.format24Hour(context)}"}\n'
                    'Tarde: ${_afternoonClosed[day]! ? "cerrado" : "${_afternoonOpeningTimes[day]!.format24Hour(context)} - ${_afternoonClosingTimes[day]!.format24Hour(context)}"}',
                  ),
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                              title: Text('Select Option'),
                              content: SingleChildScrollView(
                                // Add this
                                child: Column(
                                  mainAxisSize: MainAxisSize.min, // Set this
                                  children: [
                                    ElevatedButton(
                                      onPressed: () =>
                                          _selectTime(context, day, true, true),
                                      child: Text('Hora apertura mañana'),
                                    ),
                                    ElevatedButton(
                                      onPressed: () => _selectTime(
                                          context, day, true, false),
                                      child: Text('Hora cierre mañana'),
                                    ),
                                    ElevatedButton(
                                      onPressed: () => _selectTime(
                                          context, day, false, true),
                                      child: Text('Hora apertura tarde'),
                                    ),
                                    ElevatedButton(
                                      onPressed: () => _selectTime(
                                          context, day, false, false),
                                      child: Text('Hora cierre tarde'),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        setState(() {
                                          _morningClosed[day] = true;
                                          _afternoonClosed[day] = true;
                                        });
                                        Navigator.pop(context);
                                      },
                                      child: Text('Cerrado (todo el dia)'),
                                    ),
                                  ],
                                ),
                              ),
                            ));
                  },
                ),
              );
            },
          ),
        ),
        ElevatedButton(
          onPressed: () {
            // Add your button functionality here
            printSchedule();
          },
          child: Text('Guardar cambios'),
        ),
      ],
    );
  }
}
*/
