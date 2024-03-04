import 'dart:convert';

class Usuario {
  String? id;
  String email;
  String genero;
  String nombre;
  String apellido;
  String rol;
  String telefono;
  bool verificado;

  Usuario({
    this.id,
    required this.email,
    required this.genero,
    required this.nombre,
    required this.apellido,
    required this.rol,
    required this.telefono,
    required this.verificado,
  });

  factory Usuario.fromJson(String str) => Usuario.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Usuario.fromMap(Map<String, dynamic> json) => Usuario(
        email: json["email"],
        genero: json["genero"],
        nombre: json["nombre"],
        apellido: json["apellido"],
        rol: json["rol"],
        telefono: json["telefono"],
        verificado: json["verificado"],
      );

  Map<String, dynamic> toMap() => {
        "email": email,
        "genero": genero,
        "nombre": nombre,
        "apellido": apellido,
        "rol": rol,
        "telefono": telefono,
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
