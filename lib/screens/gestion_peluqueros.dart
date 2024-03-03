import 'package:flutter/material.dart';
import 'package:flutter_peluqueria/models/usuario.dart';
import 'package:flutter_peluqueria/services/usuarios_services.dart';
import 'package:flutter_peluqueria/widgets/usuarios.dart';

class GestionPeluquerosScreen extends StatefulWidget {
  @override
  _GestionPeluquerosScreenState createState() =>
      _GestionPeluquerosScreenState();
}

class _GestionPeluquerosScreenState extends State<GestionPeluquerosScreen> {
  List<Usuario> usuarios = [];
  
  get peluqueros => null; // Cambié el tipo de datos a Usuario

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
              decoration: const InputDecoration(
                labelText: 'Buscar por nombre, apellidos o teléfono',
              ),
              onChanged: (query) {
                // Implementa la lógica de filtrado según tus necesidades
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: usuarios.length,
              itemBuilder: (context, index) {
                return UsuarioWidget(usuario: usuarios[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  List<Usuario> filtrarPeluqueros(String query) {
    query = query.toLowerCase();
    return peluqueros.where((peluquero) {
      final nombreCompleto =
          '${peluquero.nombre} ${peluquero.apellidos}'.toLowerCase();
      final telefono = peluquero.telefono.toLowerCase();
      return nombreCompleto.contains(query) || telefono.contains(query);
    }).toList();
  }

  Future<void> _mostrarDetallesPeluquero(Usuario peluquero) async {
    List<Usuario> peluqueros = await UsuariosServices().loadPeluqueros();

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
