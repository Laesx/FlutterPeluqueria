import 'package:flutter/material.dart';
import 'package:flutter_peluqueria/models/usuario.dart';

class ConnectedUserProvider extends ChangeNotifier {
  //prueba
  Usuario activeUser = Usuario(
    email: "a",
    genero: "",
    id: "",
    nombre: "Usuario de prueba",
    rol: "Gerente",
    telefono: 555555,
    verificado: false,
  );

  String getActiveUserRol() {
    return activeUser.rol;
  }

  // Método llamado en login_screen si el login se realiza correctamente
  void setActiveUser(Usuario user) {
    activeUser = user;
  }
}
