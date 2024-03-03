import 'package:flutter/material.dart';
import 'package:flutter_peluqueria/app_routes/app_routes.dart';
import 'package:flutter_peluqueria/widgets/calendario_peluquero.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:flutter_peluqueria/theme/app_theme.dart';
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
      initialRoute:
          AppRoutes.initialRoute, // Utilizar home para realizar pruebas
      routes: AppRoutes.getAppRoutes(),
      theme: AppTheme.darkTheme,
      darkTheme: AppTheme.darkTheme, // TODO: Implementar tema oscuro
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
