import 'dart:convert';

class Usuario {
  String email;
  String genero;
  String? id;
  String nombre;
  String? apellido;
  String rol;
  String telefono;
  bool verificado;

  Usuario({
    required this.email,
    required this.genero,
    this.id,
    required this.nombre,
    this.apellido,
    required this.rol,
    required this.telefono,
    this.horaInicial,
    this.horaFin,
    required this.verificado,
  });

  factory Usuario.fromRawJson(String str) => Usuario.fromJson(json.decode(str));

  get horaInicialLunes => null;

  get horaFinLunes => null;

  String toRawJson() => json.encode(toJson());

  factory Usuario.fromJson(Map<String, dynamic> json) => Usuario(
        email: json["email"],
        genero: json["genero"],
        nombre: json["nombre"],
        apellido: json["apellido"] != null ? json["apellido"] : "",
        rol: json["rol"],
        telefono: json["telefono"].toString(),
        verificado: json["verificado"],
      );

  Map<String, dynamic> toJson() => {
        "email": email,
        "genero": genero,
        "nombre": nombre,
        "apellido": apellido,
        "rol": rol,
        "telefono": telefono,
        "horaentrada": horaInicial,
        "horasalida": horaFin,
        "verificado": verificado,
      };

  Usuario copy() => Usuario(
        id: this.id,
        email: this.email,
        genero: this.genero,
        nombre: this.nombre,
        apellido: this.apellido,
        rol: this.rol,
        telefono: this.telefono,
        verificado: this.verificado,
      );
}
