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

  static showInfo(Horario horario) {
    print('Domingo: ');
    print('Empieza man: ${horario.domingo.empiezaMan}');
    print('Empieza tarde: ${horario.domingo.empiezaTarde}');
    print('Acaba man: ${horario.domingo.acabaMan}');
    print('Acaba tarde: ${horario.domingo.acabaTarde}');
    print('Festivos: ${horario.festivos}');
    print('Jueves: ');
    print('Empieza man: ${horario.jueves.empiezaMan}');
    print('Empieza tarde: ${horario.jueves.empiezaTarde}');
    print('Acaba man: ${horario.jueves.acabaMan}');
    print('Acaba tarde: ${horario.jueves.acabaTarde}');
    print('Lunes: ');
    print('Empieza man: ${horario.lunes.empiezaMan}');
    print('Empieza tarde: ${horario.lunes.empiezaTarde}');
    print('Acaba man: ${horario.lunes.acabaMan}');
    print('Acaba tarde: ${horario.lunes.acabaTarde}');
    print('Martes: ');
    print('Empieza man: ${horario.martes.empiezaMan}');
    print('Empieza tarde: ${horario.martes.empiezaTarde}');
    print('Acaba man: ${horario.martes.acabaMan}');
    print('Acaba tarde: ${horario.martes.acabaTarde}');
    print('Miércoles: ');
    print('Empieza man: ${horario.miercoles.empiezaMan}');
    print('Empieza tarde: ${horario.miercoles.empiezaTarde}');
    print('Acaba man: ${horario.miercoles.acabaMan}');
    print('Acaba tarde: ${horario.miercoles.acabaTarde}');
    print('Sábado: ');
    print('Empieza man: ${horario.sabado.empiezaMan}');
    print('Empieza tarde: ${horario.sabado.empiezaTarde}');
    print('Acaba man: ${horario.sabado.acabaMan}');
    print('Acaba tarde: ${horario.sabado.acabaTarde}');
    print('Viernes: ');
    print('Empieza man: ${horario.viernes.empiezaMan}');
    print('Empieza tarde: ${horario.viernes.empiezaTarde}');
    print('Acaba man: ${horario.viernes.acabaMan}');
    print('Acaba tarde: ${horario.viernes.acabaTarde}');
  }

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

  List<DateTime> getDiasFestivos() {
    return festivos;
  }

  void setDiasFestivos(List<DateTime> dias) {
    festivos = dias;
  }

  List<Dia> getDiasSemana() {
    return [lunes, martes, miercoles, jueves, viernes, sabado, domingo];
  }

  void setDiasSemana(List<Dia> dias) {
    lunes = dias[0];
    martes = dias[1];
    miercoles = dias[2];
    jueves = dias[3];
    viernes = dias[4];
    sabado = dias[5];
    domingo = dias[6];
  }

  void removeFestivo(DateTime festivo) {
    festivos.remove(festivo);
  }
}
