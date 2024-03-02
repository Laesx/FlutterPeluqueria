import 'package:flutter/material.dart';
import 'package:flutter_peluqueria/models/models.dart';
import 'package:flutter_peluqueria/services/services.dart';
import 'package:provider/provider.dart';

//void main() {runApp(const MyApp());}

void main() => runApp(AppState());

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
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({super.key, required this.title});
  final String title;

  final usuariosServices = UsuariosServices();

  void loadPeluqueros() async {
    print('Cargando peluqueros');
    List<Usuario> userList = await usuariosServices.loadPeluqueros();
    for (var user in userList) {
      print(user.nombre);
    }
    print('Peluqueros cargados');
  }

  void loadUsuarios() async {
    print('Cargando usuarios');
    List<Usuario> userList = await usuariosServices.loadUsuarios();
    for (var user in userList) {
      print(user.toJson());
    }
    print('Usuarios cargados');
  }

  void cargarHorarios(HorariosServices service) {
    print('Cargando horarios');
    List<HorarioPeluquero> horariosList = service.horarios;
    for (var horario in horariosList) {
      print(horario.toJson());
    }
    print('Horarios cargados');
  }

  @override
  Widget build(BuildContext context) {
    final usuariosServices = Provider.of<UsuariosServices>(context);
    final productosService = Provider.of<HorariosServices>(context);

    if (usuariosServices.isLoading || productosService.isLoading) {
      return const CircularProgressIndicator();
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(title),
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
            ElevatedButton(
              onPressed: () => cargarHorarios(productosService),
              child: const Text('Cargar horarios'),
            ),
          ],
        ),
      ),
    );
  }
}

class AppState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthService()),
        ChangeNotifierProvider(create: (context) => HorariosServices()),
        ChangeNotifierProvider(create: (context) => ReservasServices()),
        ChangeNotifierProvider(create: (context) => UsuariosServices())
      ],
      child: MyApp(),
    );
  }
}
