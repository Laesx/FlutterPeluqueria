import 'package:flutter_peluqueria/theme/app_theme.dart';
import 'package:flutter/material.dart';

class BotonHora extends StatefulWidget {
  const BotonHora({
    Key? key,
    this.enabledTimes,
    required this.label,
    required this.value,
    required this.onPressed,
    required this.singleSelection,
    required this.timeSelected,
  }) : super(key: key);

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
  late bool selected;

  @override
  void initState() {
    super.initState();
    selected = widget.timeSelected == widget.value;
  }

  @override
  void didUpdateWidget(BotonHora oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.timeSelected != oldWidget.timeSelected) {
      setState(() {
        selected = widget.timeSelected == widget.value;
      });
    }
    //print("TimeSelected: ${widget.timeSelected}");
    //print("OldWidget: ${oldWidget.timeSelected}");
  }

  @override
  Widget build(BuildContext context) {
    final textColor = selected ? Colors.white : AppTheme.textColor;
    var buttonColor = selected ? AppTheme.buttonColor : Colors.black;
    final buttonBorderColor =
        selected ? AppTheme.primaryColor : AppTheme.textColor;

    final disableTime = widget.enabledTimes != null &&
        !widget.enabledTimes!.contains(widget.value);

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
                widget.onPressed(widget.value);
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
            widget.label,
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
