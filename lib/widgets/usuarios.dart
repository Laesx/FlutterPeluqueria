import 'package:flutter/material.dart';
import 'package:flutter_peluqueria/models/usuario.dart';

class UsuarioWidget extends StatelessWidget {
  final Usuario usuario;

  UsuarioWidget({required this.usuario});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8.0),
      child: ListTile(
        title: Text(usuario.nombre),
        subtitle:
            Text('Email: ${usuario.email}\nTeléfono: ${usuario.telefono}'),
        trailing: usuario.rol == 'peluquero' ? Icon(Icons.cut) : null,
        onTap: () {
          _mostrarDetallesUsuario(context, usuario);
        },
      ),
    );
  }

  void _mostrarDetallesUsuario(BuildContext context, Usuario usuario) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Detalles del peluquero'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Nombre: ${usuario.nombre}'),
              Text('Email: ${usuario.email}'),
              Text('Teléfono: ${usuario.telefono}'),
              Text('Rol: ${usuario.rol}'),
              Text('Género: ${usuario.genero}'),
              Text('Verificado: ${usuario.verificado ? 'Sí' : 'No'}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Cerrar el diálogo
              },
              child: Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }
}
