import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_peluqueria/models/usuario.dart';
import 'package:local_auth/local_auth.dart';
import 'package:provider/provider.dart';
import 'package:flutter_peluqueria/widgets/simple_button.dart';
import 'package:flutter_peluqueria/widgets/password_text_field.dart';
import 'package:flutter_peluqueria/providers/login_form_provider.dart';
import 'package:flutter_peluqueria/providers/connected_user_provider.dart';
import 'package:flutter_peluqueria/services/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: ChangeNotifierProvider(
              create: (_) => LoginFormProvider(),
              child: _LoginForm(),
            ),
          ),
        ),
      ),
    );
  }
}

class _LoginForm extends StatelessWidget {
  void login(LoginFormProvider loginForm, context) async {
    if (loginForm.isLoading) return;
    FocusScope.of(context).unfocus();
    if (!loginForm.isValidForm()) return;

    loginForm.isLoading = true;

    await tryLogin(loginForm, context);
  }

  Future<void> tryLogin(LoginFormProvider loginForm, context) async {
    final authService = Provider.of<AuthService>(context, listen: false);
    final usuariosService =
        Provider.of<UsuariosServices>(context, listen: false);
    final conectadoProvider =
        Provider.of<ConnectedUserProvider>(context, listen: false);

    final String? errorMessage =
        await authService.login(loginForm.email, loginForm.password);

    if (errorMessage == null) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('user', loginForm.email);
      prefs.setString('password', loginForm.password);

      Usuario? activeUser =
          await usuariosService.getUsuarioByEmail(loginForm.email);

      // Verificar si activeUser es null antes de acceder a sus propiedades
      if (activeUser != null) {
        conectadoProvider.activeUser = activeUser;
        Navigator.pushReplacementNamed(context, 'home');
      } else {
        // Manejar el caso donde activeUser es null
        print("Error: No se pudo obtener el usuario activo.");
      }
    } else {
      print(errorMessage);
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Credenciales Incorrectas, $errorMessage'),
          );
        },
      );
      loginForm.isLoading = false;
    }
  }

  void biometricLogin(LoginFormProvider loginForm, context) async {
    LocalAuthentication auth = LocalAuthentication();
    bool deviceSupported = await auth.isDeviceSupported();
    print("Device supported: $deviceSupported");
    List<BiometricType> availableBiometrics =
        await auth.getAvailableBiometrics();
    print(availableBiometrics);
    try {
      // Mostrar diálogo de acceso con huella
      bool authenticated = await auth.authenticate(
          localizedReason:
              '¡Holis! Puedes usar tu huella para acceder a la aplicación',
          options: const AuthenticationOptions(
            stickyAuth: true, // No falla si la aplicación pasa a segundo plano
            biometricOnly: true, // Impide uso de PIN
          ));
      print(authenticated);
      if (authenticated) {
        // Si la huella es correcta, comprueba que existan credenciales almacenadas
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        if (prefs.containsKey('user') && prefs.containsKey('password')) {
          // Si existen credenciales almacenadas, inicia sesión con estas credenciales
          loginForm.email = prefs.getString('user')!;
          loginForm.password = prefs.getString('password')!;
          await tryLogin(loginForm, context);
        } else {
          print("Imposible :(");
          showDialog(
            context: context,
            builder: (context) {
              return const AlertDialog(
                title:
                    Text('No hay credenciales almacenadas en el dispositivo'),
              );
            },
          );
        }
      }
    } on PlatformException catch (e) {
      print(e);
    }
  }

  _LoginForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final LoginFormProvider loginForm = Provider.of<LoginFormProvider>(context);
    return Form(
      key: loginForm.formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        children: [
          const SizedBox(height: 40),
          // Logo
          const Icon(
            Icons.chair,
            size: 100,
          ),
          const SizedBox(height: 40),
          const Text(
            "Bienvenido a BarberShop Ali",
            style: TextStyle(fontSize: 16),
          ),

          const SizedBox(height: 40),

          // username
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 25.0),
            child: TextFormField(
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              obscureText: false,
              decoration: const InputDecoration(
                hintText: "Email",
                suffixIcon: Icon(Icons.person),
              ),
              onChanged: (value) => loginForm.email = value,
              validator: (value) {
                String pattern =
                    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                RegExp regExp = new RegExp(pattern);

                return regExp.hasMatch(value ?? '')
                    ? null
                    : 'Introduce un correo válido';
              },
            ),
          ),

          const SizedBox(height: 10),

          // password
          PasswordTextField(
            onChanged: (value) => loginForm.password = value,
            validator: (value) {
              return (value != null && value.length >= 6)
                  ? null
                  : "La contraseña debe tener como minimo 6 caracteres";
            },
          ),

          const SizedBox(height: 30),
          // Sign in
          SimpleButton(
            onTap: () => login(loginForm, context),
            text: loginForm.isLoading ? "Espere" : "Login",
          ),
          const SizedBox(height: 10),

          SimpleButton(
            onTap: () => biometricLogin(loginForm, context),
            text: "Utilizar mi huella",
          ),

          const SizedBox(height: 30),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Expanded: Ocupa Toda la fila
                Expanded(
                  child: Divider(
                    thickness: 0.5,
                    color: Colors.grey[400],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    "¿No eres miembro?",
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                ),
                GestureDetector(
                  onTap: () =>
                      Navigator.pushReplacementNamed(context, 'register'),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      "Regístrate",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Divider(
                    thickness: 0.5,
                    color: Colors.grey[400],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
