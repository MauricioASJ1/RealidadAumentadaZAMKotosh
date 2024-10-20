import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../providers/auth_state.dart';
import '../utils/messages.dart';
import '../screens/Passport.dart';
import '../screens/SignUp.dart';
import '../widgets/background_without_icon.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  // Define un controlador para el nombre de usuario
  late TextEditingController _usernameController;

  @override
  void initState() {
    super.initState();
    // Inicializa el controlador para el nombre de usuario
    _usernameController = TextEditingController();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  // Método para formatear el nombre de usuario (todo en minúsculas y sin espacios)
  String _formatUsername(String username) {
    return username.toLowerCase().replaceAll(' ', '');
  }

  // Método para iniciar sesión en Firebase usando el nombre de usuario
  Future<void> _signIn(BuildContext context) async {
    // Obtén el nombre de usuario del TextField
    String username = _formatUsername(_usernameController.text);

    // Genera el correo y la contraseña usando el nombre de usuario
    String email = '$username@zamkotosh.com';
    String password = username;

    // Intenta iniciar sesión en Firebase
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      if (userCredential.user != null) {
        print('Inicio de sesión exitoso');
        // Redirige al usuario a la pantalla principal
        Navigator.pushReplacementNamed(context, '/Passport');
      }
    } catch (e) {
      print('Error al iniciar sesión: $e');
      // Muestra un mensaje de error en caso de fallo
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                'Error al iniciar sesión. Verifica tu nombre de usuario.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: BackgroundWithoutIcon(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              alignment: Alignment.topCenter,
              padding: EdgeInsets.only(left: 40, right: 40, top: 0),
              child: Text(
                "Iniciar sesión",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 20),
                textAlign: TextAlign.left,
              ),
            ),
            SizedBox(height: size.height * 0.035),
            // Campo de texto para ingresar el nombre de usuario
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.symmetric(horizontal: 40),
              child: Transform.scale(
                scale: 1.2,
                child: Container(
                  width: 200, // Ajusta el ancho del contenedor
                  height: 40, // Ajusta la altura del contenedor
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: TextField(
                    cursorColor: Colors.white,
                    style: TextStyle(
                      fontSize: 11, // Tamaño de letra más pequeño
                      color: Colors.white, // Color del texto
                    ),
                    decoration: InputDecoration(
                      labelText: "Nombre de usuario",
                      fillColor: Colors.transparent,
                      filled: true,
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white, width: 2),
                      ),
                      labelStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      border: InputBorder.none,
                    ),
                    controller: _usernameController,
                  ),
                ),
              ),
            ),
            SizedBox(height: size.height * 0.03),
            // Botón para iniciar sesión
            Container(
              alignment: Alignment.centerRight,
              margin: EdgeInsets.symmetric(horizontal: 60),
              child: ElevatedButton(
                onPressed: () => _signIn(context),
                style: ButtonStyle(
                  shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(80.0),
                    ),
                  ),
                  backgroundColor:
                      WidgetStateProperty.all<Color>(Colors.transparent),
                  padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
                      EdgeInsets.zero),
                  elevation: WidgetStateProperty.all<double>(0),
                ),
                child: Ink(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color.fromARGB(255, 138, 166, 143),
                        Color.fromARGB(255, 0, 166, 36)
                      ],
                    ),
                    borderRadius: BorderRadius.circular(80.0),
                  ),
                  child: InkWell(
                    child: Container(
                      alignment: Alignment.center,
                      height: 40,
                      width: size.width * 0.475,
                      padding: const EdgeInsets.all(0),
                      child: Text(
                        "Ingresar",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
              child: GestureDetector(
                onTap: () {
                  // Navegar a la página de registro
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignUp()),
                  );
                },
                child: Text(
                  "REGÍSTRATE",
                  style: TextStyle(fontSize: 13, color: Colors.red),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
