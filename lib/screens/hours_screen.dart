import 'package:flutter/material.dart';
import 'package:flutter_peluqueria/models/models.dart';
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

  void printDays() {
    _OpeningHoursManagerState.printDays();
  }
}

class _OpeningHoursManagerState extends State<OpeningHoursManager> {
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

  static printDays() {
    List<Dia> daysOfWeek = getDaysOfWeek();
    List<String> day = _daysOfWeek;

    for (Dia dia in daysOfWeek) {
      print("Dia: " + day[daysOfWeek.indexOf(dia)]);
      print("Empieza mañana: " + dia.empiezaMan);
      print("Acaba mañana: " + dia.acabaMan);
      print("Empieza tarde: " + dia.empiezaTarde);
      print("Acaba tarde: " + dia.acabaTarde);
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
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ElevatedButton(
                              onPressed: () =>
                                  _selectTime(context, day, true, true),
                              child: Text('Hora apertura mañana'),
                            ),
                            ElevatedButton(
                              onPressed: () =>
                                  _selectTime(context, day, true, false),
                              child: Text('Hora cierre mañana'),
                            ),
                            ElevatedButton(
                              onPressed: () =>
                                  _selectTime(context, day, false, true),
                              child: Text('Hora apertura tarde'),
                            ),
                            ElevatedButton(
                              onPressed: () =>
                                  _selectTime(context, day, false, false),
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
                  },
                ),
              );
            },
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
    );
  }
}
