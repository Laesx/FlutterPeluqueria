import 'package:flutter/material.dart';
import 'package:flutter_peluqueria/screens/screens.dart';
import 'package:table_calendar/table_calendar.dart';
import './hours_screen.dart';
import 'package:flutter_peluqueria/models/models.dart';
import '../services/horarios_services.dart';

class CalendarScreen extends StatefulWidget {
  static final Map<DateTime, List<String>> openingCalendar = {};
  static bool _isDataLoaded = false;
  //Para manejar el estado de la pantalla de horas en la pantalla hours_screen.dart
  static bool get isDataLoaded => _isDataLoaded;
  static set isDataLoaded(bool value) {
    _isDataLoaded = value;
  }

  static List<DateTime> getClosedDays() {
    List<DateTime> closedDays = [];
    openingCalendar.forEach((day, status) {
      if (status.contains('Closed')) {
        closedDays.add(day);
      }
    });

    closedDays = closedDays.toSet().toList();
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

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  late List<Horario> oldHorario;
  static Horario horario = Horario.empty();
  Future? _loadHorariosFuture;
  bool holidaysLoaded = false;
  List<DateTime> festivosTotales = [];
  bool horariosPulsados = false;

  bool fechaIgual(DateTime fecha, List<DateTime> festivos) {
    String fechaS = fecha.toString();
    String fechaFinal = fechaS.split('Z')[0];

    for (DateTime festivo in festivos) {
      String festivoS = festivo.toString();
      if (fechaFinal == festivoS) {
        return true;
      }
    }
    return false;
  }

  void initState() {
    super.initState();
    if (!holidaysLoaded) {
      loadHorarios();
      holidaysLoaded = true;
    }
  }

  Future<void> loadHorarios() async {
    final horariosServices = HorariosServices();
    _loadHorariosFuture = horariosServices.loadHorarioPelu();
    oldHorario = await _loadHorariosFuture as List<Horario>;
    horario = oldHorario[0];

    festivosTotales = horario.festivos;
    CalendarScreen().setClosedDays(festivosTotales);
    //print('Festivos: ${horario.festivos}');
  }

  List<DateTime> getFestivos() {
    return festivosTotales;
  }

  void printFestivos() {
    //print('Festivosssssss: $festivosTotales');
  }

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
            return Scaffold(
                appBar: MiAppBar(),
                drawer: MiMenuDesplegable(),
                body: Center(
                    child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Calendario de Apertura',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TableCalendar(
                          firstDay: DateTime.utc(
                              DateTime.now().year, DateTime.now().month, 1),
                          lastDay: DateTime.utc(DateTime.now().year,
                              DateTime.now().month + 2, 31),
                          focusedDay: DateTime.now(),
                          //Para los formatos
                          calendarFormat: _calendarFormat,
                          onFormatChanged: (format) {
                            setState(() {
                              _calendarFormat = format;
                            });
                          },
                          calendarBuilders: CalendarBuilders(
                            defaultBuilder: (context, date, events) {
                              DateTime dayOnly =
                                  DateTime(date.year, date.month, date.day);

                              if (festivosTotales.contains(dayOnly)) {
                                return Text(
                                  date.day.toString(),
                                  style: TextStyle(color: Colors.red),
                                );
                              }

                              List<String>? states =
                                  CalendarScreen.openingCalendar[date];
                              String state = states != null && states.isNotEmpty
                                  ? states.first
                                  : '';
                              if (state == 'Closed') {
                                return Text(
                                  date.day.toString(),
                                  style: TextStyle(color: Colors.red),
                                );
                              } else {
                                return Text(date.day.toString());
                              }
                            },
                          ),

                          onDaySelected: (selectedDay, focusedDay) {
                            showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                      title: Text('Selecciona una opcion'),
                                      content: Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.8, // 80% of screen width
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.06,
                                        child: Center(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              ElevatedButton(
                                                onPressed: () {
                                                  setState(() {
                                                    CalendarScreen
                                                        .openingCalendar
                                                        .remove(selectedDay);
                                                  });
                                                  festivosTotales =
                                                      festivosTotales
                                                          .where((date) =>
                                                              !isSameDay(date,
                                                                  selectedDay))
                                                          .toList();
                                                  Navigator.pop(context);
                                                },
                                                child: Text('Abierto'),
                                              ),
                                              ElevatedButton(
                                                onPressed: () {
                                                  setState(() {
                                                    CalendarScreen
                                                            .openingCalendar[
                                                        selectedDay] = [
                                                      'Closed'
                                                    ];
                                                  });
                                                  if (!fechaIgual(selectedDay,
                                                      festivosTotales)) {
                                                    festivosTotales
                                                        .add(selectedDay);
                                                    festivosTotales =
                                                        festivosTotales
                                                            .toSet()
                                                            .toList();
                                                  }
                                                  Navigator.pop(context);
                                                },
                                                child: Text('Cerrado'),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ));
                          },
                        ),
                        SizedBox(
                          height: 80,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              horariosPulsados = true;
                            });
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => OpeningHoursManager()),
                            );
                          },
                          child: Text('Abrir gestion horarios apertura'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            if (horariosPulsados) {
                              List<Dia> daysOfWeek =
                                  OpeningHoursManager().getDaysOfWeek();
                              horario.setDiasSemana(daysOfWeek);
                            }
                            horario.setDiasFestivos(festivosTotales);
                            HorariosServices().saveHorarioPelu(horario);
                          },
                          child: Text('Guardar todos los cambios'),
                        ),
                      ],
                    ),
                  ),
                )));
          }
        });
  }
}
