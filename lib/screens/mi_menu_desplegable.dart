import 'package:flutter/material.dart';
import 'package:flutter_peluqueria/app_routes/app_routes.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../providers/providers.dart';

class MiMenuDesplegable extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userProvider =
        Provider.of<ConnectedUserProvider>(context, listen: false);
    return Drawer(
      child: ListView.separated(
        itemBuilder: (context, index) {
          if (index < AppRoutes.menuOptions.length) {
            return ListTile(
              leading: Icon(AppRoutes.menuOptions[index].icon),
              title: Text(AppRoutes.menuOptions[index].name),
              onTap: () {
                Navigator.pushNamed(
                    context, AppRoutes.menuOptions[index].route);
              },
            );
          } else if (index == AppRoutes.menuOptions.length) {
            return ListTile(
              leading: Icon(Icons.phone),
              title: Text('Llamar'),
              onTap: enlaceTelefono,
            );
          } else {
            return ListTile(
              leading: Icon(Icons.message),
              title: Text('WhatsApp'),
              onTap: enlaceWhatsapp,
            );
          }
        },
        separatorBuilder: (context, index) => Divider(),
        itemCount: AppRoutes.menuOptions.length + 2,
      ),
    );
  }

  Future<void> enlaceWhatsapp() async {
    var _whatsappURL =
        Uri.parse("https://wa.me/+34678177405?text=${Uri.tryParse("reserva")}");
    if (!await launchUrl(_whatsappURL)) {
      print("could not launch");
      throw Exception('Could not launch $_whatsappURL');
    }
    print("OK");
  }

  Future<void> enlaceTelefono() async {
    var _whatsappURL = Uri.parse("tel:+34678177405");
    if (!await launchUrl(_whatsappURL)) {
      print("could not launch");
      throw Exception('Could not launch $_whatsappURL');
    }
    print("OK");
  }
}
