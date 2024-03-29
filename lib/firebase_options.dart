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
    apiKey: 'AIzaSyA9GaMzP1aox5ZxuMemDEbnTd9vHkzO9Lg',
    appId: '1:342167863963:web:78891a1e01252cbeba7c3e',
    messagingSenderId: '342167863963',
    projectId: 'water-drinker-9000',
    authDomain: 'water-drinker-9000.firebaseapp.com',
    storageBucket: 'water-drinker-9000.appspot.com',
    measurementId: 'G-MKW4VY96XG',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBp_eTbeaFueNN-TT3fDW4-qEkhibkOO68',
    appId: '1:342167863963:android:514d95561ecfbdc2ba7c3e',
    messagingSenderId: '342167863963',
    projectId: 'water-drinker-9000',
    storageBucket: 'water-drinker-9000.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyB-SzbVFqr5o0hvnZ2LZmE4dFEykbPx2hc',
    appId: '1:342167863963:ios:00f1e83926196eb4ba7c3e',
    messagingSenderId: '342167863963',
    projectId: 'water-drinker-9000',
    storageBucket: 'water-drinker-9000.appspot.com',
    iosBundleId: 'com.example.macrohard',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyB-SzbVFqr5o0hvnZ2LZmE4dFEykbPx2hc',
    appId: '1:342167863963:ios:78bce4872cb8a4c7ba7c3e',
    messagingSenderId: '342167863963',
    projectId: 'water-drinker-9000',
    storageBucket: 'water-drinker-9000.appspot.com',
    iosBundleId: 'com.example.macrohard.RunnerTests',
  );
}
