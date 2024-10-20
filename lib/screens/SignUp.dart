import 'package:flutter/material.dart';
import '../providers/auth_state.dart';
import '../utils/messages.dart';
import './SignIn.dart';
import '../widgets/background_without_icon.dart';
import 'dart:io'; // Para manejar archivos
import 'package:image_picker/image_picker.dart'; // Para tomar la foto

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  late TextEditingController _nameController;
  late TextEditingController _ageController;
  File? _selfieImage;
  bool _manualAgeEntry = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _ageController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  Future<void> _takeSelfie() async {
    final picker = ImagePicker();
    try {
      final pickedFile = await picker.pickImage(
          source: ImageSource.camera,
          preferredCameraDevice: CameraDevice.front);
      if (pickedFile != null) {
        setState(() {
          _selfieImage = File(pickedFile.path);
        });
      } else {
        // Si no se pudo tomar la foto, mostrar la opción para ingresar la edad manualmente
        setState(() {
          _manualAgeEntry = true;
        });
      }
    } catch (e) {
      print("Error al tomar la selfie: $e");
      setState(() {
        _manualAgeEntry = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: BackgroundWithoutIcon(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  alignment: Alignment.topCenter,
                  padding: EdgeInsets.only(left: 40, right: 40, top: 0),
                  child: Text(
                    "Registrate",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 20),
                    textAlign: TextAlign.left,
                  ),
                ),
                SizedBox(height: size.height * 0.035),
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.symmetric(horizontal: 40),
                  child: Transform.scale(
                    scale: 1.2,
                    child: Container(
                      width: 200,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: TextField(
                        cursorColor: Colors.white,
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.white,
                        ),
                        decoration: InputDecoration(
                          labelText: "Nombre de usuario",
                          fillColor: Colors.transparent,
                          filled: true,
                          focusedBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.white, width: 2),
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
                        controller: _nameController,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: size.height * 0.03),

                // Botón para tomar la selfie
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.symmetric(horizontal: 40),
                  child: ElevatedButton(
                    onPressed: () async {
                      await _takeSelfie();
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(80.0),
                      ),
                    ),
                    child: Text("Tomar Selfie"),
                  ),
                ),

                // Mostrar la selfie si fue tomada
                if (_selfieImage != null) ...[
                  SizedBox(height: size.height * 0.03),
                  Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.symmetric(horizontal: 40),
                    child: Image.file(
                      _selfieImage!,
                      width: 150,
                      height: 150,
                    ),
                  ),
                ],

                // Si no se pudo tomar la selfie, mostrar campo para ingresar edad
                if (_manualAgeEntry) ...[
                  SizedBox(height: size.height * 0.03),
                  Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.symmetric(horizontal: 40),
                    child: Transform.scale(
                      scale: 1.2,
                      child: Container(
                        width: 200,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: TextField(
                          cursorColor: Colors.white,
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.white,
                          ),
                          decoration: InputDecoration(
                            labelText: "Ingrese su edad",
                            fillColor: Colors.transparent,
                            filled: true,
                            focusedBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.white, width: 2),
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
                          controller: _ageController,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ),
                  ),
                ],

                SizedBox(height: size.height * 0.03),

                // Botón para registrar al usuario
                Container(
                  alignment: Alignment.centerRight,
                  margin: EdgeInsets.symmetric(horizontal: 60, vertical: 5),
                  child: ElevatedButton(
                    onPressed: () async {
                      String username = _nameController.text;
                      if (_selfieImage != null || _manualAgeEntry) {
                        Errors result;

                        // Si la imagen fue tomada, pasarla a la función
                        if (_selfieImage != null) {
                          result = await AuthState()
                              .attemptSignUp(username, _selfieImage);
                        } else {
                          // Si no se pudo tomar la foto, manejar la entrada manual
                          result =
                              await AuthState().attemptSignUp(username, null);
                        }

                        if (result == Errors.none) {
                          // Mostrar mensaje de éxito y redirigir
                          showAuthMessage(context, result, 'signup');
                          Navigator.pushReplacementNamed(context, '/SignIn');
                        } else {
                          // Mostrar error
                          showAuthMessage(context, result, 'signup');
                        }
                      }
                    },
                    style: ButtonStyle(
                      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(80.0),
                        ),
                      ),
                      padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
                          EdgeInsets.zero),
                      elevation: WidgetStateProperty.all<double>(0),
                      backgroundColor:
                          WidgetStateProperty.all<Color>(Colors.transparent),
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
                      child: Container(
                        alignment: Alignment.center,
                        height: 50.0,
                        width: size.width * 0.51,
                        child: Text(
                          "Registrar",
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
              ],
            ),
          ),
        ));
  }
}
