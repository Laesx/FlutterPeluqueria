import 'dart:convert';

// Tengo que preguntar si el horario es para un peluquero o para la peluquería
// Tambien si implementar que los peluqueros tengan turno partido
class Horario {
  List<DateTime> horario;
  String peluquero;

  Horario({
    required this.horario,
    required this.peluquero,
  });

  factory Horario.fromJson(String str) => Horario.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Horario.fromMap(Map<String, dynamic> json) => Horario(
        horario:
            List<DateTime>.from(json["horario"].map((x) => DateTime.parse(x))),
        peluquero: json["peluquero"],
      );

  Map<String, dynamic> toMap() => {
        "horario": List<dynamic>.from(horario.map((x) => x.toIso8601String())),
        "peluquero": peluquero,
      };
}
