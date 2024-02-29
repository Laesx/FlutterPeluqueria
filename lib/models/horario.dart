import 'dart:convert';

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

class Dia {
  String empiezaMan;
  String empiezaTarde;
  String acabaMan;
  String acabaTarde;

  Dia({
    required this.empiezaMan,
    required this.empiezaTarde,
    required this.acabaMan,
    required this.acabaTarde,
  });

  factory Dia.fromJson(String str) => Dia.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Dia.fromMap(Map<String, dynamic> json) => Dia(
        empiezaMan: json["empieza_man"],
        empiezaTarde: json["empieza_tarde"],
        acabaMan: json["acaba_man"],
        acabaTarde: json["acaba_tarde"],
      );

  Map<String, dynamic> toMap() => {
        "empieza_man": empiezaMan,
        "empieza_tarde": empiezaTarde,
        "acaba_man": acabaMan,
        "acaba_tarde": acabaTarde,
      };
}
