import 'package:flutter/material.dart';

class MiAppBar extends AppBar {
  MiAppBar({Key? key})
      : super(
          key: key,
          title: Text('Mi App'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {
                // TODO: implementar la lógica de presionar el botón de menú
              },
            ),
          ],
        );
}
