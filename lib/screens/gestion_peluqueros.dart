import 'package:flutter/material.dart';
import 'package:flutter_peluqueria/models/usuario.dart';
import 'package:flutter_peluqueria/services/usuarios_services.dart';
import 'package:flutter_peluqueria/widgets/usuario.dart';
import 'package:provider/provider.dart';

class GestionPeluquerosScreen extends StatefulWidget {
  @override
  _GestionPeluquerosScreenState createState() =>
      _GestionPeluquerosScreenState();
}

class _GestionPeluquerosScreenState extends State<GestionPeluquerosScreen> {
  late UsuariosServices usuariosService;
  List<Usuario> usuarios = [];

  @override
  void initState() {
    super.initState();
    //_loadUsuarios(); // Llamamos al método en initState
  }

  // Cada vez que se actualiza el widget, se llama a didChangeDependencies
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    usuariosService = Provider.of<UsuariosServices>(context);
  }

  // Esto me parece que no vamos a tener que usarlo, pongo esto para avisar
  Future<void> _loadUsuarios() async {
    try {
      List<Usuario> loadedUsuarios = await UsuariosServices().loadUsuarios();
      setState(() {
        usuarios = loadedUsuarios;
      });
    } catch (error) {
      // Manejar cualquier error que pueda ocurrir durante la carga de usuarios
      print('Error al cargar usuarios: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    usuarios.addAll(usuariosService.usuarios); // Accede a la lista de usuarios
    print("lista, $usuarios");

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
          )),
        ],
      ),
    );
  }
}
