import 'package:flutter/material.dart';
import 'package:flutter_peluqueria/models/models.dart';
import 'package:flutter_peluqueria/services/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final usuariosServices = UsuariosServices();

  void loadPeluqueros() {
    print('Cargando peluqueros');
    Future<List<Usuario>> users = usuariosServices.loadPeluqueros();
    users.then((List<Usuario> userList) {
      for (var user in userList) {
        print(user.nombre);
      }
      print('Peluqueros cargados');
    });
    print('Peluqueros cargados');
  }

  void loadUsuarios() {
    print('Cargando usuarios');
    Future<List<Usuario>> users = usuariosServices.loadUsuarios();
    users.then((List<Usuario> userList) {
      for (var user in userList) {
        print(user.toJson());
      }
      print('Usuarios cargados');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: loadPeluqueros,
              child: const Text('Cargar peluqueros'),
            ),
            ElevatedButton(
              onPressed: loadUsuarios,
              child: const Text('Cargar usuarios'),
            ),
          ],
        ),
      ),
    );
  }
}
