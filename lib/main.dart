import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'screens/screens.dart';
import 'services/services.dart';
import 'providers/providers.dart';

void main() {
  initializeDateFormatting().then((_) => runApp(AppState()));
}

//void main() {initializeDateFormatting().then((_) => runApp(MyApp()));}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Peluqueria App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CalendarScreen(),
      debugShowCheckedModeBanner: false,
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
        ChangeNotifierProvider(create: (context) => UsuariosServices()),
        ChangeNotifierProvider(create: (context) => ConnectedUserProvider())
      ],
      child: MyApp(),
    );
  }
}
