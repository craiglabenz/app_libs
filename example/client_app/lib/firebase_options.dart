// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDLl9SYNPPZ_Ju07d59KeQ6c2da6-ExlpY',
    appId: '1:704692424470:web:c638d594cbdad2484f4a37',
    messagingSenderId: '704692424470',
    projectId: 'fir-app-2eb74',
    authDomain: 'fir-app-2eb74.firebaseapp.com',
    storageBucket: 'fir-app-2eb74.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCS7pFapM4Y6tbXUzY6p82M_iYJdkfUkLI',
    appId: '1:704692424470:android:11ee2d4df75b9e5a4f4a37',
    messagingSenderId: '704692424470',
    projectId: 'fir-app-2eb74',
    storageBucket: 'fir-app-2eb74.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDFNnEYyUeZduk5j86TfoVjmk48Mv8fgFQ',
    appId: '1:704692424470:ios:ce9de0f391a251334f4a37',
    messagingSenderId: '704692424470',
    projectId: 'fir-app-2eb74',
    storageBucket: 'fir-app-2eb74.appspot.com',
    iosBundleId: 'com.example.clientApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDFNnEYyUeZduk5j86TfoVjmk48Mv8fgFQ',
    appId: '1:704692424470:ios:146a78a2636b0bd04f4a37',
    messagingSenderId: '704692424470',
    projectId: 'fir-app-2eb74',
    storageBucket: 'fir-app-2eb74.appspot.com',
    iosBundleId: 'com.example.clientApp.RunnerTests',
  );
}
