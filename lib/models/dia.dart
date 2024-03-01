import 'dart:convert';

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

  static Dia empty() {
    return Dia(
      empiezaMan: '',
      empiezaTarde: '',
      acabaMan: '',
      acabaTarde: '',
    );
  }
}
