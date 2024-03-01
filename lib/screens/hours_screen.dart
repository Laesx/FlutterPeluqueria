import 'package:flutter/material.dart';

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
                              child: Text('Change Morning Opening Time'),
                            ),
                            ElevatedButton(
                              onPressed: () =>
                                  _selectTime(context, day, true, false),
                              child: Text('Change Morning Closing Time'),
                            ),
                            ElevatedButton(
                              onPressed: () =>
                                  _selectTime(context, day, false, true),
                              child: Text('Change Afternoon Opening Time'),
                            ),
                            ElevatedButton(
                              onPressed: () =>
                                  _selectTime(context, day, false, false),
                              child: Text('Change Afternoon Closing Time'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  _morningClosed[day] = true;
                                  _afternoonClosed[day] = true;
                                });
                                Navigator.pop(context);
                              },
                              child: Text('Closed'),
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
          },
          child: Text('Guardar cambios'),
        ),
      ],
    );
  }
}
