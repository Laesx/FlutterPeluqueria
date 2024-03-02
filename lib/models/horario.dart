import 'dart:convert';

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

  void printHorario(Horario horario) {
    print('Domingo:');
    print('Empieza en la mañana: ${horario.domingo.empiezaMan}');
    print('Empieza en la tarde: ${horario.domingo.empiezaTarde}');
    print('Acaba en la mañana: ${horario.domingo.acabaMan}');
    print('Acaba en la tarde: ${horario.domingo.acabaTarde}');
    print('');

    print('Festivos:');
    for (var festivo in horario.festivos) {
      print(festivo.toString());
    }
    print('');

    print('Jueves:');
    print('Empieza en la mañana: ${horario.jueves.empiezaMan}');
    print('Empieza en la tarde: ${horario.jueves.empiezaTarde}');
    print('Acaba en la mañana: ${horario.jueves.acabaMan}');
    print('Acaba en la tarde: ${horario.jueves.acabaTarde}');
    print('');

    print('Lunes:');
    print('Empieza en la mañana: ${horario.lunes.empiezaMan}');
    print('Empieza en la tarde: ${horario.lunes.empiezaTarde}');
    print('Acaba en la mañana: ${horario.lunes.acabaMan}');
    print('Acaba en la tarde: ${horario.lunes.acabaTarde}');
    print('');

    print('Martes:');
    print('Empieza en la mañana: ${horario.martes.empiezaMan}');
    print('Empieza en la tarde: ${horario.martes.empiezaTarde}');
    print('Acaba en la mañana: ${horario.martes.acabaMan}');
    print('Acaba en la tarde: ${horario.martes.acabaTarde}');
    print('');

    print('Miércoles:');
    print('Empieza en la mañana: ${horario.miercoles.empiezaMan}');
    print('Empieza en la tarde: ${horario.miercoles.empiezaTarde}');
    print('Acaba en la mañana: ${horario.miercoles.acabaMan}');
    print('Acaba en la tarde: ${horario.miercoles.acabaTarde}');
    print('');

    print('Sábado:');
    print('Empieza en la mañana: ${horario.sabado.empiezaMan}');
    print('Empieza en la tarde: ${horario.sabado.empiezaTarde}');
    print('Acaba en la mañana: ${horario.sabado.acabaMan}');
    print('Acaba en la tarde: ${horario.sabado.acabaTarde}');
    print('');

    print('Viernes:');
    print('Empieza en la mañana: ${horario.viernes.empiezaMan}');
    print('Empieza en la tarde: ${horario.viernes.empiezaTarde}');
    print('Acaba en la mañana: ${horario.viernes.acabaMan}');
    print('Acaba en la tarde: ${horario.viernes.acabaTarde}');
  }

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
  //Esto es para convertirlo a un map los datos que se van a guardar en la base de datos
  Map<String, dynamic> toMap() => {
        "empieza_man": empiezaMan,
        "empieza_tarde": empiezaTarde,
        "acaba_man": acabaMan,
        "acaba_tarde": acabaTarde,
      };
}
