import 'package:flutter/material.dart';
import 'package:flutter_peluqueria/models/models.dart';
import 'package:flutter_peluqueria/widgets/widgets.dart';
import 'package:table_calendar/table_calendar.dart';
import '../utils.dart';

class CalendarReservationsTest extends StatefulWidget {
  const CalendarReservationsTest({super.key});

  @override
  State<CalendarReservationsTest> createState() =>
      _CalendarReservationsTestState();
}

class _CalendarReservationsTestState extends State<CalendarReservationsTest> {
  late final ValueNotifier<Horario> _selectedSchedule;
  final CalendarFormat _calendarFormat = CalendarFormat.week;
  final RangeSelectionMode _rangeSelectionMode = RangeSelectionMode.disabled;
  // Este de abajo se puede cambiar por el de arriba para que se pueda seleccionar un rango de fechas
  // Manteniendo pulsado el de abajo se puede seleccionar un rango de fechas
  //RangeSelectionMode _rangeSelectionMode2 = RangeSelectionMode.toggledOff;

  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();

    _selectedDay = _focusedDay;
    _selectedSchedule = ValueNotifier(_getScheduleForDay(_selectedDay!));
  }

  @override
  void dispose() {
    _selectedSchedule.dispose();
    super.dispose();
  }

  Horario _getScheduleForDay(DateTime day) {
    DateTime start = DateTime(day.year, day.month, day.day, 8, 0);
    DateTime end = DateTime(day.year, day.month, day.day, 20, 0);
    Horario horario = Horario(
      peluquero: 'Peluquero 1',
      horario: [start, end],
    );

    return horario;
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
      });

      _selectedSchedule.value = _getScheduleForDay(selectedDay);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TableCalendar<Horario>(
          locale: 'es_ES',
          firstDay: kFirstDay,
          lastDay: kLastDay,
          focusedDay: _focusedDay,
          selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
          calendarFormat: _calendarFormat,
          availableCalendarFormats: const {CalendarFormat.week: 'Week'},
          rangeSelectionMode: _rangeSelectionMode,
          startingDayOfWeek: StartingDayOfWeek.monday,
          calendarStyle: const CalendarStyle(
            // Use `CalendarStyle` to customize the UI
            outsideDaysVisible: false,
          ),
          onDaySelected: _onDaySelected,
          onPageChanged: (focusedDay) {
            _focusedDay = focusedDay;
          },
        ),
        const SizedBox(height: 8.0),
        Expanded(
          child: ValueListenableBuilder<Horario>(
            valueListenable: _selectedSchedule,
            builder: (context, horario, _) {
              return ListView.builder(
                itemCount: horario.horario.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 12.0,
                      vertical: 4.0,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: ListTile(
                      onTap: () => print('${horario.peluquero}'),
                      title: Text('${horario.toMap()["horario"]}'),
                    ),
                  );
                },
              );
            },
          ),
        ),
        Wrap(
          spacing: 8,
          runSpacing: 16,
          children: [
            for (int i = 0; i <= 2; i++) ...[
              TimeButton(
                label: '${i.toString().padLeft(2, '0')}:00',
                value: i,
                timeSelected: 1,
                singleSelection: true,
                onPressed: (timeSelected) {},
              ),
            ],
          ],
        ),
      ],
    );
  }
}
