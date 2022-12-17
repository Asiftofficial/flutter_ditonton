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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyBjSP4Vxpht_TMbZH8esYff72pc986Msrs',
    appId: '1:679097157912:web:97ec5783dfbefd2841b66d',
    messagingSenderId: '679097157912',
    projectId: 'ditonton-5f2e1',
    authDomain: 'ditonton-5f2e1.firebaseapp.com',
    storageBucket: 'ditonton-5f2e1.appspot.com',
    measurementId: 'G-C099CN2VCE',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBdtPukInbEMNnwIbmGcU_i9d76GyhDPJY',
    appId: '1:679097157912:android:44d970104dec683041b66d',
    messagingSenderId: '679097157912',
    projectId: 'ditonton-5f2e1',
    storageBucket: 'ditonton-5f2e1.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDqvmc2jH0tvwUstr_wlEILSKtnp7aJSxQ',
    appId: '1:679097157912:ios:86e410b5d4c38d6f41b66d',
    messagingSenderId: '679097157912',
    projectId: 'ditonton-5f2e1',
    storageBucket: 'ditonton-5f2e1.appspot.com',
    iosClientId:
        '679097157912-gog9utrrulo2k8f7acb5ngi326kdcpsv.apps.googleusercontent.com',
    iosBundleId: 'com.dicoding.ditonton',
  );
}
