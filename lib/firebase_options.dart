import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static List<FirebaseOptions> get currentPlatform {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return [android];
      default:
        throw UnsupportedError(
          'FirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD-vKNOtTDK4jRKaB1-xTUs_SnCEKToGSM',
    appId: '1:784295138091:android:3f381db53230bf29306b6e',
    messagingSenderId: '784295138091',
    projectId: 'mauricio-parkport-dev',
    storageBucket: 'mauricio-parkport-dev.appspot.com',
  );

  static void printFirebaseOptions(FirebaseOptions options) {
    print('apiKey: ${options.apiKey}');
    print('appId: ${options.appId}');
    print('messagingSenderId: ${options.messagingSenderId}');
    print('projectId: ${options.projectId}');
    print('storageBucket: ${options.storageBucket}');
  }
}
