import 'package:flutter/material.dart';
import 'package:flutter_peluqueria/models/usuario.dart';
import 'package:flutter_peluqueria/services/usuarios_services.dart';
import 'package:flutter_peluqueria/widgets/usuario.dart';
import 'package:provider/provider.dart';

import 'screens.dart';

class GestionPeluquerosScreen extends StatefulWidget {
  @override
  _GestionPeluquerosScreenState createState() =>
      _GestionPeluquerosScreenState();
}

class _GestionPeluquerosScreenState extends State<GestionPeluquerosScreen> {
  late UsuariosServices usuariosService;
  List<Usuario> usuarios = [];
  List<Usuario> resultadosBusqueda = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    usuariosService = Provider.of<UsuariosServices>(context);
    usuarios = usuariosService.usuarios;
    resultadosBusqueda.addAll(usuarios);
  }

  @override 
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MiAppBar(),
      drawer: MiMenuDesplegable(),
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
                  resultadosBusqueda = usuarios
                      .where((usuario) =>
                          usuario.nombre
                              .toLowerCase()
                              .contains(query.toLowerCase()) ||
                          (usuario.apellido != null &&
                              usuario.apellido!
                                  .toLowerCase()
                                  .contains(query.toLowerCase())) ||
                          usuario.telefono
                              .toLowerCase()
                              .contains(query.toLowerCase()))
                      .toList();
                });
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: resultadosBusqueda.length,
              itemBuilder: (context, index) {
                return UsuarioWidget(usuario: resultadosBusqueda[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}