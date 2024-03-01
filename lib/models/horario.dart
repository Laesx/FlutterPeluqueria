import 'dart:convert';
//import 'package:flutter_peluqueria/models/dia.dart';
import 'dia.dart';

class Horario {
  // a lo mejor es mejor ponerlo como un map?
  Dia domingo;
  List<DateTime> festivos;
  Dia jueves;
  Dia lunes;
  Dia martes;
  Dia miercoles;
  Dia sabado;
  Dia viernes;

  Horario({
    required this.domingo,
    required this.festivos,
    required this.jueves,
    required this.lunes,
    required this.martes,
    required this.miercoles,
    required this.sabado,
    required this.viernes,
  });

  // Default empty constructor for testing
  Horario.empty()
      : domingo = Dia(
          empiezaMan: '00:00',
          empiezaTarde: '00:00',
          acabaMan: '00:00',
          acabaTarde: '00:00',
        ),
        festivos = [],
        jueves = Dia(
          empiezaMan: '00:00',
          empiezaTarde: '00:00',
          acabaMan: '00:00',
          acabaTarde: '00:00',
        ),
        lunes = Dia(
          empiezaMan: '00:00',
          empiezaTarde: '00:00',
          acabaMan: '00:00',
          acabaTarde: '00:00',
        ),
        martes = Dia(
          empiezaMan: '00:00',
          empiezaTarde: '00:00',
          acabaMan: '00:00',
          acabaTarde: '00:00',
        ),
        miercoles = Dia(
          empiezaMan: '00:00',
          empiezaTarde: '00:00',
          acabaMan: '00:00',
          acabaTarde: '00:00',
        ),
        sabado = Dia(
          empiezaMan: '00:00',
          empiezaTarde: '00:00',
          acabaMan: '00:00',
          acabaTarde: '00:00',
        ),
        viernes = Dia(
          empiezaMan: '00:00',
          empiezaTarde: '00:00',
          acabaMan: '00:00',
          acabaTarde: '00:00',
        );

  factory Horario.fromJson(String str) => Horario.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Horario.fromMap(Map<String, dynamic> json) => Horario(
        domingo: Dia.fromMap(json["domingo"]),
        festivos:
            List<DateTime>.from(json["festivos"].map((x) => DateTime.parse(x))),
        jueves: Dia.fromMap(json["jueves"]),
        lunes: Dia.fromMap(json["lunes"]),
        martes: Dia.fromMap(json["martes"]),
        miercoles: Dia.fromMap(json["miercoles"]),
        sabado: Dia.fromMap(json["sabado"]),
        viernes: Dia.fromMap(json["viernes"]),
      );

  Map<String, dynamic> toMap() => {
        "domingo": domingo.toMap(),
        "festivos": List<dynamic>.from(festivos.map((x) =>
            "${x.year.toString().padLeft(4, '0')}-${x.month.toString().padLeft(2, '0')}-${x.day.toString().padLeft(2, '0')}")),
        "jueves": jueves.toMap(),
        "lunes": lunes.toMap(),
        "martes": martes.toMap(),
        "miercoles": miercoles.toMap(),
        "sabado": sabado.toMap(),
        "viernes": viernes.toMap(),
      };
}
