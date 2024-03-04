import 'package:flutter/material.dart';
import 'package:flutter_peluqueria/models/models.dart';
import '../services/horarios_services.dart';
import './calendario_screen.dart  ';

import 'package:intl/intl.dart';

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

  List<Dia> getDaysOfWeek() {
    return _OpeningHoursManagerState.getDaysOfWeek();
  }
}

class _OpeningHoursManagerState extends State<OpeningHoursManager> {
  late List<Horario> oldHorario;
  static Horario horario = Horario.empty();
  Future? _loadHorariosFuture;
  bool _isDataLoaded = CalendarScreen.isDataLoaded;

  static List<String> _daysOfWeek = [
    'Lunes',
    'Martes',
    'Miércoles',
    'Jueves',
    'Viernes',
    'Sábado',
    'Domingo',
  ];

  static Map<String, TimeOfDay> _morningOpeningTimes = {};
  static Map<String, TimeOfDay> _morningClosingTimes = {};
  static Map<String, TimeOfDay> _afternoonOpeningTimes = {};
  static Map<String, TimeOfDay> _afternoonClosingTimes = {};
  static Map<String, bool> _morningClosed = {};
  static Map<String, bool> _afternoonClosed = {};

  @override
  void initState() {
    super.initState();
    if (!_isDataLoaded) {
      loadHorarios();
      _isDataLoaded = true;
      CalendarScreen.isDataLoaded = true;
      _loadHorariosFuture = loadHorarios();
    }
  }

