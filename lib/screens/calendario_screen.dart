import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class OpeningHoursCalendarScreen extends StatefulWidget {
  @override
  _OpeningHoursCalendarScreenState createState() =>
      _OpeningHoursCalendarScreenState();
}

class _OpeningHoursCalendarScreenState
    extends State<OpeningHoursCalendarScreen> {
  // Create instances of OpeningCalendar and OpeningHours
  late OpeningCalendar openingCalendar;
  late OpeningHours openingHours;

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
          // Use the OpeningCalendar instance
          openingCalendar,

          // Botón para guardar cambios
          ElevatedButton(
            onPressed: () {
              // Get the closed days and opening hours from the instances
              List<DateTime> closedDays = openingCalendar.getClosedDays();
              print(closedDays);
              //Map<String, List<String>> openingHoursData = openingHours.getOpeningHours();

              // Do something with closedDays and openingHoursData...
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
        ],
      ),
    );
  }
}

class OpeningHours extends StatefulWidget {
  final Map<String, List<String>> openingHours = {};
  final Function(Map<String, List<String>> hours) onSaveChanges = (hours) => {};

  OpeningHours({
    Key? key,
  }) : super(key: key);

  @override
  _OpeningHoursState createState() => _OpeningHoursState();
}

class _OpeningHoursState extends State<OpeningHours> {
  Future<void> _selectTime(BuildContext context, String type) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        widget.openingHours[type] = [picked.format(context)];
      });
      widget.onSaveChanges(widget.openingHours);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Flexible(
        child: Padding(
            padding: EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Horario de Apertura Mañana',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(height: 10),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          _selectTime(context, 'opening');
                        },
                        child: Text('Apertura'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          _selectTime(context, 'closing');
                        },
                        child: Text('Cierre'),
                      ),
                    ],
                  ),
                  Text(
                      'Opening Hour Morning: ${widget.openingHours['opening']}'),
                  Text(
                      'Closing Hour Morning: ${widget.openingHours['closing']}'),
                  Text(
                    'Horario de Apertura Tarde',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(height: 10),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          _selectTime(context, 'opening');
                        },
                        child: Text('Apertura'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          _selectTime(context, 'closing');
                        },
                        child: Text('Cierre'),
                      ),
                    ],
                  ),
                  Text(
                      'Opening Hour Afternoon: ${widget.openingHours['opening']}'),
                  Text(
                      'Closing Hour Afternoon: ${widget.openingHours['closing']}'),
                  SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: () {},
                    child: Text('Guardar cambios!'),
                  ),
                ],
              ),
            )));
  }
}
