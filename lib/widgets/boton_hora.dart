import 'package:flutter_peluqueria/theme/app_theme.dart';
import 'package:flutter/material.dart';

class BotonHora extends StatefulWidget {
  const BotonHora({
    super.key,
    this.enabledTimes,
    required this.label,
    required this.value,
    required this.onPressed,
    required this.singleSelection,
    required this.timeSelected,
  });

  final List<int>? enabledTimes;
  final String label;
  final int value;
  final ValueChanged<int> onPressed;
  final bool singleSelection;
  final int? timeSelected;

  @override
  State<BotonHora> createState() => _BotonHoraState();
}

class _BotonHoraState extends State<BotonHora> {
  var selected = false;

  @override
  Widget build(BuildContext context) {
    final BotonHora(
      :singleSelection,
      :timeSelected,
      :value,
      :label,
      :enabledTimes,
      :onPressed,
    ) = widget;

    if (singleSelection && timeSelected != null) {
      selected = timeSelected == value;
    }

    final textColor = selected ? Colors.white : AppTheme.textColor;
    var buttonColor = selected ? AppTheme.buttonColor : Colors.black;
    final buttonBorderColor =
        selected ? AppTheme.primaryColor : AppTheme.textColor;

    final disableTime = enabledTimes != null && !enabledTimes.contains(value);

    if (disableTime) {
      buttonColor = Colors.grey[400]!;
    }

    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: disableTime
          ? null
          : () {
              setState(() {
                selected = !selected;
                onPressed(value);
              });
            },
      child: Container(
        width: 64,
        height: 36,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: buttonColor,
          border: Border.all(color: buttonBorderColor),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: textColor,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
