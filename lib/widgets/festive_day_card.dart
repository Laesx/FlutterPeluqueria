import 'package:flutter/material.dart';
import 'package:flutter_peluqueria/theme/app_theme.dart';

class FestiveDayCard extends StatelessWidget {
  const FestiveDayCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      child: Container(
        width: double.infinity,
        height: 50,
        margin: const EdgeInsets.only(top: 10, bottom: 10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            boxShadow: const [
              BoxShadow(
                color: Colors.black,
                offset: Offset(0.2, 0.2),
                blurRadius: 2,
              )
            ]),
        child: const Center(
          
        ),
      ),
    );
  }
}