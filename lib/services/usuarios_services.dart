import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_peluqueria/models/models.dart';
import 'package:http/http.dart' as http;

class UsuariosServices extends ChangeNotifier {
  final String _baseURL =
      'fl-peluqueria-27d72-default-rtdb.europe-west1.firebasedatabase.app';
  final List<Usuario> usuarios = [];
  Usuario? usuarioSeleccionado;

  bool isLoading = true;
  bool isSaving = false;

  UsuariosServices() {
    loadUsuarios();
  }

  // TODO Falta Probar
  Future<List<Usuario>> loadUsuarios() async {
    notifyListeners();

    final url = Uri.https(_baseURL, 'usuarios.json');
    final resp = await http.get(url);

    final Map<String, dynamic> usuariosMap = json.decode(resp.body);

    this.usuarios.clear();

    usuariosMap.forEach((key, value) {
      final tempUser = Usuario.fromMap(value);
      tempUser.id = key;
      usuarios.add(tempUser);
    });

    return usuarios;
    //print(this.producto[1].nombre);
  }

  // Devuelve una lista de usuarios que son peluqueros
  Future<List<Usuario>> loadPeluqueros() async {
    isLoading = true;
    notifyListeners();

    final url = Uri.https(_baseURL, 'usuarios.json');
    final resp = await http.get(url);

    final Map<String, dynamic> usuariosMap = json.decode(resp.body);

    usuariosMap.forEach((key, value) {
      final tempUser = Usuario.fromMap(value);
      if (tempUser.rol == 'peluquero') {
        tempUser.id = key;
        usuarios.add(tempUser);
      }
    });

    isLoading = false;
    notifyListeners();
    //print(usuarios.toString());
    return usuarios;
  }

  Future<Usuario?> getUsuarioByEmail(String email) async {
    List<Usuario> users = await loadUsuarios();
    var filteredUsers = users.where((u) => u.email == email);
    if (filteredUsers.isNotEmpty) {
      return filteredUsers.first;
    } else {
      return null;
    }
  }

  Future<String> updateUsuario(Usuario usuario) async {
    final url = Uri.https(_baseURL, 'usuarios/${usuario.id}.json');
    final resp = await http.put(url, body: usuario.toJson());
    final decodedData = resp.body;

    return usuario.id!;
  }

  Future<String> updateUsuarioRol(String id, String nuevoRol) async {
    final url = Uri.https(_baseURL, 'usuarios/$id.json');

    final resp = await http.patch(url, body: jsonEncode({'rol': nuevoRol}));
    final decodedData = resp.body;

    return id;
  }
}
