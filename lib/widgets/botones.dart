import 'package:flutter/material.dart';

// creating Stateless Widget for buttons
class MyButton extends StatelessWidget {
  // declaring variables
  final color;
  final textColor;
  final String buttonText;
  final buttontapped;
  final IconData? icon;

  //Constructor
  const MyButton(
      {super.key,
      this.color,
      this.textColor,
      required this.buttonText,
      this.buttontapped,
      this.icon});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(0.2),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(50),
          child: Stack(children: <Widget>[
            Positioned.fill(
                child: Container(
              color: color,
              child: TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: textColor,
                  textStyle: TextStyle(
                    color: textColor,
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: buttontapped,
                // Si el icono es nulo, no se muestra y se muestra texto
                child: icon != null
                    ? Icon(
                        icon,
                        color: textColor,
                      )
                    : Text(
                        buttonText,
                        style: TextStyle(
                          color: textColor,
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ))
          ]),
        ));
  }
}
