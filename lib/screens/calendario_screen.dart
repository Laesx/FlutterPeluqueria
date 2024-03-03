import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import './hours_screen.dart';
import 'package:flutter_peluqueria/models/models.dart';
import '../services/horarios_services.dart';

class CalendarScreen extends StatefulWidget {
  static bool _isDataLoaded = false;
  //Para manejar el estado de la pantalla de horas en la pantalla hours_screen.dart
  static bool get isDataLoaded => _isDataLoaded;
  static set isDataLoaded(bool value) {
    _isDataLoaded = value;
  }

  static bool getFestivoLoaded() {
    return _CalendarScreenState.getFestivoLoaded();
  }

  static List<DateTime> getClosedDays() {
    return _CalendarScreenState.getClosedDays();
  }

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late List<Horario> oldHorario;
  static Horario horario = Horario.empty();
  Future? _loadHorariosFuture;
  static late OpeningCalendar openingCalendar;
  static bool festivosLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadHorariosFuture = loadHorarios();
  }

  static bool getFestivoLoaded() {
    return festivosLoaded;
  }

  Future loadHorarios() async {
    oldHorario = await HorariosServices().loadHorarioPelu();
    horario = oldHorario[0];
    openingCalendar = OpeningCalendar();
    openingCalendar.setClosedDays(horario.festivos); // Set the closed days here
  }

  static List<DateTime> getClosedDays() {
    return openingCalendar.getClosedDays();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _loadHorariosFuture,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator(); // Show a loading spinner while waiting for the data
          } else if (snapshot.hasError) {
            return Text(
                'Error: ${snapshot.error}'); // Show an error message if something went wrong
          } else {
            // The data has loaded, you can build your widget here
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

                  ElevatedButton(
                      onPressed: () {
                        // Get the closed days
                        //print the closed days and opening hours
                        print(_CalendarScreenState.getClosedDays());
                      },
                      child: Text('Print closed days')),

                  ElevatedButton(
                    onPressed: () {
                      List<DateTime> oldClosedDays = horario.festivos;
                      List<DateTime> closedDays =
                          openingCalendar.getClosedDays();

                      if (oldClosedDays != closedDays) {
                        horario.setDiasFestivos(closedDays);
                      }

                      if (OpeningCalendar.pushed()) {
                        List<Dia> dias = OpeningHoursManager().getDaysOfWeek();
                        horario.setDiasSemana(dias);
                      }

                      // Only save once, after all changes have been made
                      HorariosServices().saveHorarioPelu(horario);
                    },
                    child: Text('Guardar man'),
                  ),
                ],
              ),
            );
          }
        });
  }
}

class OpeningCalendar extends StatefulWidget {
  final Map<DateTime, List<String>> openingCalendar = {};
  final Function(Map<DateTime, List<String>> calendar) onSaveChanges =
      (calendar) {};

  static List<DateTime> closedDays = [];

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
        print('Festivo: $day ');
      }
    });

    closedDays = closedDays.toSet().toList();
    print('Festivosss: $closedDays');
    return closedDays;
  }

  void setClosedDays(List<DateTime> closedDays) {
    openingCalendar.clear(); // Clear the existing map

    // Iterate over all closed days
    for (DateTime closedDay in closedDays) {
      // Set the status of the closed day to 'Closed'
      openingCalendar[closedDay] = ['Closed'];
    }
  }
}

class _OpeningCalendarState extends State<OpeningCalendar> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  static bool pulsado = false;
  static List<DateTime> closedDays = CalendarScreen.getClosedDays();
  bool festivosLoaded = false;

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
            selectedDayPredicate: (day) {
              if (day.weekday == DateTime.saturday ||
                  day.weekday == DateTime.sunday) {
                return false;
              }
              return widget.openingCalendar.containsKey(day);
            },
            calendarBuilders: CalendarBuilders(
              defaultBuilder: (context, day, _) {
                DateTime dayOnly = DateTime(day.year, day.month, day.day);

                if (closedDays.contains(dayOnly) && !festivosLoaded) {
                  setState(() {
                    festivosLoaded = true;
                  });
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
                if (widget.openingCalendar.containsKey(day) &&
                    widget.openingCalendar[day]!.contains('Closed')) {
                  print(
                      'Day is in openingCalendar and marked as Closed: $day'); // Debug print
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
                return null;
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
