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
    isLoading = true;
    notifyListeners();

    final url = Uri.https(_baseURL, 'usuarios.json');
    final resp = await http.get(url);

    final Map<String, dynamic> usuariosMap = json.decode(resp.body);

    usuariosMap.forEach((key, value) {
      final tempUser = Usuario.fromMap(value);
      tempUser.id = key;
      usuarios.add(tempUser);
    });

    isLoading = false;
    notifyListeners();

    return usuarios;
    //print(this.producto[1].nombre);
  }

  // TODO Falta implementar
  Future saveOrCreateUsuario(Usuario usuario) async {
    isSaving = true;
    notifyListeners();

    //await this.updateProducto(producto);
    if (usuario.id == null) {
      // Crear la entrada
      await createProducto(usuario);
    } else {
      // Update de la entrada
      await updateProducto(usuario);
    }

    isSaving = false;
    notifyListeners();
  }

  // TODO Falta implementar
  Future<String> updateProducto(Usuario producto) async {
    final url = Uri.https(_baseURL, 'productos/${producto.id}.json');
    final resp = await http.put(url, body: producto.toJson());
    final decodedData = resp.body;

    print(decodedData);
    final index =
        this.usuarios.indexWhere((element) => element.id == producto.id);
    this.usuarios[index] = producto;

    return producto.id!;
  }

  // TODO Falta implementar
  Future<String> createProducto(Usuario producto) async {
    final url = Uri.https(_baseURL, 'productos.json');
    final resp = await http.post(url, body: producto.toJson());
    final decodedData = json.decode(resp.body);

    producto.id = decodedData['name'];

    this.usuarios.add(producto);

    return producto.id!;
  }
}
