import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'firebase_options.dart'; // Carpeta de servicios de Firebase
import 'package:zamKotosh/screens/ARView.dart'; //Vista en 3D de
import 'providers/auth_state.dart';
import 'providers/app_state.dart';
import 'screens/Welcome.dart';
import 'screens/SignIn.dart';
import 'screens/SignUp.dart';
import 'screens/ForgotPassword.dart';
import 'screens/Home.dart';
import 'screens/FriendsList.dart';
import 'screens/Passport.dart';
import 'screens/Leaderboards.dart';
import 'screens/Settings.dart';
import 'screens/ParkDetails.dart';
import 'screens/Profile.dart';
import 'screens/Notifications.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    // Inicializar Firebase con las opciones de la plataforma actual
    final List<FirebaseOptions> options =
        DefaultFirebaseOptions.currentPlatform;
    await Firebase.initializeApp(
      options: options.first, // Selecciona la primera opción para inicializar
    );
    print('Firebase inicializado correctamente');
  } catch (e) {
    print('Error al inicializar Firebase: $e');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AppState>(create: (_) => AppState()),
        ChangeNotifierProvider<AuthState>(create: (_) => AuthState()),
      ],
      child: MaterialApp(
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          textTheme: GoogleFonts.poppinsTextTheme(),
        ),
        title: 'RA Fatuchos',
        debugShowCheckedModeBanner: false,
        home: Welcome(),
        routes: {
          '/Welcome': (context) => Welcome(),
          '/SignIn': (context) => SignIn(),
          '/SignUp': (context) => SignUp(),
          '/ForgotPassword': (context) => ForgotPassword(),
          '/Home': (context) => Home(),
          '/FriendsList': (context) => FriendsList(),
          '/Passport': (context) => Passports(),
          '/Leaderboards': (context) => Leaderboards(),
          '/Settings': (context) => Settings(),
          '/ParkDetails': (context) => ParkDetails(),
          '/Profile': (context) => Profile(),
          '/Notifications': (context) => Notifications(),
          '/ObjectsOnPlanesWidget': (context) => ObjectsOnPlanesWidget(),
        },
      ),
    );
  }
}
