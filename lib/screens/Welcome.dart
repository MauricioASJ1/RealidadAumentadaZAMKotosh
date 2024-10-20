import 'package:flutter/material.dart';
import '../widgets/submit_button.dart';
import '../widgets/background.dart';
import '../widgets/background_without_icon.dart';
import '../screens/SignIn.dart'; // Asegúrate de importar el widget SignIn
import '../screens/SignUp.dart';

class Welcome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Background(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: size.height * 0.05),
            Image.asset(
              "assets/images/titlecolor.png",
              width: size.width * 0.75,
              height: size.width * 0.35,
            ),
            Image.asset(
              "assets/images/homeimage.png",
              width: size.width * 1,
              height: size.width * 1.25,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 80),
              child: CustomSubmitButton(
                label: "Iniciar sesión",
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return Dialog(
                        backgroundColor: Colors.transparent,
                        child: Center(
                          child: Transform.scale(
                            scale:
                                1.2, // Escala el contenido del diálogo al 120% del tamaño original
                            child: Stack(
                              children: [
                                SizedBox(
                                  width: size.width,
                                  height: size.height *
                                      0.5, // Limita el tamaño del pop-up
                                  child: BackgroundWithoutIcon(
                                    child:
                                        SignIn(), // Utiliza el widget SignIn como el contenido del diálogo
                                  ),
                                ),
                                Positioned(
                                  right: 0.0,
                                  child: IconButton(
                                    icon: Icon(Icons.close,
                                        color: const Color.fromARGB(
                                            255, 253, 0, 0)),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            SizedBox(height: size.height * 0.03),
            Container(
              alignment: Alignment.centerRight,
              margin: EdgeInsets.symmetric(horizontal: 60, vertical: 5),
              child: GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return Dialog(
                        backgroundColor: Colors.transparent,
                        child: Center(
                          child: Transform.scale(
                            scale:
                                1.2, // Escala el contenido del diálogo al 120% del tamaño original
                            child: Stack(
                              children: [
                                SizedBox(
                                  width: size
                                      .width, // Ajusta el ancho del diálogo según lo necesario
                                  height: size.height *
                                      0.5, // Ajusta la altura del diálogo según lo necesario
                                  child: BackgroundWithoutIcon(
                                    child:
                                        SignUp(), // Utiliza el widget SignUp como el contenido del diálogo
                                  ),
                                ),
                                Positioned(
                                  right: 0.0,
                                  child: IconButton(
                                    icon: Icon(Icons.close,
                                        color: const Color.fromARGB(
                                            255, 253, 0, 0)),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
                child: Text(
                  "¿Aún no tienes una cuenta? Regístrate",
                  style: TextStyle(
                    fontSize: 12,
                    color: Color.fromARGB(255, 253, 0, 0),
                  ),
                ),
              ),
            ),
            SizedBox(height: size.height * 0.05),
          ],
        ),
      ),
    );
  }
}
