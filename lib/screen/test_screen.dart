import 'package:flutter/material.dart';
import 'package:flutter_peluqueria/widgets/hours_panel.dart';
import '../widgets/widgets.dart';

class TestScreen extends StatelessWidget {
  const TestScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TestScreen'),
      ),
      body: Column(
        children: [
          CalendarBar(),
          HoursPanel(startTime: 6, endTime: 23, onTimePressed: (int time) {}),

          /*
          Expanded(
            // Zona de los botones
            flex: 2,
            child: GridView.builder(
                itemCount: 10,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10),
                // Esta sección es la que crea los botones, también
                // tiene en cuenta si es un operador o algún otro boton con
                // función diferente, además de cambiarle el color
                itemBuilder: (BuildContext context, int index) {
                  return MyButton(
                    color: Colors.blue,
                    textColor: Colors.white,
                    buttonText: index.toString(),
                    buttontapped: () {},
                  );
                }),
          ),
          */
        ],
      ),
    );
  }
}
