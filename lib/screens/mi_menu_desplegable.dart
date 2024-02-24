import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class MiMenuDesplegable extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          ListTile(
            title: Text('Cerrar sesión'),
            onTap: () {
              // TODO: implementar la lógica de cerrar sesión
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text('Contactar por WhatsApp'),
            onTap: () async {
              // Número de teléfono de la peluquería
              String phoneNumber =
                  'xxxxxxxxxx'; // Reemplaza xxxxxxxxxx con el número de teléfono real

              // Construir el enlace de WhatsApp
              String whatsappUrl = 'https://wa.me/$phoneNumber';

              // Lanzar el enlace
              await launch(whatsappUrl);

              // Cerrar el menú desplegable
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text('Calendario y horario de apertura'),
            onTap: () {
              // Implementa la lógica del calendario y horario de apertura
              String calendarioUrl = 'url_calendario_horarios';
              launch(calendarioUrl);
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text('Gestión de peluqueros'),
            onTap: () {
              // Implementa la lógica de gestión de peluqueros
              String gestionUrl = 'url_gestion_peluqueros';
              launch(gestionUrl);
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text('Reservas'),
            onTap: () {
              // Implementa la lógica de reservas
              String reservasUrl = 'url_reservas';
              launch(reservasUrl);
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text('Comprobación de horarios'),
            onTap: () {
              // Implementa la lógica de comprobación de horarios
              String horariosUrl = 'url_comprobacion_horarios';
              launch(horariosUrl);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
