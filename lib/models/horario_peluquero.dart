import 'dart:convert';
import 'horario.dart';

class HorarioPeluquero {
  // Aqui depende del otro modelo Horario
  Horario horario;
  String peluquero;
  String? id;

  HorarioPeluquero({
    required this.horario,
    required this.peluquero,
    this.id,
  });

  factory HorarioPeluquero.fromJson(String str) =>
      HorarioPeluquero.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory HorarioPeluquero.fromMap(Map<String, dynamic> json) =>
      HorarioPeluquero(
        horario: Horario.fromMap(json["horario"]),
        peluquero: json["peluquero"],
      );

  Map<String, dynamic> toMap() => {
        "horario": horario.toMap(),
        "peluquero": peluquero,
      };
}
