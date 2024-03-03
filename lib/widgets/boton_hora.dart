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
    this.disabled = false,
  }) : super(key: key);

  final List<int>? enabledTimes;
  final String label;
  final int value;
  final ValueChanged<int> onPressed;
  final bool singleSelection;
  final int? timeSelected;
  final bool? disabled;

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
    final textColor = selected ? Colors.white : Colors.black;
    var buttonColor = selected ? Colors.black : Colors.white;
    final buttonBorderColor = selected ? AppTheme.primaryColor : Colors.black;

    //final disableTime = widget.enabledTimes != null && !widget.enabledTimes!.contains(widget.value);
    final disableTime = widget.disabled == true;

    if (disableTime) {
      buttonColor = Colors.grey[400]!;
    }

    return GestureDetector(
      onTap: disableTime
          ? null
          : () {
              setState(() {
                selected = !selected;
                widget.onPressed(widget.value);
              });
            },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        width: 75,
        height: 43,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(selected ? 16 : 8),
          color: buttonColor,
          border: Border.all(color: buttonBorderColor),
          boxShadow: [
            BoxShadow(
              color: (!selected
                  ? Colors.black.withOpacity(0.4)
                  : AppTheme.primaryColor.withOpacity(0.5)),
              spreadRadius: 1,
              blurRadius: 2,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: Text(
            widget.label,
            style: TextStyle(
              color: textColor,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
