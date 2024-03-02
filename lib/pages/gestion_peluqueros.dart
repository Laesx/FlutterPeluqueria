import 'package:flutter/material.dart';

class GestionPeluquerosScreen extends StatefulWidget {
  @override
  _GestionPeluquerosScreenState createState() => _GestionPeluquerosScreenState();
}

class _GestionPeluquerosScreenState extends State<GestionPeluquerosScreen> {
  List<Peluquero> peluqueros = []; //  lista de peluqueros de la base de datos

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Peluqueros'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Buscar por nombre, apellidos o teléfono',
              ),
              onChanged: (query) {
                setState(() {
                peluqueros = filtrarPeluqueros(query);
                });
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: peluqueros.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('${peluqueros[index].nombre} ${peluqueros[index].apellidos}'),
                  subtitle: Text('${peluqueros[index].telefono}'),
                  onTap: () {
                    _mostrarDetallesPeluquero(peluqueros[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  List<Peluquero> filtrarPeluqueros(String query) {
  query = query.toLowerCase();
  return peluqueros.where((peluquero) {
    final nombreCompleto = '${peluquero.nombre} ${peluquero.apellidos}'.toLowerCase();
    final telefono = peluquero.telefono.toLowerCase();
    return nombreCompleto.contains(query) || telefono.contains(query);
  }).toList();
}


  void _mostrarDetallesPeluquero(Peluquero peluquero) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Detalles del Peluquero'),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Nombre: ${peluquero.nombre} ${peluquero.apellidos}'),
            Text('Teléfono: ${peluquero.telefono}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Cierra el diálogo
            },
            child: Text('Cerrar'),
          ),
        ],
      );
    },
  );
}

}

class Peluquero {
  final String nombre;
  final String apellidos;
  final String telefono;

  Peluquero({
    required this.nombre,
    required this.apellidos,
    required this.telefono,
  });
}
