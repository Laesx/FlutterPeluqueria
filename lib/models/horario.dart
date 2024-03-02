import 'dart:convert';
//import 'package:flutter_peluqueria/models/dia.dart';
import 'dia.dart';

class Horario {
  // a lo mejor es mejor ponerlo como un map?
  Dia domingo;
  //Festivos por defecto es una lista vacia
  List<DateTime> festivos;
  Dia jueves;
  Dia lunes;
  Dia martes;
  Dia miercoles;
  Dia sabado;
  Dia viernes;

  Horario({
    required this.festivos,
    required this.lunes,
    required this.martes,
    required this.miercoles,
    required this.jueves,
    required this.viernes,
    required this.sabado,
    required this.domingo,
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
        domingo: json["domingo"] != null
            ? Dia.fromMap(json["domingo"])
            : Dia(
                empiezaMan: '', empiezaTarde: '', acabaMan: '', acabaTarde: ''),
        festivos: json["festivos"] != null
            ? List<DateTime>.from(
                json["festivos"].map((x) => DateTime.parse(x)))
            : [],
        jueves: json["jueves"] != null
            ? Dia.fromMap(json["jueves"])
            : Dia(
                empiezaMan: '', empiezaTarde: '', acabaMan: '', acabaTarde: ''),
        lunes: json["lunes"] != null
            ? Dia.fromMap(json["lunes"])
            : Dia(
                empiezaMan: '', empiezaTarde: '', acabaMan: '', acabaTarde: ''),
        martes: json["martes"] != null
            ? Dia.fromMap(json["martes"])
            : Dia(
                empiezaMan: '', empiezaTarde: '', acabaMan: '', acabaTarde: ''),
        miercoles: json["miercoles"] != null
            ? Dia.fromMap(json["miercoles"])
            : Dia(
                empiezaMan: '', empiezaTarde: '', acabaMan: '', acabaTarde: ''),
        sabado: json["sabado"] != null
            ? Dia.fromMap(json["sabado"])
            : Dia(
                empiezaMan: '', empiezaTarde: '', acabaMan: '', acabaTarde: ''),
        viernes: json["viernes"] != null
            ? Dia.fromMap(json["viernes"])
            : Dia(
                empiezaMan: '', empiezaTarde: '', acabaMan: '', acabaTarde: ''),
      );

  Map<String, dynamic> toMap() => {
        "domingo": domingo != null ? domingo.toMap() : null,
        "festivos": festivos != null
            ? List<dynamic>.from(festivos.map((x) =>
                "${x.year.toString().padLeft(4, '0')}-${x.month.toString().padLeft(2, '0')}-${x.day.toString().padLeft(2, '0')}"))
            : null,
        "jueves": jueves != null ? jueves.toMap() : null,
        "lunes": lunes != null ? lunes.toMap() : null,
        "martes": martes != null ? martes.toMap() : null,
        "miercoles": miercoles != null ? miercoles.toMap() : null,
        "sabado": sabado != null ? sabado.toMap() : null,
        "viernes": viernes != null ? viernes.toMap() : null,
      };
}
