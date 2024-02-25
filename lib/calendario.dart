import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

//Hay que importar el paquete table_calendar en el archivo pubspec.yaml

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
            showOpeningHoursDialog: _showOpeningHoursDialog,
          ),
        ],
      ),
    );
  }
}

class OpeningCalendar extends StatelessWidget {
  final Map<DateTime, List<String>> openingCalendar;
  final Function(Map<DateTime, List<String>> calendar) onSaveChanges;

  const OpeningCalendar({
    Key? key,
    required this.openingCalendar,
    required this.onSaveChanges,
  }) : super(key: key);

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
            calendarFormat: CalendarFormat.week,
            weekendDays: [DateTime.saturday, DateTime.sunday],
            daysOfWeekStyle: DaysOfWeekStyle(
              weekendStyle: TextStyle(color: Colors.red),
            ),
            selectedDayPredicate: (day) {
              return openingCalendar.containsKey(day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              // Implementa la lógica para cambiar el estado del día seleccionado (abierto/cerrado)
              final isOpen = openingCalendar.containsKey(selectedDay);
              final updatedCalendar = {...openingCalendar};
              if (isOpen) {
                updatedCalendar.remove(selectedDay);
              } else {
                updatedCalendar[selectedDay] = [];
              }
              onSaveChanges(updatedCalendar);
            },
          ),
        ],
      ),
    );
  }
}

class OpeningHours extends StatelessWidget {
  final Map<String, List<String>> openingHours;
  final Function(Map<String, List<String>> hours) onSaveChanges;
  final VoidCallback showOpeningHoursDialog;

  const OpeningHours({
    Key? key,
    required this.openingHours,
    required this.onSaveChanges,
    required this.showOpeningHoursDialog,
  }) : super(key: key);

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
          ListView.builder(
            shrinkWrap: true,
            itemCount: openingHours.length,
            itemBuilder: (context, index) {
              final day = openingHours.keys.elementAt(index);
              final hours = openingHours[day]!;
              final isOpen = hours.isNotEmpty;
              return ListTile(
                title: Row(
                  children: [
                    Text('$day: '),
                    if (isOpen)
                      Text(hours.join(', '))
                    else
                      Text('Cerrado', style: TextStyle(color: Colors.red)),
                  ],
                ),
                onTap: showOpeningHoursDialog,
              );
            },
          ),
        ],
      ),
    );
  }
}
