import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart'; // Para tomar una imagen
import 'package:http/http.dart'
    as http; // Para hacer solicitudes HTTP a Clarifai
import '../models/user.dart';
import 'package:dartz/dartz.dart';

enum Errors {
  none,
  cameraError,
  blurryImageError,
  rekognitionError,
  error,
  faceRecognitionError,
}

class AuthState extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  PPUser? _currentUser;

  PPUser? get currentUser => _currentUser;

  AuthState() {
    _auth.authStateChanges().listen(_onAuthStateChanged);
  }

  Future<void> _onAuthStateChanged(User? firebaseUser) async {
    if (firebaseUser == null) {
      _currentUser = null;
    } else {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(firebaseUser.uid)
          .get();
      _currentUser = PPUser.fromJson(snapshot.data()!);
    }
    notifyListeners();
  }

  // Método para tomar una selfie usando la cámara frontal
  Future<File?> _capturePhoto() async {
    final picker = ImagePicker();
    try {
      final pickedFile = await picker.pickImage(
        source: ImageSource.camera,
        preferredCameraDevice: CameraDevice.front, // Se usa la cámara frontal
      );
      if (pickedFile != null) {
        return File(pickedFile.path);
      } else {
        return null;
      }
    } catch (e) {
      print("Error al acceder a la cámara: $e");
      return null;
    }
  }

  // Método para realizar la solicitud a la API de Clarifai

  Future<List<Map<String, dynamic>>> detectAgeWithClarifai(
      String imageBase64) async {
    var url = Uri.parse(
        'https://api.clarifai.com/v2/users/clarifai/apps/demographics-age-new/models/age-demographics/versions/102391edafbe2c07bdbc128995b88e67/outputs');

    var headers = {
      'Authorization': 'Key 42a5300a97f4407f9cd10102e88262fe',
      'Content-Type': 'application/json',
    };

    var body = jsonEncode({
      "inputs": [
        {
          "data": {
            "image": {
              "base64": imageBase64,
            }
          }
        }
      ]
    });

    var response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      // Verifica si el JSON contiene la estructura esperada
      if (data['outputs'] != null &&
          data['outputs'].isNotEmpty &&
          data['outputs'][0]['data'] != null &&
          data['outputs'][0]['data']['concepts'] != null) {
        var concepts = data['outputs'][0]['data']['concepts'];

        // Imprime las edades estimadas con sus valores de confianza
        for (var concept in concepts) {
          print(
              'Edad estimada: ${concept['name']}, Confianza: ${concept['value']}');
        }

        return List<Map<String, dynamic>>.from(
            concepts); // Retornamos la lista de edades estimadas.
      } else {
        // Muestra la respuesta completa para depuración si no se encuentran los datos esperados
        print('La respuesta no contiene los datos esperados: $data');
        throw Exception('La respuesta no contiene los datos esperados.');
      }
    } else {
      throw Exception('Error: ${response.statusCode}, ${response.body}');
    }
  }

  // Método para analizar la foto usando la API de Clarifai
  Future<Either<Errors, List<Map<String, dynamic>>>> _analyzePhotoWithClarifai(
      File imageFile) async {
    try {
      // Convertir la imagen a base64
      List<int> imageBytes = await imageFile.readAsBytes();
      String imageBase64 = base64Encode(imageBytes);

      // Llamada a Clarifai con la imagen en base64
      List<Map<String, dynamic>> ageEstimations =
          await detectAgeWithClarifai(imageBase64);

      // Comprobar si hay estimaciones de edad
      if (ageEstimations.isEmpty) {
        return Left(Errors
            .rekognitionError); // Retornar un error en caso de no haber datos
      }

      // Aquí puedes manejar la respuesta de Clarifai si es necesario.
      for (var concept in ageEstimations) {
        print(
            'Edad estimada: ${concept['name']}, Confianza: ${concept['value']}');
      }

      return Right(ageEstimations); // Retornar la lista de estimaciones
    } catch (e) {
      print('Error al analizar la imagen con Clarifai: $e');
      return Left(
          Errors.rekognitionError); // Retornar un error en caso de excepción
    }
  }

  // Método para registrar al usuario
  Future<Errors> attemptSignUp(String username, File? selfieImage) async {
    Errors _status = Errors.none;
    int? userAge;

    // Convertir el username a minúsculas y eliminar espacios
    String formattedUsername = username.toLowerCase().replaceAll(' ', '');

    // Usar el username formateado para generar el correo y la contraseña
    String email = '$formattedUsername@zamkotosh.com';
    String password = formattedUsername;

    // Intentar registrar al usuario en Firebase Authentication
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      User? signedInUser = userCredential.user;

      if (signedInUser != null) {
        print('Usuario registrado con correo: $email');

        // Si la imagen es nula, podemos solicitar la edad manualmente
        if (selfieImage == null) {
          return Errors.cameraError; // Maneja el error si no hay selfie
        }

        // Aquí puedes analizar la foto con Clarifai para obtener la edad (si es necesario)
        Either<Errors, List<Map<String, dynamic>>> result;
        try {
          result = await _analyzePhotoWithClarifai(selfieImage);
        } catch (e) {
          return Errors
              .faceRecognitionError; // Si hay un error en el reconocimiento facial
        }

        // Verificar el resultado de la llamada a Clarifai
        result.fold(
          (error) {
            return Errors.faceRecognitionError;
          },
          (ageEstimations) {
            if (ageEstimations.isNotEmpty) {
              // Seleccionar la edad con mayor confianza
              userAge = _getMostProbableAge(ageEstimations);
              print('Edad estimada: $userAge');
            } else {
              return Errors.faceRecognitionError;
            }
          },
        );

        // Intentar guardar el usuario en Firestore
        try {
          DocumentSnapshot userDoc = await FirebaseFirestore.instance
              .collection('users')
              .doc(signedInUser.uid)
              .get();

          // Si el documento no existe, lo creamos
          if (!userDoc.exists) {
            await FirebaseFirestore.instance
                .collection('users')
                .doc(signedInUser.uid)
                .set({
              'userID': signedInUser.uid,
              'username': username,
              'email': email, // Guardamos el email generado
              'age': userAge?.toString(), // Conversión de int a String
              'dateJoined': DateTime.now(),
            });
            print('Usuario creado exitosamente en Firestore');
          }
        } catch (e) {
          print('Firestore Exception: $e');
          _status = Errors.error;
        }
      }
    } catch (e) {
      print('Firebase Authentication Exception: $e');
      return Errors.none; // Manejar el error de autenticación
    }

    return _status;
  }

  int? _getMostProbableAge(List<Map<String, dynamic>> ageEstimations) {
    // Ordenamos por confianza
    ageEstimations.sort((a, b) => b['value'].compareTo(a['value']));

    // Tomamos la estimación con mayor confianza
    String? ageRange = ageEstimations.first['name'];

    if (ageRange != null) {
      // Si es un rango, extraemos el límite inferior
      if (ageRange.contains('-')) {
        String lowerBound =
            ageRange.split('-').first; // Tomamos el número más bajo del rango
        return int.tryParse(lowerBound); // Convertimos a entero
      } else {
        // Si es solo un número, intentamos convertirlo directamente
        return int.tryParse(ageRange);
      }
    }

    return null; // En caso de que no haya una edad válida
  }

  // Método para actualizar la edad manualmente si no se pudo tomar la foto
  Future<void> updateUserAge(String userId, int age) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'age': age,
      });
    } catch (e) {
      print('Error al actualizar la edad: $e');
    }
  }

  void logout() {
    _auth.signOut();
    notifyListeners();
  }
}
