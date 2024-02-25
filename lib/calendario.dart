import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class OpeningHoursCalendarScreen extends StatefulWidget {
  @override
  _OpeningHoursCalendarScreenState createState() =>
      _OpeningHoursCalendarScreenState();
}

class _OpeningHoursCalendarScreenState
    extends State<OpeningHoursCalendarScreen> {
  late Map<DateTime, List<String>> _openingCalendar;
  late Map<String, List<String>> _openingHours;

  @override
  void initState() {
    super.initState();
    _initOpeningCalendar();
    _initOpeningHours();
  }

  // Inicializa el calendario de apertura con días abiertos por defecto
  void _initOpeningCalendar() {
    _openingCalendar = {};
    // Ejemplo: Todos los días de la semana están abiertos por defecto
    final now = DateTime.now();
    for (int i = 0; i < 7; i++) {
      final date = now.add(Duration(days: i));
      _openingCalendar[date] = [];
    }
  }

  // Inicializa el horario de apertura predeterminado
  void _initOpeningHours() {
    _openingHours = {
      'Lunes': ['9:00 - 13:30', '16:00 - 21:00'],
      'Martes': ['9:00 - 13:30', '16:00 - 21:00'],
      'Miércoles': ['9:00 - 13:30', '16:00 - 21:00'],
      'Jueves': ['9:00 - 13:30', '16:00 - 21:00'],
      'Viernes': ['9:00 - 15:00'],
      'Sábado': [],
      'Domingo': [],
    };
  }

  // Método para guardar los cambios en el calendario de apertura
  void _saveOpeningCalendarChanges(Map<DateTime, List<String>> calendar) {
    setState(() {
      _openingCalendar = calendar;
    });
    // Aquí puedes implementar la lógica para guardar los cambios en el calendario de apertura
  }

  // Método para guardar los cambios en el horario de apertura
  void _saveOpeningHoursChanges(Map<String, List<String>> hours) {
    setState(() {
      _openingHours = hours;
    });
    // Aquí puedes implementar la lógica para guardar los cambios en el horario de apertura
  }

  // Método para mostrar un diálogo para establecer el horario de apertura
  void _showOpeningHoursDialog() {
    // Aquí puedes implementar la lógica para mostrar un diálogo donde los gerentes puedan establecer el horario de apertura
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
          // Componente de calendario de apertura
          OpeningCalendar(
            openingCalendar: _openingCalendar,
            onSaveChanges: _saveOpeningCalendarChanges,
          ),
          // Componente de horario de apertura
          OpeningHours(
            openingHours: _openingHours,
            onSaveChanges: _saveOpeningHoursChanges,
          ),
        ],
      ),
    );
  }
}

class OpeningCalendar extends StatefulWidget {
  final Map<DateTime, List<String>> openingCalendar;
  final Function(Map<DateTime, List<String>> calendar) onSaveChanges;

  const OpeningCalendar({
    Key? key,
    required this.openingCalendar,
    required this.onSaveChanges,
  }) : super(key: key);

  @override
  _OpeningCalendarState createState() => _OpeningCalendarState();
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
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: DateTime.now(),
            calendarFormat: _calendarFormat,
            weekendDays: [DateTime.saturday, DateTime.sunday],
            daysOfWeekStyle: DaysOfWeekStyle(
              weekendStyle: TextStyle(color: Colors.red),
            ),
            calendarStyle: CalendarStyle(
              weekendTextStyle: TextStyle(color: Colors.red),
            ),
            selectedDayPredicate: (day) {
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
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          final updatedCalendar = {...widget.openingCalendar};
                          updatedCalendar.remove(selectedDay);
                          widget.onSaveChanges(updatedCalendar);
                          Navigator.pop(context);
                        },
                        child: Text('Open'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          final updatedCalendar = {...widget.openingCalendar};
                          updatedCalendar[selectedDay] = ['Closed'];
                          widget.onSaveChanges(updatedCalendar);
                          Navigator.pop(context);
                        },
                        child: Text('Close'),
                      ),
                    ],
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
  final Map<String, List<String>> openingHours;
  final Function(Map<String, List<String>> hours) onSaveChanges;

  const OpeningHours({
    Key? key,
    required this.openingHours,
    required this.onSaveChanges,
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
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Horario de Apertura',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: () {
                  _selectTime(context, 'opening');
                },
                child: Text('Asignar Hora de Apertura'),
              ),
              ElevatedButton(
                onPressed: () {
                  _selectTime(context, 'closing');
                },
                child: Text('Asignar Hora de Cierre'),
              ),
            ],
          ),
          Text('Opening Hour: ${widget.openingHours['opening']}'),
          Text('Closing Hour: ${widget.openingHours['closing']}'),
        ],
      ),
    );
  }
}
