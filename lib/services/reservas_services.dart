import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_peluqueria/models/reserva.dart';
import 'package:http/http.dart' as http;

class ReservasServices extends ChangeNotifier {
  final String _baseURL =
      'fl-peluqueria-27d72-default-rtdb.europe-west1.firebasedatabase.app';
  final String _firebaseToken = 'B9KTDm0g3J9qAs1ZlQRt5veeHiIObJo5ZTVwzvzp';
  final List<Reserva> reservas = [];
  Reserva? reservaSeleccionada;

  bool isLoading = true;
  bool isSaving = false;

  ReservasServices() {
    loadReservas();
  }

  Future<List<Reserva>> loadReservas() async {
    isLoading = true;
    notifyListeners();

    final url = Uri.https(_baseURL, 'reservas.json', {'auth': _firebaseToken});
    final resp = await http.get(url);

    final Map<String, dynamic> reservasMap = json.decode(resp.body);

    reservasMap.forEach((key, value) {
      final tempReserva = Reserva.fromMap(value);
      tempReserva.id = key;
      reservas.add(tempReserva);
    });

    isLoading = false;
    notifyListeners();
    //print('Reservas cargadas $reservas');

    return reservas;
  }

  // Aqui se debería manejar en caso de que no se encuentre la reserva
  Future<Reserva> getReservaById(int id) async {
    final url =
        Uri.https(_baseURL, 'reservas/$id.json', {'auth': _firebaseToken});
    final resp = await http.get(url);

    final Map<String, dynamic> reservaMap = json.decode(resp.body);

    final reserva = Reserva.fromMap(reservaMap);

    return reserva;
  }

  // TODO Probar si funciona
  Future<List<Reserva>> getReservasByDate(DateTime date) async {
    final url = Uri.https(_baseURL, 'reservas.json', {'auth': _firebaseToken});
    final resp = await http.get(url);

    final Map<String, dynamic> reservasMap = json.decode(resp.body);

    reservasMap.forEach((key, value) {
      final tempReserva = Reserva.fromMap(value);
      tempReserva.id = key;
      reservas.add(tempReserva);
    });

    return reservas;
  }

  // Se supone que estos 3 no hay que implementarlo según dice el profesor?
  /*
  Future<void> createReserva(Reserva reserva) async {
    // Logic to create a new reserva in the database
  }

  Future<void> updateReserva(Reserva reserva) async {
    // Logic to update an existing reserva in the database
  }

  Future<void> deleteReserva(int id) async {
    // Logic to delete a reserva from the database by its ID
  }
  */
}
