import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_peluqueria/models/models.dart';
import 'package:http/http.dart' as http;

class HorariosServices extends ChangeNotifier {
  final String _baseURL =
      'horarios-d3ffb-default-rtdb.europe-west1.firebasedatabase.app';
  final List<HorarioPeluquero> horarios = [];
  final List<Horario> horarioPelu = [];

  bool isLoading = true;
  bool isSaving = false;

  HorariosServices() {
    loadHorarios();
    loadHorarioPelu(); // Esto lo mismo da error?
  }

  // TODO Falta probar
  // Este metodo devuelve el horario de la peluqueria en si
  Future<List<Horario>> loadHorarioPelu() async {
    isLoading = true;
    notifyListeners();

    final url = Uri.https(_baseURL, 'horario_peluqueria.json');
    final resp = await http.get(url);

    final Map<String, dynamic> horariosMap = json.decode(resp.body);
    //final String json_contenido = json.decode(resp.body);
    final tempHorarioPelu = Horario.fromMap(horariosMap);
    // Solo debería haber un horario pero se queja si no lo hago una lista...
    horarioPelu.add(tempHorarioPelu);

    isLoading = false;
    notifyListeners();

    return horarioPelu;
  }

  Future<void> saveHorarioPelu(Horario horario) async {
    notifyListeners();

    final url = Uri.https(_baseURL, 'horario_peluqueria.json');

    final response = await http.put(
      url,
      body: horario.toJson(), // Convert the Horario to a JSON string
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to save horario');
    }

    notifyListeners();
  }

  // TODO Falta Probar
  // Este metodo devuelve los horarios de los peluqueros
  Future<List<HorarioPeluquero>> loadHorarios() async {
    isLoading = true;
    notifyListeners();

    final url = Uri.https(_baseURL, 'horarios.json');
    //print(url);
    final resp = await http.get(url);

    final Map<String, dynamic> horariosMap = json.decode(resp.body);

    horariosMap.forEach((key, value) {
      final tempHorario = HorarioPeluquero.fromMap(value);
      tempHorario.id = key;
      horarios.add(tempHorario);
    });

    isLoading = false;
    notifyListeners();

    return horarios;
    //print(this.producto[1].nombre);
  }

  // TODO probar
  Future saveOrCreateHorarioPeluquero(HorarioPeluquero horarioPeluquero) async {
    isSaving = true;
    notifyListeners();

    //await this.updateProducto(producto);
    if (horarioPeluquero.id == null) {
      // Crear la entrada
      await createHorario(horarioPeluquero);
    } else {
      // Update de la entrada
      await updateHorario(horarioPeluquero);
    }

    isSaving = false;
    notifyListeners();
  }

  // TODO Falta probar
  Future<String> updateHorario(HorarioPeluquero horarioPeluquero) async {
    final url = Uri.https(_baseURL, 'horarios/${horarioPeluquero.id}.json');
    final resp = await http.put(url, body: horarioPeluquero.toJson());
    final decodedData = resp.body;

    //TODO Print para prueba, esto hay que quitarlo
    print(decodedData);
    final index =
        horarios.indexWhere((element) => element.id == horarioPeluquero.id);
    horarios[index] = horarioPeluquero;

    return horarioPeluquero.id!;
  }

  // TODO Falta probar
  Future<String> createHorario(HorarioPeluquero horarioPeluquero) async {
    final url = Uri.https(_baseURL, 'horarios.json');
    final resp = await http.post(url, body: horarioPeluquero.toJson());
    final decodedData = json.decode(resp.body);

    // Esto hay que testearlo, aunque no se si lo vamos a usar siquiera
    horarioPeluquero.id = decodedData['name'];

    horarios.add(horarioPeluquero);

    return horarioPeluquero.id!;
  }
}
