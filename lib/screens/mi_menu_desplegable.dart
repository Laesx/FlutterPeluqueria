import 'package:flutter/material.dart';
import 'package:flutter_peluqueria/app_routes/app_routes.dart';
import 'package:flutter_peluqueria/providers/providers.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../providers/providers.dart';

class MiMenuDesplegable extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userProvider =
        Provider.of<ConnectedUserProvider>(context, listen: false);
    String rol = userProvider.getActiveUserRol()!.toLowerCase();

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName:
                Text("Conectado como: ${userProvider.activeUser.nombre}"),
            accountEmail: Text("Rol: $rol"),
          ),
          ListTile(
            title: const Text('Inicio'),
            leading: Icon(Icons.home),
            onTap: () {
              Navigator.pushNamed(context, 'home');
            },
          ),
          if (rol == "gerente" || rol == "peluquero")
            ListTile(
              title: const Text('Horario de Trabajo'),
              leading: Icon(Icons.calendar_today),
              onTap: () {
                Navigator.pushNamed(context, 'schedule');
              },
            ),
          if (rol == "gerente")
            ListTile(
              title: const Text('Gestión de Peluqueros'),
              leading: Icon(Icons.people),
              onTap: () {
                Navigator.pushNamed(context, 'gestion');
              },
            ),
          if (rol == "gerente")
            ListTile(
              title: const Text('Horario Peluquería'),
              leading: Icon(Icons.calendar_today),
              onTap: () {
                Navigator.pushNamed(context, 'horario');
              },
            ),
          ListTile(
            title: const Text('Reservas'),
            leading: Icon(Icons.calendar_today),
            onTap: () {
              Navigator.pushNamed(context, 'reservas');
            },
          ),
          ListTile(
            title: const Text('Registro'),
            leading: Icon(Icons.app_registration_outlined),
            onTap: () {
              Navigator.pushNamed(context, 'registro');
            },
          ),
          Divider(
            thickness: 0.5,
            color: Colors.grey[400],
          ),
          ListTile(
            title: Column(
              children: [
                Text("Contacta!"),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () => enlaceWhatsapp(),
                      icon: Icon(
                        Icons.chat,
                        size: 40,
                      ),
                    ),
                    SizedBox(width: 60),
                    IconButton(
                      onPressed: () => enlaceTelefono(),
                      icon: Icon(
                        Icons.phone,
                        size: 40,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          ListTile(
            title: const Text('Cerrar sesión'),
            leading: Icon(Icons.exit_to_app),
            onTap: () {
              // Cierra la sesión del usuario y vuelve a la pantalla de inicio de sesión
              userProvider.logout();
              Navigator.pushNamedAndRemoveUntil(
                  context, 'login', (route) => false);
            },
          ),
        ],
      ),
    );
  }
}

Future<void> enlaceWhatsapp() async {
  var _whatsappURL =
      Uri.parse("https://wa.me/+34678177405?text=${Uri.tryParse("reserva")}");
  if (!await launchUrl(_whatsappURL)) {
    throw Exception('Could not launch $_whatsappURL');
  }
}

Future<void> enlaceTelefono() async {
  var _whatsappURL = Uri.parse("tel:+34678177405");
  if (!await launchUrl(_whatsappURL)) {
    throw Exception('Could not launch $_whatsappURL');
  }
}
