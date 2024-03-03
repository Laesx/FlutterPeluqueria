import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_peluqueria/pages/gestion_peluqueros.dart';
import 'package:http/http.dart' as http;

class PeluquerosServices extends ChangeNotifier {
  final String _baseURL =
      'fl-peluqueria-27d72-default-rtdb.europe-west1.firebasedatabase.app';
  final List<Peluquero> peluqueros = [];
  Peluquero? peluqueroSeleccionado;

  bool isLoading = true;
  bool isSaving = false;

  PeluquerosServices() {
    loadPeluqueros();
  }

  Future<List<Peluquero>> loadPeluqueros() async {
    isLoading = true;
    notifyListeners();

    final url = Uri.https(_baseURL, 'peluqueros.json');
    final resp = await http.get(url);

    final Map<String, dynamic> peluquerosMap = json.decode(resp.body);

    peluquerosMap.forEach((key, value) {
      final tempPeluquero = Peluquero(
        nombre: value['nombre'],
        apellidos: value['apellidos'],
        telefono: value['telefono'],
      );
      tempPeluquero.id = key;
      peluqueros.add(tempPeluquero);
    });

    isLoading = false;
    notifyListeners();
    //print('Peluqueros cargados $peluqueros');

    return peluqueros;
  }

  Future<Peluquero> getPeluqueroById(int id) async {
    final url = Uri.https(_baseURL, 'peluqueros/$id.json');
    final resp = await http.get(url);

    final Map<String, dynamic> peluqueroMap = json.decode(resp.body);

    final peluquero = Peluquero(
      nombre: peluqueroMap['nombre'],
      apellidos: peluqueroMap['apellidos'],
      telefono: peluqueroMap['telefono'],
    );

    return peluquero;
  }

}
