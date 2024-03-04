import 'package:flutter/material.dart';
import 'package:flutter_peluqueria/models/usuario.dart';

class ConnectedUserProvider extends ChangeNotifier {
  //prueba
  Usuario activeUser = Usuario(
    email: "a",
    genero: "",
    id: "test",
    nombre: "Usuario de prueba",
    apellido: "Apellido",
    rol: "Gerente",
    telefono: "678177405",
    verificado: false,
  );

  String? getActiveUserRol() {
    return activeUser.rol;
  }

  // Método llamado en login_screen si el login se realiza correctamente
  void setActiveUser(Usuario user) {
    print(user.email);
    activeUser = user;
  }
}
