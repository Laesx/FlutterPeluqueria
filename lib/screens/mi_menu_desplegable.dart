import 'package:flutter/material.dart';
import 'package:flutter_peluqueria/app_routes/app_routes.dart';
import 'package:url_launcher/url_launcher.dart';

class MiMenuDesplegable extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView.separated(
          itemBuilder: (context, index) {
            return ListTile(
              leading: Icon(AppRoutes.menuOptions[index].icon),
              title: Text(AppRoutes.menuOptions[index].name),
              onTap: () {
                // Otra forma de hacerlo para usar push en vez de pushNamed
                // final route = MaterialPageRoute(builder: (context) {return const HomeScreen();});
                Navigator.pushNamed(
                    context, AppRoutes.menuOptions[index].route);
              },
            );
          },
          /*
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
          */
          separatorBuilder: (context, index) => Divider(),
          itemCount: AppRoutes.menuOptions.length),
    );
  }
}