  Future<bool> neededChange(BuildContext context, String dia) async {
    if (_morningClosed[dia]! && _afternoonClosed[dia]!) {
      bool? result = await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Default hours for $dia'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text('Morning: 11:00 - 14:00'),
                Text('Afternoon: 17:00 - 20:00'),
              ],
            ),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              ),
            ],
          );
        },
      );

      if (result == true) {
        _morningOpeningTimes[dia] = TimeOfDay(hour: 11, minute: 0);
        _morningClosingTimes[dia] = TimeOfDay(hour: 14, minute: 0);
        _afternoonOpeningTimes[dia] = TimeOfDay(hour: 17, minute: 0);
        _afternoonClosingTimes[dia] = TimeOfDay(hour: 20, minute: 0);
        _morningClosed[dia] = false;
        _afternoonClosed[dia] = false;

        return true;
      }
    }

    return false;
  }

  Future loadHorarios() async {
    oldHorario = await HorariosServices().loadHorarioPelu();
    if (oldHorario.isNotEmpty) {
      horario = oldHorario[0];

      List<Dia> diasHorario = horario.getDiasSemana();

      for (int i = 0; i < diasHorario.length; i++) {
        Dia dia = diasHorario[i];

        if (dia.empiezaMan != "cerrado") {
          _morningOpeningTimes[_daysOfWeek[i]] = TimeOfDay(
            hour: int.parse(dia.empiezaMan.split(":")[0]),
            minute: int.parse(dia.empiezaMan.split(":")[1]),
          );
        }

        if (dia.acabaMan != "cerrado") {
          _morningClosingTimes[_daysOfWeek[i]] = TimeOfDay(
            hour: int.parse(dia.acabaMan.split(":")[0]),
            minute: int.parse(dia.acabaMan.split(":")[1]),
          );
        }

        if (dia.empiezaTarde != "cerrado") {
          _afternoonOpeningTimes[_daysOfWeek[i]] = TimeOfDay(
            hour: int.parse(dia.empiezaTarde.split(":")[0]),
            minute: int.parse(dia.empiezaTarde.split(":")[1]),
          );
        }

        if (dia.acabaTarde != "cerrado") {
          _afternoonClosingTimes[_daysOfWeek[i]] = TimeOfDay(
            hour: int.parse(dia.acabaTarde.split(":")[0]),
            minute: int.parse(dia.acabaTarde.split(":")[1]),
          );
        }

        _morningClosed[_daysOfWeek[i]] = dia.empiezaMan == "cerrado";
        _afternoonClosed[_daysOfWeek[i]] = dia.empiezaTarde == "cerrado";
      }
    }
  }

  static formatTimeOfDay(TimeOfDay tod) {
    final now = new DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
    final format = DateFormat('HH:mm'); // 24 hour format
    return format.format(dt);
  }

  static List<Dia> getDaysOfWeek() {
    List<Dia> daysOfWeek = [];
    Dia? dia;
    for (String day in _daysOfWeek) {
      if (!_morningClosed[day]! && !_afternoonClosed[day]!) {
        dia = Dia(
          empiezaMan: formatTimeOfDay(_morningOpeningTimes[day]!),
          empiezaTarde: formatTimeOfDay(_afternoonOpeningTimes[day]!),
          acabaMan: formatTimeOfDay(_morningClosingTimes[day]!),
          acabaTarde: formatTimeOfDay(_afternoonClosingTimes[day]!),
        );
      } else {
        dia = Dia(
          empiezaMan: "cerrado",
          empiezaTarde: "cerrado",
          acabaMan: "cerrado",
          acabaTarde: "cerrado",
        );
      }

      daysOfWeek.add(dia);
    }
    return daysOfWeek;
  }

  int compareTimeOfDay(TimeOfDay t1, TimeOfDay t2) {
    final t1InMinutes = t1.hour * 60 + t1.minute;
    final t2InMinutes = t2.hour * 60 + t2.minute;
    return t1InMinutes.compareTo(t2InMinutes);
  }

  Future<void> _selectTime(BuildContext context, String day, bool isMorning,
      bool isOpeningTime) async {
    final initialTime = isOpeningTime
        ? (isMorning
            ? _morningOpeningTimes[day]!
            : _afternoonOpeningTimes[day]!)
        : (isMorning
            ? _morningClosingTimes[day]!
            : _afternoonClosingTimes[day]!);
    int selectedHour = initialTime.hour;
    int selectedMinute = initialTime.minute;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        //print('Mostrando menu?');
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Text('Select a time'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text('Selected time: $selectedHour:$selectedMinute'),
                  DropdownButton<int>(
                    value: selectedHour,
                    items:
                        List<DropdownMenuItem<int>>.generate(24, (int index) {
                      return DropdownMenuItem<int>(
                        value: index,
                        child: Text(index.toString()),
                      );
                    }),
                    onChanged: (int? value) {
                      setState(() {
                        selectedHour = value!;
                      });
                    },
                  ),
                  DropdownButton<int>(
                    value: selectedMinute,
                    items: List<DropdownMenuItem<int>>.generate(4, (int index) {
                      return DropdownMenuItem<int>(
                        value: index * 15,
                        child: Text((index * 15).toString()),
                      );
                    }),
                    onChanged: (int? value) {
                      setState(() {
                        selectedMinute = value!;
                      });
                    },
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  child: Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                    child: Text('OK'),
                    onPressed: () {
                      TimeOfDay selectedTime =
                          TimeOfDay(hour: selectedHour, minute: selectedMinute);
                      if (isOpeningTime) {
                        if (isMorning) {
                          if (_morningClosingTimes[day] != null &&
                              compareTimeOfDay(selectedTime,
                                      _morningClosingTimes[day]!) >
                                  0) {
                            return;
                          }
                        } else {
                          if (_morningClosingTimes[day] != null &&
                              compareTimeOfDay(selectedTime,
                                      _morningClosingTimes[day]!) <
                                  0) {
                            return;
                          } else {
                            if (_afternoonClosingTimes[day] != null &&
                                compareTimeOfDay(selectedTime,
                                        _afternoonClosingTimes[day]!) >
                                    0) {
                              return;
                            }
                          }
                        }
                      } else {
                        if (isMorning) {
                          if (_morningOpeningTimes[day] != null &&
                              compareTimeOfDay(selectedTime,
                                      _morningOpeningTimes[day]!) <
                                  0) {
                            return;
                          } else {
                            if (_afternoonOpeningTimes[day] != null &&
                                compareTimeOfDay(selectedTime,
                                        _afternoonOpeningTimes[day]!) >
                                    0) {
                              return;
                            }
                          }
                        } else {
                          if (_afternoonOpeningTimes[day] != null &&
                              compareTimeOfDay(selectedTime,
                                      _afternoonOpeningTimes[day]!) <
                                  0) {
                            return;
                          }
                        }
                      }

                      Navigator.of(context).pop(TimeOfDay(
                          hour: selectedHour, minute: selectedMinute));
                    }),
              ],
            );
          },
        );
      },
    ).then((selectedTime) {
      if (selectedTime != null)
        setState(() {
          if (isOpeningTime) {
            if (isMorning) {
              _morningOpeningTimes[day] = selectedTime;
              _morningClosed[day] = false;
            } else {
              _afternoonOpeningTimes[day] = selectedTime;
              _afternoonClosed[day] = false;
            }
          } else {
            if (isMorning) {
              _morningClosingTimes[day] = selectedTime;
              _morningClosed[day] = false;
            } else {
              _afternoonClosingTimes[day] = selectedTime;
              _afternoonClosed[day] = false;
            }
          }
        });
    });
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
                        onTap: () async {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text('Select Option'),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      _selectTime(context, day, true, true);
                                    },
                                    child: Text('Hora apertura mañana'),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      _selectTime(context, day, true, false);
                                    },
                                    child: Text('Hora cierre mañana'),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      _selectTime(context, day, false, true);
                                    },
                                    child: Text('Hora apertura tarde'),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      _selectTime(context, day, false, false);
                                    },
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
                          );
                          neededChange(context, day);
                        },
                      ),
                    );
                  },
                ),
              ),
              Column(
                children: <Widget>[
                  Card(
                    child: ListTile(
                      title: Text('Informacion horario por defecto'),
                      subtitle:
                          Text('Mañana: 11:00 - 14:00\nTarde: 17:00 - 20:00'),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Add your button functionality here
                      Navigator.pop(context);
                    },
                    child: Text('Guardar cambios'),
                  ),
                ],
              )
            ],
          );
        }
      },
    );
  }
}
